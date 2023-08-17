import 'package:flutter/material.dart';
import '../Model/Orders.dart';
import '../ViewModel/UpdateOrderViewModel.dart';
import 'package:delivery/Res/AppColors.dart';

class UpdateOrder extends StatefulWidget {
  final int orderId;

  UpdateOrder({required this.orderId});

  @override
  _UpdateOrderState createState() => _UpdateOrderState();
}

class _UpdateOrderState extends State<UpdateOrder> {
  String _pendingStatus = 'delivered'; // Default pending_status
  TextEditingController _driverMessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Order'),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${widget.orderId}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text('Driver Message:'),
            SizedBox(height: 8.0),
            TextField(
              controller: _driverMessageController,
              decoration: InputDecoration(
                hintText: 'Enter Driver Message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text('Select Pending Status:'),
            SizedBox(height: 8.0),
            DropdownButton<String>(
              value: _pendingStatus,
              onChanged: (String? newValue) {
                setState(() {
                  _pendingStatus = newValue!;
                });
              },
              items: <String>['delivered', 'reported', 'verify', 'canceled']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final String driverMessage = _driverMessageController.text;
                UpdateOrderViewModel viewModel = UpdateOrderViewModel();
                // Call the updateOrder method from the viewModel
                bool success = await viewModel.updateOrder(widget.orderId, driverMessage, _pendingStatus);
                if (success) {
                  // Show a success message or navigate back to the previous screen
                  // For simplicity, let's just show a snackbar message here.
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order updated successfully')));
                  Navigator.pop(context);
                } else {
                  // Show an error message if the update fails
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update the order')));
                }
              },
              style: ElevatedButton.styleFrom(
                primary:  vertt,
              ),
              child: Text('Update Order'),
            ),
          ],
        ),
      ),
    );
  }
}
