import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_88/core/constants/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_88/viewmodels/booking_view_model.dart';


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
  final BookingViewModel bookingVM =
    BookingViewModel();
  bool isLoading = false;
  String message = "";
  Color messageColor = Colors.green; 
  

  Future<void> addBooking() async {

      if (dateController.text.isEmpty) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content:
                Text("Select Booking Date"),
          ),
        );

        return;
      }

      setState(() {
        isLoading = true;
      });

      var data =
          await bookingVM.addBooking(
        bookingDate:
            dateController.text.trim(),
        userId:
            widget.userId,
        serviceMasterId:
            widget.serviceMasterId,
      );

      setState(() {
        isLoading = false;

        message =
            data["message"];

        messageColor =
            data["flag"] == "1"
                ? Colors.green
                : Colors.red;
      });
    }
  Future<void> selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text =
            "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text("Book Service",style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,)),
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
            const SizedBox(height: 25),
          TextField(
              controller: dateController,
              readOnly: true,
              onTap: selectDate,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                labelText: "Booking Date",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                border: OutlineInputBorder(),
                suffixIcon: Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                ),
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
