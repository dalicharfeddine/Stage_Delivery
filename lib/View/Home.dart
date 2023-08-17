import 'package:flutter/material.dart';
import 'package:delivery/Res/AppColors.dart';
import 'package:delivery/ViewModel/OrderViewModel.dart';
import 'package:delivery/ViewModel/CalLogViewModel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Model/Orders.dart';
import 'UpdateOrder.dart'; // Import the UpdateOrder screen

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TimeOfDay? selectedTime;
  List<Order> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  void _fetchOrders() async {
    List<Order> orders = await OrdersViewModel().fetchOrders();
    setState(() {
      _filteredOrders = orders;
    });
  }

  void _filterOrders(String searchQuery) {
    List<Order> filteredList = _filteredOrders.where((order) {
      return (order.id.toString().contains(searchQuery.toLowerCase())) ||
          (order.receiverAddress?.toLowerCase()?.contains(searchQuery.toLowerCase()) ?? false) ||
          (order.sphone?.toLowerCase()?.contains(searchQuery.toLowerCase()) ?? false);
    }).toList();

    setState(() {
      _filteredOrders = filteredList;
    });
  }


  void _showAddDurationDialog(BuildContext context, int orderId) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Duration and Time'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    selectedTime = picked;
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: TextEditingController(text: selectedTime?.format(context) ?? ''),
                  decoration: InputDecoration(labelText: 'Time'),
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              child: TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Duration (in hours)'),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (selectedTime != null) {
                DateTime now = DateTime.now();
                DateTime selectedDateTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  selectedTime!.hour,
                  selectedTime!.minute,
                );

                String duration = _durationController.text;
                bool success = await CalLogViewModel().updateOrder(orderId, duration, selectedDateTime.toString());

                if (success) {
                  Navigator.pop(context);
                  _fetchOrders(); // Refresh the orders list after updating
                } else {
                  // Handle failure scenario
                }
              }
            },
            child: Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _launchPhoneCall(String? phoneNumber) {
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      launch('tel:$phoneNumber');
    } else {
      // Handle the case when the phone number is not available or empty
      // For example, display a message to the user.
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/hh.png",
              width: 200,
              height: 200,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterOrders,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = _filteredOrders[index];
                    return GestureDetector(
                      onTap: () {
                        _showAddDurationDialog(context, order.id);
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ' ${order.orderDate.toLocal()}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/pack.png',
                                    height: 24.0,
                                    width: 24.0,
                                  ),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      'Order : ${order.id}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => UpdateOrder(orderId: order.id)),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: vertt,
                                    ),
                                    child: Text('Update'),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('Payment : ', style: TextStyle(color: Colors.grey)),
                                  Text('\$${order.paymentAmount}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/endroit.png',
                                    height: 24.0,
                                    width: 24.0,
                                  ),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      ' ${order.receiverAddress}',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/telephone.png',
                                    height: 24.0,
                                    width: 24.0,
                                  ),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        _launchPhoneCall(order.sphone);
                                      },
                                      child: Text(
                                        ' ${order.sphone}',
                                        style: TextStyle(fontSize: 16.0, decoration: TextDecoration.underline, color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.0),
                              SizedBox(height: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(height: 8.0),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
