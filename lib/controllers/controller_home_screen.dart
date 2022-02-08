import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  var selectedPage = 0.obs;

  void changePageIndex(int index) {
    selectedPage.value = index;
  }
}
