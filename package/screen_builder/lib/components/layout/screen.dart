import 'package:flutter/material.dart';

/// Builds a Screen component from props (acts as a container for the page)
Widget buildScreen(BuildContext context, Map<String, dynamic> props) {
  debugPrint('buildScreen: props=$props');
  final children = props['children'];
  if (children is List<Widget>) {
    if (children.isNotEmpty && children.first is AppBar) {
      final appBar = children.first as PreferredSizeWidget;
      final bodyChildren = children.sublist(1);
      return Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Column(
            children: bodyChildren,
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: children,
        ),
      );
    }
  }
  return Container();
}
