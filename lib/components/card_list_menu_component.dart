import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sinarku/components/sperator_component.dart';
import 'package:sinarku/helper/colors_helper.dart';

class CardTileMenu {
  final Widget title;
  final Widget? subtitle;
  final Widget? suffix;
  final Widget? prefix;
  final Color? backgroundColor;

  final Function()? onPressed;

  CardTileMenu({
    required this.title,
    this.onPressed,
    this.subtitle,
    this.suffix,
    this.prefix,
    this.backgroundColor,
  });
}

class CardListMenuComponent extends StatelessWidget {
  final List<CardTileMenu> items;
  final Color? backgroundColor;
  final double? minHeight;
  const CardListMenuComponent({
    super.key,
    required this.items,
    this.backgroundColor,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Ink(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            ...items.asMap().entries.map((entry) {
              int index = entry.key;
              var val = entry.value;
              final tile = Ink(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: val.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: index == 0 ? Radius.circular(10) : Radius.zero,
                    topRight: index == 0 ? Radius.circular(10) : Radius.zero,
                    bottomLeft: index == items.length - 1
                        ? Radius.circular(10)
                        : Radius.zero,
                    bottomRight: index == items.length - 1
                        ? Radius.circular(10)
                        : Radius.zero,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (val.prefix != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: val.prefix!,
                      ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          val.title,
                          if (val.subtitle != null) val.subtitle!,
                        ],
                      ),
                    ),
                    if (val.suffix != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: val.suffix!,
                      ),
                    if (val.onPressed != null)
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          CupertinoIcons.right_chevron,
                          size: 20,
                          color: ColorsHelper.hint,
                        ),
                      ),
                  ],
                ),
              );
              return InkWell(
                onTap: val.onPressed,
                child: Column(
                  children: [
                    if (index != 0)
                      const BarcodeSeparator(
                        height: 1,
                        barWidth: 3,
                        spacing: 3,
                      ), // tampilkan dot di tengah & akhir
                    tile,
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
