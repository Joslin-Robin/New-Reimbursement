import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class Details extends StatefulWidget {
  final int id;
  Details(this.id);
  @override
  _DetailsPageState createState() => _DetailsPageState(id);
}

class _DetailsPageState extends State<Details> {
  int id;
  _DetailsPageState(this.id);
  @override
  Widget build(BuildContext context) {
    final String url ="https://cdn.smarter.com.ph:444/API/Reimbursement/Get?id=$id";
    var formatCurrency = new NumberFormat.currency(locale: "en_US",
        symbol: "");

    return Scaffold(
      appBar: AppBar(title: Text("Reimbursement"),backgroundColor: Color(0xFF135587)),
      body: FutureBuilder(
        future: http.get(url),
        builder: (_, snap){
          if(snap.connectionState == ConnectionState.done){
            var data = snap.data;
            http.Response res = data;
            var resultJson = json.decode(res.body);
            print(res.body);

            return ListView.builder(

              itemBuilder: (_, index) => new Container(

                child: InkWell(

                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 8.0, bottom: 4.0),
                            child: Row(children: <Widget>[
                              Text('Reimbursement id: '+'#'+'${resultJson[index]['ReimbursementId']}',
                                style: new TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                              Spacer(),
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 60.0),
                            child: Row(children: <Widget>[
                              Icon(
                                Icons.date_range_sharp,

                                size: 20.0,

                              ),
                              Text(' Applied Date & Time: '+
                                  DateFormat("dd-MMM-yyyy hh:mm")
                                      .format(DateTime.parse(
                                      resultJson[index]['DateApplied']))
                                      .toString(),
                                style: new TextStyle(fontSize: 16.0),
                              ),
                              Spacer(),
                            ]),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Total Amount ' ,
                                  style: new TextStyle(fontSize: 18.0),
                                ),
                                Spacer(),

                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0, bottom: 8.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '₱ ' +
                                      '${formatCurrency.format(resultJson[index]['Total'] ?? " ")}',
                                  style: new TextStyle(fontSize: 35.0),
                                ),
                                Spacer(),

                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Type' ,
                                  style: new TextStyle(fontSize: 18.0),
                                ),
                                Spacer(),

                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0, bottom: 8.0),
                            child: Row(
                              children: <Widget>[
                                Text(

                                  '${resultJson[index]['Type'] ?? " "}',
                                  style: new TextStyle(fontSize: 18.0, color: Colors.orange),
                                ),
                                Spacer(),

                              ],

                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Status' ,
                                  style: new TextStyle(fontSize: 18.0),
                                ),
                                Spacer(),

                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0, bottom: 8.0),

                            child: Row(
                              children: <Widget>[
                                if ('${resultJson[index]['Status'] ?? " "}' == '2') Text('Paid', style: new TextStyle(fontSize: 18.0, color: Colors.green),),
                                if ('${resultJson[index]['Status'] ?? " "}' == '1') Text('Pending', style: new TextStyle(fontSize: 18.0, color: Colors.deepOrange),),

                                Text(

                                  ' ',
                                  style: new TextStyle(fontSize: 18.0, color: Colors.grey),
                                ),
                                Spacer(),

                              ],

                            ),

                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
                              child: const MySeparator(color: Colors.grey)

                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Description' ,
                                  style: new TextStyle(fontSize: 20.0),
                                ),
                                Spacer(),

                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0, bottom: 8.0),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: Text(

                                    '${resultJson[index]['Description'] ?? " "}',
                                    style: new TextStyle(fontSize: 18.0, color: Colors.grey),
                                  ),
                                ),


                              ],

                            ),

                          ),



                        ],
                      ),
                    ),
                  ),
                ),
              ),
              itemCount: resultJson.length,
            );
          }
          else{
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

}
class MySeparator extends StatelessWidget {
  final double height;
  final Color color;
  const MySeparator({this.height = 0.75, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 3.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
