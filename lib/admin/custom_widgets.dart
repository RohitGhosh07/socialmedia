import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomWidgets {
  static successSnackBar(
      {required String content, Color textColor = Colors.black}) {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    return Get.snackbar('Success', content,
        backgroundColor: Colors.green[100]!.withOpacity(0.8),
        borderRadius: 10,
        colorText: textColor);
  }

  static errorSnackBar({
    required String content,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.closeAllSnackbars();
    // if (Get.isSnackbarOpen) {
    //   Get.closeAllSnackbars();
    // }
    return Get.snackbar('Error', content,
        backgroundColor: Colors.red[400],
        colorText: textColor,
        borderRadius: 10,
        duration: duration);
  }

  static showLoadingLoader() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (_) => Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              margin: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoActivityIndicator(
                        color: Colors.white,
                        radius: 15,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Please wait...",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      );
    });
  }
}
