import 'package:flutter/material.dart';
import 'package:flutter_application_88/core/constants/app_colors.dart';
import 'package:flutter_application_88/home_screen.dart';
import 'package:flutter_application_88/viewmodels/booking_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentBookingScreen extends StatefulWidget {
  const PaymentBookingScreen({super.key});

  @override
  State<PaymentBookingScreen> createState() =>
      _PaymentBookingScreenState();
}

class _PaymentBookingScreenState
    extends State<PaymentBookingScreen> {

  final BookingViewModel bookingVM =
      BookingViewModel();

  List bookingList = [];

  bool isLoading = true;

  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {

    final prefs =
        await SharedPreferences.getInstance();

    String userId =
        prefs.getString("user_id") ?? "";

    await bookingVM.getBookings(userId);

    bookingList = bookingVM.bookingList;

    totalAmount = 0;

    for (var item in bookingList) {

      totalAmount +=
          double.tryParse(
                item["booking_price"]
                    .toString(),
              ) ??
              0;
    }
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
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
          "Payment Summary",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : bookingList.isEmpty

              ? const Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [

                      Icon(
                        Icons.receipt_long,
                        size: 80,
                        color: Colors.grey,
                      ),

                      SizedBox(height: 10),

                      Text(
                        "No bookings available",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),

                    ],
                  ),
                )

              : SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Booked Services",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        ...bookingList.map((item) {
                          return Card(
                            child: ListTile(
                              leading: const Icon(
                                Icons.book_online,
                                color: Colors.blue,
                              ),
                              title: Text(
                                item["service_name"],
                              ),
                              trailing: Text(
                                "₹${item["booking_price"]}",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }),

                        const SizedBox(height: 20),

                        Card(
                          color: Colors.green.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [

                                const Text(
                                  "Total Amount",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text(
                                  "₹${totalAmount.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 19),

                        const Center(
                          child: Text(
                            "Scan QR to Pay",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: QrImageView(
                              data:
                                  "upi://pay?pa=yashvivanza01@okaxis&pn=BookMyVendor&am=${totalAmount.toStringAsFixed(2)}&cu=INR",
                              version: QrVersions.auto,
                              size: 240,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        const Center(
                          child: Text(
                            "UPI ID: yashvivanza01@okaxis",
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Center(
                          child: Text(
                            "Scan using Google Pay, PhonePe, Paytm or BHIM",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.check_circle,
                            ),
                            label: const Text(
                              "Payment Completed",
                            ),
                  
                                onPressed: () {

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Payment Completed Successfully",
                                      ),
                                    ),
                                  );

                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    () {

                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const HomeScreen(),
                                        ),
                                        (route) => false,
                                      );

                            },
                        );

                     },
                ),
            ),

          ],
        ),
      ),
    );
  }
}