import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

class FunctionHelper {
  static void showDialog(
    BuildContext context, {
    Function(bool result)? onResult,
    Widget? content,
    Widget? icon,
    String? title,
    Widget? footer,
    double? height,
  }) {
    showModalBottomSheet<void>(
      context: context,
      clipBehavior: Clip.none,
      builder: (BuildContext context) {
        return Container(
          height: height ?? 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (title != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            if (onResult != null) {
                              onResult(false);
                            }
                          },
                          icon: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (icon != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: icon,
                                  ),
                              ],
                            ),
                            if (content != null) content,
                          ],
                        ),
                      ],
                    ),
                  ),
                  footer ?? SizedBox(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Stream<double?> getHeadingStream() {
    return FlutterCompass.events!.map((event) {
      return event.heading; // 0 - 360 derajat
    });
  }
}
