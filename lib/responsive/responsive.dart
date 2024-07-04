import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget tabletBody;

  const ResponsiveLayout({
    Key? key,
    required this.mobileBody,
    required this.tabletBody,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine orientation based on width and height comparison
        bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

        // Adjust based on max width for responsiveness
        if (constraints.maxWidth < 600 || constraints.maxHeight < 350) {
          return mobileBody; // Use mobileBody for widths less than 600
        } else {
          // Use tabletBody and consider orientation for landscape adjustments
          return isPortrait ? mobileBody : tabletBody;
        }
      },
    );
  }
}
