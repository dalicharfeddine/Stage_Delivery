class Order {
  int id;
  DateTime orderDate;
  String? sname;
  String? receiverAddress;
  String? sphone;
  String? paymentAmount;
String? driver_message ;
String? pending_status ;
String? duration;
String? time;
  Order({
    required this.id,
    required this.orderDate,
    this.sname,
    this.receiverAddress,
    this.sphone,
    this.paymentAmount,
    this.driver_message,
    this.pending_status ,
    this.duration ,
    this.time ,

  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderDate: DateTime.parse(json['order_date']),
      sname: json['sname'],
      duration: json['duration'],
      time: json['time'],
      receiverAddress: json['receiver_address'],
      sphone: json['sphone'].toString(),
      paymentAmount: json['payment_amount'],
      driver_message: json['driver_message'],
      pending_status: json['pending_status'],

    );
  }

}
