import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  // final Widget desktopBody;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    // required this.tabletBody,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // if (constraints.maxWidth < 600) {
          // Display mobile layout if width is less than 600 pixels
          return mobileBody;
        // } else {
          // Display desktop layout if width is 600 pixels or more
          // return tabletBody;
          // return Container();
        // }
      },
    );
  }
}
