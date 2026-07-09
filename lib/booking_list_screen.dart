import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'app_drawer.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() =>
      _BookingListScreenState();
}

class _BookingListScreenState
    extends State<BookingListScreen> {
  List bookingList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getBookings();
  }

  Future<void> getBookings() async {
    try {
      final prefs =
          await SharedPreferences.getInstance();

      String userId =
          prefs.getString("user_id") ?? "";

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://akashsir.in/atproject/atfinder-web/api/api-list-booking.php',
        ),
      );

      request.fields["user_id"] = userId;

      var response = await request.send();

      var data = jsonDecode(
        await response.stream.bytesToString(),
      );

      if (data["flag"] == "1") {
        setState(() {
          bookingList = data["booking_list"];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookings"),
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

                              const SizedBox(
                                  height: 5),

                              
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