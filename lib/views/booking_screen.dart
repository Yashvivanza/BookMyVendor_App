import 'package:flutter/material.dart';
import 'package:flutter_application_88/core/constants/app_colors.dart';
import 'payment_booking_screen.dart';

class BookingScreen extends StatefulWidget {
  final String userId;
  final String serviceMasterId;
  final String serviceName;
  final String servicePrice;

  const BookingScreen({
    super.key,
    required this.userId,
    required this.serviceMasterId,
    required this.serviceName,
    required this.servicePrice,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController requirementController = TextEditingController();
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

  if (requirementController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter your requirements"),
      ),
    );
    return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => PaymentBookingScreen(
        userId: widget.userId,
        serviceMasterId: widget.serviceMasterId,
        serviceName: widget.serviceName,
        bookingDate: dateController.text.trim(),
        requirements: requirementController.text.trim(),
        price: widget.servicePrice,
      ),
    ),
  );
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
            const SizedBox(height: 20),
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

              TextField(
                controller: requirementController,
                maxLines: 2,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  labelText: "Special Requirements",
                  hintText:
                      "Example: 200 guests, bridal mehendi, red theme decoration...",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),  
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(),
                ),
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
                        "Continue to Payment",
                      ),
              ),
            ),

            const SizedBox(height: 20),
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

           ],
        ),
      ),
    );
  }
}
