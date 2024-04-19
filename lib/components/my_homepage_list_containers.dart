import 'package:flutter/material.dart';

class MyHomePageListContainers extends StatelessWidget {
  final String titleText;
  final String detailText;
  const MyHomePageListContainers({
    super.key,
    required this.titleText,
    required this.detailText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            titleText,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            detailText,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }
}
