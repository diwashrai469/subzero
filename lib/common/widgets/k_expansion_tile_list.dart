import 'package:flutter/material.dart';

class KexpansionTileList extends StatelessWidget {
  final Widget title;
  final List<Widget> children;
  const KexpansionTileList({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: Border.all(color: Colors.transparent),
      title: title,
      children: children,
    );
  }
}
