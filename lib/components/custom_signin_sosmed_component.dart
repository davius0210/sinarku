import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
enum ButtonsSocialMedia {
  Apple,
  Google,
  Facebook,
  Instagram,
  Twitter,
  LinkedIn,
  YouTube,
  WhatsApp,
  GitHub,
  GitLab,
  TikTok,
}

class SocialMediaButtonBuilder extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Widget? iconWidget;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final ShapeBorder? shape;
  final double? width;
  final bool mini;
  final double elevation;
  final EdgeInsets padding;
  final EdgeInsets? innerPadding;
  final double height;

  const SocialMediaButtonBuilder({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.onPressed,
    this.shape,
    this.width,
    this.mini = false,
    this.elevation = 2.0,
    this.padding = const EdgeInsets.all(0),
    this.innerPadding,
    this.height = 50,
    this.iconWidget
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: padding,
      child: MaterialButton(
        elevation: elevation,
        color: backgroundColor,
        shape: shape ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        height: height,
        onPressed: onPressed,
        padding: innerPadding ?? const EdgeInsets.all(8),
        child: mini
            ? Icon(icon, color: textColor, size: 18)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: iconWidget==null ? Icon(icon, size: 18, color: textColor) : iconWidget,
                    ),
                  Text(text, style: TextStyle(color: textColor)),
                ],
              ),
      ),
    );
  }
}

class SocialMediaButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final ButtonsSocialMedia button;
  final bool mini;
  final ShapeBorder? shape;
  final String? text;
  final EdgeInsets padding;
  final double elevation;
  final double? width;

  const SocialMediaButton(
    this.button, {
    super.key,
    required this.onPressed,
    this.mini = false,
    this.padding = const EdgeInsets.all(0),
    this.shape,
    this.text,
    this.elevation = 2.0,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    switch (button) {
      case ButtonsSocialMedia.Apple:
        return SocialMediaButtonBuilder(
          key: const ValueKey('Apple'),
          mini: mini,
          text: text ?? 'Apple',
          icon: FontAwesomeIcons.apple,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          width: width,
          elevation: elevation,
        );
      case ButtonsSocialMedia.Google:
         return SocialMediaButtonBuilder(
          key: const ValueKey('Google'),
          mini: mini,
          text: text ?? 'Google',
          icon: FontAwesomeIcons.google,
          iconWidget: Image(image: AssetImage('assets/images/google_light.png'),height: 36,),
          backgroundColor: Colors.white,
          textColor: Colors.black,
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          width: width,
          elevation: elevation,
        );
      case ButtonsSocialMedia.Facebook:
        return SocialMediaButtonBuilder(
          key: const ValueKey('Facebook'),
          mini: mini,
          text: text ?? 'Facebook',
          icon: FontAwesomeIcons.facebookF,
          backgroundColor: const Color(0xFF1877f2),
          textColor: Colors.white,
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          width: width,
          elevation: elevation,
        );

      case ButtonsSocialMedia.Instagram:
        return SocialMediaButtonBuilder(
          key: const ValueKey('Instagram'),
          mini: mini,
          text: text ?? 'Instagram',
          icon: FontAwesomeIcons.instagram,
          backgroundColor: const Color(0xFFE1306C),
          textColor: Colors.white,
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          width: width,
          elevation: elevation,
        );

      case ButtonsSocialMedia.Twitter:
        return SocialMediaButtonBuilder(
          key: const ValueKey('Twitter'),
          mini: mini,
          text: text ?? 'Twitter',
          icon: FontAwesomeIcons.xTwitter,
          backgroundColor: const Color(0xFF000000),
          textColor: Colors.white,
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          width: width,
          elevation: elevation,
        );

      case ButtonsSocialMedia.LinkedIn:
        return SocialMediaButtonBuilder(
          key: const ValueKey('LinkedIn'),
          mini: mini,
          text: text ?? 'LinkedIn',
          icon: FontAwesomeIcons.linkedinIn,
          backgroundColor: const Color(0xFF007BB6),
          textColor: Colors.white,
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          width: width,
          elevation: elevation,
        );

      case ButtonsSocialMedia.YouTube:
        return SocialMediaButtonBuilder(
          key: const ValueKey('YouTube'),
          mini: mini,
          text: text ?? 'YouTube',
          icon: FontAwesomeIcons.youtube,
          backgroundColor: const Color(0xFFFF0000),
          textColor: Colors.white,
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          width: width,
          elevation: elevation,
        );

      case ButtonsSocialMedia.WhatsApp:
        return SocialMediaButtonBuilder(
          key: const ValueKey('WhatsApp'),
          mini: mini,
          text: text ?? 'WhatsApp',
          icon: FontAwesomeIcons.whatsapp,
          backgroundColor: const Color(0xFF25D366),
          textColor: Colors.white,
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          width: width,
          elevation: elevation,
        );

      case ButtonsSocialMedia.GitHub:
        return SocialMediaButtonBuilder(
          key: const ValueKey('GitHub'),
          mini: mini,
          text: text ?? 'GitHub',
          icon: FontAwesomeIcons.github,
          backgroundColor: const Color(0xFF444444),
          textColor: Colors.white,
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          width: width,
          elevation: elevation,
        );

      case ButtonsSocialMedia.GitLab:
        return SocialMediaButtonBuilder(
          key: const ValueKey('GitLab'),
          mini: mini,
          text: text ?? 'GitLab',
          icon: FontAwesomeIcons.gitlab,
          backgroundColor: const Color(0xFFFC6D26),
          textColor: Colors.white,
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          width: width,
          elevation: elevation,
        );

      case ButtonsSocialMedia.TikTok:
        return SocialMediaButtonBuilder(
          key: const ValueKey('TikTok'),
          mini: mini,
          text: text ?? 'TikTok',
          icon: FontAwesomeIcons.tiktok,
          backgroundColor: const Color(0xFF000000),
          textColor: Colors.white,
          onPressed: onPressed,
          padding: padding,
          shape: shape,
          width: width,
          elevation: elevation,
        );
    }
  }
}