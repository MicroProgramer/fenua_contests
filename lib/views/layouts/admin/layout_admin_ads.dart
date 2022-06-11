import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/models/ad.dart';
import 'package:fenua_contests/widgets/custom_button.dart';
import 'package:fenua_contests/widgets/custom_input_field.dart';
import 'package:fenua_contests/widgets/not_found.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:video_compress/video_compress.dart';

import '../../../helpers/constants.dart';

class LayoutAdminAds extends StatefulWidget {
  const LayoutAdminAds({Key? key}) : super(key: key);

  @override
  State<LayoutAdminAds> createState() => _LayoutAdminAdsState();
}

class _LayoutAdminAdsState extends State<LayoutAdminAds> {
  String selectedType = "image";
  int imageMaxSize = 1024 * 1024;
  int videoMaxSize = (1024 * 5 * 1024);
  var _picker = FilePicker.platform;
  bool readyToUpload = false;
  FilePickerResult? pickedFile;
  late File thumbnailFile;
  String fileDetails = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appSecondaryColor,
      body: StreamBuilder<QuerySnapshot>(
          stream: adsRef.where("user_id", isEqualTo: "admin").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator.adaptive();
            }
            var ads = snapshot.data!.docs.map((e) => Ad.fromMap(e.data() as Map<String, dynamic>)).toList();
            return ads.isNotEmpty
                ? ListView.builder(
                    itemBuilder: (_, index) {
                      Ad ad = ads[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(ad.title),
                          subtitle: Text(ad.description),
                          tileColor: Colors.white,
                          isThreeLine: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              Get.defaultDialog(
                                  title: "Delete Ad",
                                  middleText: "Are you sure to delete this ad?",
                                  onConfirm: () {
                                    adsRef.doc(ad.id).delete();
                                    Get.back();
                                  },
                                  confirmTextColor: Colors.white,
                                  onCancel: () {
                                    Get.back();
                                  },
                                  textConfirm: "Delete",
                                  textCancel: "Cancel");
                            },
                          ),
                        ),
                      );
                    },
                    itemCount: ads.length,
                  )
                : NotFound(
                    message: "No ads yet",
                    color: Colors.white,
                  );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                readyToUpload = false;
                var loading = false;
                String title = "";
                String des = "";
                return StatefulBuilder(builder: (_, setState) {
                  return AlertDialog(
                    title: Text("New Ad"),
                    content: ModalProgressHUD(
                      inAsyncCall: loading,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomInputField(
                            hint: "Title",
                            isPasswordField: false,
                            onChange: (value) {
                              title = value.toString();
                            },
                            keyboardType: TextInputType.name,
                          ),
                          CustomInputField(
                            hint: "Description",
                            isPasswordField: false,
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            onChange: (value) {
                              des = value.toString();
                            },
                          ),
                          Text(
                            "Ad type",
                            style: normal_h3Style_bold.copyWith(color: Colors.black),
                          ),
                          RadioListTile(
                            title: Text("Image"),
                            groupValue: selectedType,
                            value: 'image',
                            secondary: Text("Max: ${calculateSize(imageMaxSize, 1)}"),
                            onChanged: (String? value) {
                              setState(() {
                                readyToUpload = false;
                                selectedType = value!;
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text("Video"),
                            groupValue: selectedType,
                            value: 'video',
                            secondary: Text("Max: ${calculateSize(videoMaxSize, 1)}"),
                            onChanged: (String? value) {
                              setState(() {
                                readyToUpload = false;
                                selectedType = value!;
                              });
                            },
                          ),
                          CustomButton(
                            color: appPrimaryColor,
                            child: Text(
                              "Choose $selectedType file",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              readyToUpload = await pickFile(selectedType == "image");
                              setState(() {});
                            },
                          ),
                          if (readyToUpload && pickedFile != null)
                            Column(
                              children: [
                                Container(
                                  height: Get.height * 0.2,
                                  width: Get.width * 0.3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          image: FileImage(selectedType == 'image' ? File(pickedFile!.files.first.path!) : thumbnailFile))),
                                ),
                                ListTile(
                                  title: Text(fileDetails),
                                ),
                                CustomButton(
                                  color: appPrimaryColor,
                                  child: Text(
                                    "Start Upload",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    if (title.isEmail || des.isEmpty) {
                                      Get.snackbar("Alert", "All fields are required");
                                      return;
                                    }
                                    String id = DateTime.now().millisecondsSinceEpoch.toString();
                                    setState(() {
                                      loading = true;
                                    });
                                    String response = await uploadFile(id, title, des);
                                    setState(() {
                                      loading = false;
                                    });
                                    Get.back();
                                    if (response == "success") {
                                      Get.snackbar("Success", "Uploaded successfully");
                                    } else {
                                      Get.snackbar("Error", response);
                                    }
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                });
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<bool> pickFile(bool imageType) async {
    bool ready = false;
    pickedFile = await _picker.pickFiles(
      type: imageType ? FileType.image : FileType.video,
    );
    if (pickedFile != null) {
      var file = pickedFile!.files.first;
      if (imageType) {
        var decodedImage = await decodeImageFromList(File(file.path!).readAsBytesSync());
        var orientation = "${decodedImage.width} x ${decodedImage.height}";
        var size = await getFileSize(file.path!, 1);
        fileDetails = orientation + "\n$size";
        ready = file.size < imageMaxSize;
        if (!ready) {
          Get.snackbar("Alert", "Image too large");
        }
      } else {
        final videoInfo = FlutterVideoInfo();
        var info = (await videoInfo.getVideoInfo(file.path!))!;
        thumbnailFile = (await _generateThumbnail(file.path!))!;
        var fileSize = await getFileSize(file.path!, 1);
        fileDetails = "${(info.duration! / 1000).round()} seconds\n$fileSize";
        ready = file.size < videoMaxSize && (info.duration! < 30000);
        if (!ready) {
          Get.snackbar("Alert", "Video file too large");
        }
      }
    }
    return ready;
  }

  Future<String> getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    return calculateSize(bytes, decimals);
  }

  String calculateSize(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    // num mod = pow(10, decimals);
    var value = (bytes / pow(1024, i));
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    return ("${value.toStringAsFixed(decimals)} " + suffixes[i]);
  }

  Future<File?> _generateThumbnail(String path) async {
    return await VideoCompress.getFileThumbnail(path,
        quality: 50, // default(100)
        position: -1 // default(-1)
        );
  }

  Future<String> uploadFile(String id, String title, String des) async {
    String response = "";

    String extension = pickedFile!.files.first.extension!;
    String url = await _uploadFile(id, extension, "admin");
    Ad ad = Ad(
        id: id,
        user_id: "admin",
        title: title,
        description: des,
        endTimestamp: 0,
        mediaUrl: url,
        adType: selectedType,
        impressions: 0,
        clickUrl: "clickUrl");
    await adsRef.doc(id).set(ad.toMap()).then((value) {
      response = "success";
    }).catchError((onError) {
      response = onError.toString();
    });

    return response;
  }

  Future<String> _uploadFile(String adId, String extension, String uploader) async {
    if (pickedFile == null) {
      return "";
    }

    File file = File(pickedFile!.files.first.path!);
    Get.snackbar("Uploading Image", "Uploading organizer image to database");
    Reference storageReference = FirebaseStorage.instance.ref().child("custom_ads/$uploader/$adId.$extension");
    final UploadTask uploadTask = storageReference.putFile(file);

    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = await downloadUrl.ref.getDownloadURL();
    return url;
  }
}
