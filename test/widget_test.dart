// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sinarku/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const PersistentTabView(
        controller: controller.tabController,
        tabs: [
          PersistentTabConfig(
            screen: Text('Pengaturan'),
            item: ItemConfig(
              icon: Icon(CupertinoIcons.gear, color: Colors.white),
              inactiveIcon: Icon(CupertinoIcons.gear, color: Colors.white),
              title: "Pengaturan",
              activeForegroundColor: Colors.white,
            ),
          ),
          PersistentTabConfig(
            screen: Text('Daftar Data'),
            item: ItemConfig(
              icon: Icon(CupertinoIcons.list_bullet, color: Colors.white),
              inactiveIcon: Icon(
                CupertinoIcons.list_bullet,
                color: Colors.white,
              ),
              title: "Daftar Data",
              activeForegroundColor: Colors.white,
            ),
          ),
          PersistentTabConfig(
            screen: Text('Maps'),
            item: ItemConfig(
              icon: Icon(FontAwesomeIcons.mapPin),
              title: "Rekam Toponim",
            ),
          ),
          PersistentTabConfig(
            screen: Text('Rekam Jejak'),
            item: ItemConfig(
              icon: Icon(Icons.directions_walk, color: Colors.white),
              title: "Rekam Jejak",
              inactiveIcon: Icon(Icons.directions_walk),
            ),
          ),
          PersistentTabConfig(
            screen: Text('Saya'),
            item: ItemConfig(
              icon: Icon(Icons.person, color: Colors.white),
              title: "Saya",
              inactiveIcon: Icon(Icons.person),
            ),
          ),
        ],
        navBarBuilder: (NavBarConfig navBarConfig) {
          return CustomBottomNavBar(
            navBarConfig: navBarConfig,
            navBarDecoration: NavBarDecoration(
              color: ColorsHelper.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            onPressMiddle: () async {
              print('wwwwpw');
              controller.tabController.jumpToTab(2);
            },
          );
        },
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
