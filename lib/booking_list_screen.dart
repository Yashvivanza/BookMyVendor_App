  import 'package:flutter/material.dart';
  import 'package:flutter_application_88/core/constants/app_colors.dart';
import 'package:flutter_application_88/views/feedback_screen.dart';
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
       WidgetsBinding.instance.addPostFrameCallback((_) {
      getBookings();
  });
    }
Future<void> getBookings() async {

  final prefs =
      await SharedPreferences.getInstance();

  String userId =
      prefs.getString("user_id") ?? "";

  await bookingVM.getBookings(userId);


  if (!mounted) return;


  setState(() {

    bookingList =
        bookingVM.bookingList;

    isLoading = false;

  });
}
    void showDeleteDialog(
    BuildContext parentContext,
    String bookingId,
  ) {

    showDialog(
      context: parentContext,
      builder: (dialogContext) {

        return AlertDialog(
          title: const Text(
            "Delete Booking",
          ),

          content: const Text(
            "Are you sure you want to delete this booking?",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text("Cancel"),
            ),


            TextButton(
              onPressed: () async {
                var result = await bookingVM.deleteBooking(
                  bookingId: bookingId,
                );

                if (!mounted) return;


                // close dialog first
                if (Navigator.canPop(dialogContext)) {
                  Navigator.pop(dialogContext);
                }


                if (result["flag"] == 1 ||
                    result["flag"] == "1") {


                  ScaffoldMessenger.of(parentContext)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Booking deleted successfully",
                      ),
                    ),
                  );
                  getBookings();
                } else {


                  ScaffoldMessenger.of(parentContext)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        result["message"] ??
                            "Delete failed",
                      ),
                    ),
                  );

                }

              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),

          ],
        );
      },
    );
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
      : bookingList.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [

                  Icon(
                    Icons.book_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 10),

                  Text(
                    "No bookings found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: bookingList.length,
              itemBuilder: (context, index) {
                final item = bookingList[index];
                print(item);
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

                              Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      const Icon(
                                        Icons.notes,
                                        size: 18,
                                        color: Colors.blue,
                                      ),

                                      const SizedBox(width: 5),

                                      Expanded(
                                        child: Text(
                                          item["requirements"] ?? "No requirements",
                                          style: const TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),

                                const SizedBox(
                                    height: 5),

                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,

                                    children: [

                                      Text(
                                        "₹ ${item["booking_price"]}",
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                  Row(
                                    children: [

                                      IconButton(
                                        icon: const Icon(
                                          Icons.feedback_outlined,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  FeedbackScreen(
                                                bookingId:
                                                    item["booking_id"]
                                                        .toString(),
                                                serviceName:
                                                    item["service_name"]
                                                        .toString(),
                                              ),
                                            ),
                                          );

                                        },
                                      ),

                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {

                                      showDeleteDialog(
                                        context,
                                        item["booking_id"]
                                            .toString(),
                                      );

                                    },
                                  ),

                                ],
                              ),

                              ],
                            )                      
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