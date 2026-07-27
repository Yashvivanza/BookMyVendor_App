import 'package:flutter/material.dart';
import 'package:flutter_application_88/booking_list_screen.dart';
import 'package:flutter_application_88/home_screen.dart';
import '../core/constants/app_colors.dart';

class BookingSuccessScreen extends StatelessWidget {
  final String serviceName;
  final String bookingDate;
  final String requirements;
  final String price;

  const BookingSuccessScreen({
    super.key,
    required this.serviceName,
    required this.bookingDate,
    required this.requirements,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,

      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Booking Confirmation",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            /// SUCCESS ICON
            Container(
              height: 60,
              width: 60,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.withValues(alpha: 0.15),
              ),

              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Booking Confirmed!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Thank you for choosing Book My Vendor",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            /// BOOKING DETAILS CARD
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white10,
                ),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Row(
                    children: [

                      Icon(
                        Icons.receipt_long,
                        color: Colors.white,
                      ),

                      SizedBox(width: 10),

                      Text(
                        "Booking Details",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const Divider(
                    color: Colors.white24,
                    height: 30,
                  ),

                  detailTile(
                    Icons.store,
                    "Service",
                    serviceName,
                  ),

                  const SizedBox(height: 15),

                  detailTile(
                    Icons.calendar_month,
                    "Booking Date",
                    bookingDate,
                  ),

                  const SizedBox(height: 15),

                  detailTile(
                    Icons.description,
                    "Requirements",
                    requirements,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            /// AMOUNT PAID CARD
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff0f9d58),
                    Color(0xff34a853),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: Row(
                children: [

                  Container(
                    height: 30,
                    width: 30,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),
                    ),

                    child: const Icon(
                      Icons.currency_rupee,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        const Text(
                          "Amount Paid",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "₹$price",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.verified,
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// MY BOOKINGS BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                  ),
                ),

                icon: const Icon(
                  Icons.list_alt,
                  color: Colors.white,
                ),

                label: const Text(
                  "Go To My Bookings",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),

                onPressed: () {

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const BookingListScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// HOME BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,

              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.blue,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                  ),
                ),

                icon: const Icon(
                  Icons.home,
                  color: Colors.white,
                ),

                label: const Text(
                  "Back To Home",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),

                onPressed: () {

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const HomeScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget detailTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Icon(
          icon,
          color: Colors.blue,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}