import 'dart:convert';
class Reimbursement {
  Reimbursement({
    this.data,
  });

  List<ReimbursementListData> data;

  factory Reimbursement.fromJson(Map<String, dynamic> json) => Reimbursement(
    data: List<ReimbursementListData>.from(json["data"].map((x) => ReimbursementListData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson()))
  };
}

class ReimbursementListData {
  ReimbursementListData({
    this.code,
    this.dateRequested,
    this.referenceNumber,
    this.amount,
    this.status,
  });

  String code;
  String dateRequested;
  String referenceNumber;
  double amount;
  String status;

  factory ReimbursementListData.fromJson(Map<String, dynamic> json) => ReimbursementListData(
    code: json["Code"],
    dateRequested: json["DateRequested"],
    referenceNumber: json["ReferenceNumber"],
    amount: json["Amount"].toDouble(),
    status: json["Status"],
  );

  Map<String, dynamic> toJson() => {
    "Code": code,
    "DateRequested": dateRequested,
    "ReferenceNumber": referenceNumber,
    "Amount": amount,
    "Status": status,
  };
}
