import 'package:flutter/material.dart';
import 'package:flutter_application_88/core/constants/app_colors.dart';
import 'package:flutter_application_88/viewmodels/booking_view_model.dart';
import '../services/notification_service.dart';
import 'booking_success_screen.dart';

class PaymentBookingScreen extends StatefulWidget {
  final String userId;
  final String serviceMasterId;
  final String serviceName;
  final String bookingDate;
  final String requirements;
  final String price;

  const PaymentBookingScreen({
    super.key,
    required this.userId,
    required this.serviceMasterId,
    required this.serviceName,
    required this.bookingDate,
    required this.requirements,
    required this.price,
  });

  @override
  State<PaymentBookingScreen> createState() =>
      _PaymentBookingScreenState();
}

class _PaymentBookingScreenState
    extends State<PaymentBookingScreen> {

  final BookingViewModel bookingVM =
      BookingViewModel();

  bool isLoading = false;

  Future<void> completePayment() async {

    setState(() {
      isLoading = true;
    });

    var data =
        await bookingVM.addBooking(
      bookingDate: widget.bookingDate,
      userId: widget.userId,
      serviceMasterId:
          widget.serviceMasterId,
      requirements:
          widget.requirements,
    );

    if (data["flag"] == "1") {

      await NotificationService.addNotification(
        title: "🎉 Booking Confirmed",
        message:
            "${widget.serviceName} booked for ${widget.bookingDate}",
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              BookingSuccessScreen(
            serviceName:
                widget.serviceName,
            bookingDate:
                widget.bookingDate,
            requirements:
                widget.requirements,
            price: 
                widget.price,
          ),
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          data["message"] ??
              "Something went wrong",
        ),
      ),
    );
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
        title: const Text(
          "Payment",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(15),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      "Service : ${widget.serviceName}",
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Booking Date : ${widget.bookingDate}",
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Requirements : ${widget.requirements}",
                    ),
                    const SizedBox(height: 10),

                  Text(
                    "Price : ₹${widget.price}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Center(
              child: Text(
                "Scan QR & Complete Payment",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Container(
                height: 250,
                width: 250,
                color: Colors.white,

                child: Image.asset(
                  "assets/images/payment_qr.jpeg",
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.check_circle,
                ),

                label: isLoading
                    ? const Text(
                        "Processing...",
                      )
                    : const Text(
                        "Payment Completed",
                      ),

                onPressed: isLoading
                    ? null
                    : completePayment,
              ),
            ),
          ],
        ),
      ),
    );
  }
}