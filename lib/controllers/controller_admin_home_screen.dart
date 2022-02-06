import 'package:get/get.dart';

class AdminHomeScreenController extends GetxController {
  var selectedPage = 0.obs;

  void changePageIndex(int index) {
    selectedPage.value = index;
  }

}