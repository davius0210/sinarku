import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sinarku/helper/colors_helper.dart';

class CustomBottomNavBar extends StatelessWidget {
  CustomBottomNavBar({
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
    this.height,
    this.middleItemSize = 50,
    this.onPressMiddle,
    this.onPressedTab,
    super.key,
  }) : assert(
         navBarConfig.items.length.isOdd,
         "The number of items must be odd for this style",
       );

  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;
  final double? height;
  final double middleItemSize;
  final Function()? onPressMiddle;
  final Function(int index)? onPressedTab;

  Widget _buildItem(BuildContext context, ItemConfig item, bool isSelected) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 5),
          IconTheme(
            data: IconThemeData(
              size: item.iconSize,
              color: isSelected ? ColorsHelper.primary : ColorsHelper.disable,
            ),
            child: isSelected ? item.icon : item.inactiveIcon,
          ),
          if (item.title != null)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: FittedBox(
                child: Text(
                  item.title!,
                  style: item.textStyle.apply(
                    color: isSelected ? Colors.white : ColorsHelper.disable,
                  ),
                ),
              ),
            ),
        ],
      );

  Widget _buildMiddleItem(ItemConfig item, bool isSelected) => Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        width: middleItemSize,
        height: middleItemSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorsHelper.primary,

          boxShadow: navBarDecoration.boxShadow,
        ),
        child: Center(
          child: IconTheme(
            data: IconThemeData(size: item.iconSize, color: Colors.white),
            child: isSelected ? item.icon : item.inactiveIcon,
          ),
        ),
      ),
      if (item.title != null)
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FittedBox(
              child: Text(
                item.title!,
                style: item.textStyle.apply(color: Colors.white),
              ),
            ),
          ),
        ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final midIndex = (navBarConfig.items.length / 2).floor();
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 23),
            DecoratedNavBar(
              decoration: navBarDecoration,
              height: height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: navBarConfig.items.map((item) {
                  final int index = navBarConfig.items.indexOf(item);
                  return Expanded(
                    child: InkWell(
                      onTap: () {
                        navBarConfig.onItemSelected(index);
                        if (onPressedTab != null) onPressedTab!(index);
                      },
                      child: index == midIndex
                          ? Container()
                          : _buildItem(
                              context,
                              item,
                              navBarConfig.selectedIndex == index,
                            ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          child: Center(
            child: GestureDetector(
              onTap: () {
                //navBarConfig.onItemSelected(midIndex);
                if (onPressMiddle != null) onPressMiddle?.call();
              },
              child: _buildMiddleItem(
                navBarConfig.items[midIndex],
                navBarConfig.selectedIndex == midIndex,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
