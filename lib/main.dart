import 'package:flutter/material.dart';
import 'package:flutter_new_reimbursement/screens/authenticationScreen.dart';
import 'package:flutter_new_reimbursement/utils.dart';

void main() {
  runApp(Reimbursement());
}

class Reimbursement extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _ReimbursementState createState() => _ReimbursementState();
}

class _ReimbursementState extends State<Reimbursement> {
  DeviceInfo _deviceInfo = new DeviceInfo();
  String deviceId;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reimbursement',
      home: GettingInfoScreen(),
    );
  }
}
