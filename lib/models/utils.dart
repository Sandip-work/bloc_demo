import 'package:flutter_easyloading/flutter_easyloading.dart';

class Utils {
   static void showLoader() {
     EasyLoading.show(status: 'Loading...');
   }

   static void hideLoader() {
     EasyLoading.dismiss();
   }
 }