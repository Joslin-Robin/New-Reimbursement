import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_reimbursement/models/reimbursement.dart';

import 'package:flutter_new_reimbursement/screens/errorScreen.dart';
import 'package:flutter_new_reimbursement/utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_new_reimbursement/screens/reimbursementDetailsScreen.dart';
class ReimbursementListScreen extends StatefulWidget {
  final String token;
  ReimbursementListScreen({Key key, this.token}) : super(key: key);

  @override
  _ReimbursementListScreenState createState() =>
      _ReimbursementListScreenState();
}

class _ReimbursementListScreenState extends State<ReimbursementListScreen> {


  void _renderReimbursementListWidget() {

    var list = <Widget>[];

    for (var reimbursement in _reimbursements) {
      var item =
      ListTile(
        title: Text( '₱ '  ),
        subtitle: Text(reimbursement.code??""),
        trailing: Icon(Icons.keyboard_arrow_right),
        //onTap: () {
       //   _navigationToDetails(reimbursement..toString()??"");
       // },
      );
      list.add(item);
    }

    setState(() {
      _reimbursementListWidget = list;
    });
  }
  Future<void> _init() async {
    await _getReimbursments();
    _renderReimbursementListWidget();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }


  Future<void> _getReimbursments() async {
    String reimbursementListUrl = "http://new.asi.com.ph/Reimbursements/GetLimitedList?token=${widget.token}&count=30";
    Response responseval=await Dio().get(reimbursementListUrl);

    print(responseval.data);

    if (responseval.statusCode == 404) {
      return Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => ErrorScreen(),
        ),
      );
    }
    else if(responseval.statusCode == 200)
      {
        var code=responseval.data['data'][0]['Code'].toString();
        print(code);

        for (var item in responseval.data) {
          print(item);
          var reimbursement = ReimbursementListData.fromJson(item);
          _reimbursements.add(reimbursement);
        }



      }
    else{
      throw Exception('Failed to load Reimbursement');
    }

  }

  _navigationToDetails(reimbursementId) {
    Route route = MaterialPageRoute(      builder: (context) =>
        ReimbursementListScreen(
    //  reimbursementId: reimbursementId,
    ),

    );
    Navigator.push(context, route);
  }
  List<Widget> _reimbursementListWidget = <Widget>[
    Center(child: Text('Loading ...'))
  ];

  List<ReimbursementListData> _reimbursements = new List<ReimbursementListData>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Reimbursement"), backgroundColor: Color(0xFF135587)),
      body: SingleChildScrollView(
        child: Column(
          children: _reimbursementListWidget,
        ),
      ),
    );
  }
}
