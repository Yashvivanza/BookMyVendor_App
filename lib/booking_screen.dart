import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class BookingScreen extends StatefulWidget {
  final String userId;
  final String serviceMasterId;
  final String serviceName;

  const BookingScreen({
    super.key,
    required this.userId,
    required this.serviceMasterId,
    required this.serviceName,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController dateController =
      TextEditingController();

  bool isLoading = false;
  String message = "";
  Color messageColor = Colors.green; 
  

  Future<void> addBooking() async {
  if (dateController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Select Booking Date"),
      ),
    );
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        'https://akashsir.in/atproject/atfinder-web/api/api-add-booking.php',
      ),
    );

    request.fields['booking_date'] =
        dateController.text.trim();

    request.fields['user_id'] =
        widget.userId;

    request.fields['service_master_id'] =
        widget.serviceMasterId;

    var response = await request.send();

    var data = jsonDecode(
      await response.stream.bytesToString(),
    );

    setState(() {
      isLoading = false;
      message = data["message"];

      if (data["flag"] == "1") {
        messageColor = Colors.green;
      } else {
        messageColor = Colors.red;
      }
    });
  } catch (e) {
    setState(() {
      isLoading = false;
      message = "Something went wrong";
      messageColor = Colors.red;
    });
  }
}

  Future<void> selectDate() async {
    DateTime? pickedDate =
        await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      dateController.text =
          "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Service"),
      ),
     
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(
                  Icons.design_services,
                  color: Colors.blue,
                ),
                title: Text(widget.serviceName),
                subtitle: Text(
                  "Service ID : ${widget.serviceMasterId}",
                ),
              ),
            ),
            
          TextField(
              controller: dateController,
              readOnly: true,
              onTap: selectDate,
              decoration: const InputDecoration(
                labelText: "Booking Date",
                border: OutlineInputBorder(),
                suffixIcon:
                    Icon(Icons.calendar_month),
              ),
            ),

            const SizedBox(height: 15),

            if (message.isNotEmpty)
              Text(
                message,
                style: TextStyle(
                  color: messageColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 15),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    isLoading ? null : addBooking,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Confirm Booking",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
