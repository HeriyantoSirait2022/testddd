import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      padding: EdgeInsets.all(10),
      child: Text(
        "Empty no data found 🤷‍♀️",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
