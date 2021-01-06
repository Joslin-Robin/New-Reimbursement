import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_new_reimbursement/list.dart';
import 'package:flutter_new_reimbursement/shared_preference_keys.dart';
import 'package:flutter_new_reimbursement/utils.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationScreen extends StatefulWidget {
  final String deviceId;

  const AuthenticationScreen({Key key, this.deviceId}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.deviceId ?? "");
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            authenticatorUIHeader(),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 70,
                            padding: const EdgeInsets.all(20.0),
                            color: Colors.blue,
                            child: Icon(
                              Icons.lock_sharp,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                              child: Container(
                            padding: const EdgeInsets.all(20.0),
                            child: SelectableText(
                              widget.deviceId ?? "",
                              textScaleFactor: 2,
                              style: TextStyle(
                                  fontSize: 10.0, color: Colors.white),
                            ),
                          ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              child: Container(
                  child: Text('Copy to clipboard',
                      style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.solid,
                          fontSize: 16))),
              onTap: () {
                Clipboard.setData(new ClipboardData(
                        text: 'Device ID:' + widget.deviceId ?? ""))
                    .then((_) {
                  Flushbar(
                    // There is also a messageText property for when you want to
                    // use a Text widget and not just a simple String
                    message: 'Device ID:' + widget.deviceId ?? "",
                    // Even the button can be styled to your heart's content
                    mainButton: FlatButton(
                      onPressed: (){},
                      child: Text(
                        'Copied',
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                    ),
                    duration: Duration(seconds: 3),
                    // Show it with a cascading operator
                  )..show(context);
                });
              },
            ),
            InkWell(
              child: Container(
                  margin: const EdgeInsets.only(top: 2),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 26),
                    child: Text('Share to Register on Workplace',
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.solid,
                          fontSize: 16,
                        )),
                  )),
              onTap: () {
                Share.share('Device ID:' + widget.deviceId ?? "");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class authenticatorUIHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 100),
          ),
          Container(
              margin: const EdgeInsets.only(top: 60),
              child: Text('Use the Device ID displayed below to authenticate',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19))),
        ],
      ),
    );
  }
}

class GettingInfoScreen extends StatelessWidget {
  void _readDeviceId(BuildContext context) async {
    DeviceInfo _deviceInfo = new DeviceInfo();
    await _deviceInfo.read();
    var tokenFromDevice = await _getTokenFromDevice() ?? "";
    var tokenFromServer = await _getTokenFromServer(_deviceInfo.id);

    if (tokenFromDevice == "" && tokenFromServer != "") {
      _setTokenToDevice(tokenFromServer);
      tokenFromDevice = tokenFromServer;
    }
    var isTokenValid = tokenFromServer == tokenFromDevice ? true : false;
    isTokenValid =
        tokenFromServer != "" && tokenFromDevice != "" ? isTokenValid : false;
    if (!isTokenValid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AuthenticationScreen(
            deviceId: _deviceInfo.id,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReimbursementListScreen(
            token: tokenFromServer,
          ),
        ),
      );
    }
  }

  Future<String> _getTokenFromDevice() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    var token = SharedPreferenceKeys.getPrefString(sharedPreference, 'token');
    return token;
  }

  Future<void> _setTokenToDevice(String token) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    sharedPreference.setString("token", token);
  }

  Future<String> _getTokenFromServer(String deviceId) async {
    var client = http.Client();
    var urlResponse = await client.get(
        'https://cdn.smarter.com.ph:444/API/AppToken/GetTokenByDeviceId?deviceid=$deviceId');
    var json = jsonDecode(urlResponse.body);
    var token = "";
    try {
      token = json[0]['Token'];
    } catch (e) {
      token = "";
    }
    return token;
  }

  @override
  Widget build(BuildContext context) {
    _readDeviceId(context);
    return Material(
      child: Center(
        child: Text('Authenticating your device ..'),
      ),
    );
  }
}
