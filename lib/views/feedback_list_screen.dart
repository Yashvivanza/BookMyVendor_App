import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_88/core/constants/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackListScreen extends StatefulWidget {
  const FeedbackListScreen({super.key});

  @override
  State<FeedbackListScreen> createState() =>
      _FeedbackListScreenState();
}

class _FeedbackListScreenState
    extends State<FeedbackListScreen> {
  List feedbackList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFeedbacks();
  }

  Future<void> loadFeedbacks() async {
    try {
      SharedPreferences prefs =
          await SharedPreferences.getInstance();

      String userId =
          prefs.getString("user_id") ?? "";

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "https://akashsir.in/atproject/atfinder-web/api/api-list-feedback.php",
        ),
      );

      request.fields["user_id"] = userId;

      var response = await request.send();

      var result =
          await response.stream.bytesToString();

      print(result);

      var data = jsonDecode(result);

      if (data["flag"] == 1 ||
          data["flag"] == "1") {
        feedbackList =
            data["feedback_list"] ?? [];
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildStars(String rating) {
    int total =
        int.tryParse(rating) ?? 0;

    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < total
              ? Icons.star
              : Icons.star_border,
          color: Colors.amber,
          size: 20,
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
          "My Feedbacks",
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
          : feedbackList.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.feedback_outlined,
                        size: 80,
                        color: Colors.white54,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "No Feedback Found",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(10),
                  itemCount:
                      feedbackList.length,
                  itemBuilder:
                      (context, index) {
                    var item =
                        feedbackList[index];

                    return Card(
                      color: AppColors.card,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                15),
                      ),
                      margin:
                          const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(
                                15),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [

                            Row(
                              children: [

                                const CircleAvatar(
                                  child: Icon(
                                    Icons.person,
                                  ),
                                ),

                                const SizedBox(
                                  width: 10,
                                ),

                                Expanded(
                                  child: Text(
                                    item["user_name"] ??
                                        "",
                                    style:
                                        const TextStyle(
                                      color: Colors
                                          .white,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                                height: 12),

                            buildStars(
                              item["feedback_rate"]
                                  .toString(),
                            ),

                            const SizedBox(
                                height: 12),

                            Text(
                              item["feedback_details"] ??
                                  "",
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white70,
                                fontSize: 15,
                              ),
                            ),

                            const SizedBox(
                                height: 10),

                            Align(
                              alignment:
                                  Alignment
                                      .centerRight,
                              child: Text(
                                "${item["feedback_date"]}\n${item["feedback_date_time"]}",
                                textAlign:
                                    TextAlign.right,
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.grey,
                                  fontSize: 12,
                                ),
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