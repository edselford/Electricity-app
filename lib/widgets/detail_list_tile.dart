import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme, Divider;

class DetailListTile extends StatelessWidget {
  final String title;
  final Widget value;
  final bool isLast;

  const DetailListTile({
    Key? key,
    required this.title,
    required this.value,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(top: 19, left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: Theme.of(context).textTheme.headline2),
                value,
              ],
            ),
            (isLast) ? const SizedBox() : const Divider(),
          ],
        ),
      ),
    );
  }
}
