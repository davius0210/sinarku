import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sinarku/helper/colors_helper.dart';

class LabelSyaratdanketentuanComponent extends StatelessWidget {
  const LabelSyaratdanketentuanComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: 'Dengan mengklik lanjutan, Anda menyetujui '),
            TextSpan(
              text: 'Syarat Layanan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
            TextSpan(text: ' dan '),
            TextSpan(
              text: 'Kebijakan Privasi Kami.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  print('tesssssss');
                },
            ),
          ],
          style: TextStyle(color: ColorsHelper.hint),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
