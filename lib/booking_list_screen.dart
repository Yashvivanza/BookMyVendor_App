import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_88/core/constants/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'app_drawer.dart';
import 'package:flutter_application_88/viewmodels/booking_view_model.dart';
class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() =>
      _BookingListScreenState();
}

class _BookingListScreenState
    extends State<BookingListScreen> {
  final BookingViewModel bookingVM =
    BookingViewModel();
  List bookingList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getBookings();
  }

  Future<void> getBookings() async {

  final prefs =
      await SharedPreferences.getInstance();

  String userId =
      prefs.getString("user_id") ?? "";

  await bookingVM.getBookings(userId);

  setState(() {

    bookingList =
        bookingVM.bookingList;

    isLoading = false;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: const Text("My Bookings",
        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      ),
      drawer: const AppDrawer(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: bookingList.length,
              itemBuilder: (context, index) {
                final item =
                    bookingList[index];

                return Card(
                  margin:
                      const EdgeInsets.only(
                    bottom: 12,
                  ),
                  elevation: 5,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                            10,
                          ),
                          child: Image.network(
                            item["service_image"],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                item["service_name"],
                                maxLines: 2,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                                style:
                                    const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 5),

                              Text(
                                "Booking Date: ${item["booking_date"]}",
                              ),

                              const SizedBox(
                                  height: 5),

                              Text(
                                "₹ ${item["booking_price"]}",
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.green,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              
                              
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}