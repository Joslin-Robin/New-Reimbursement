import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("404 Error"), backgroundColor: Color(0xFF135587)),
      body: Center(
        child: Text('Oops! seems like the link is not working!'),
      ),
    );

  }
}
