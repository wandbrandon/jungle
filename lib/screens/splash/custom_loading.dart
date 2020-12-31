import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(height: 50, width: 50, child: CircularProgressIndicator.adaptive())
    );
  }
}