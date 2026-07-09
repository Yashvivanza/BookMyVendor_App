import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RatingScreen extends StatefulWidget {
  final String productId;

  const RatingScreen({
    super.key,
    required this.productId,
  });

  @override
  State<RatingScreen> createState() =>
      _RatingScreenState();
}

class _RatingScreenState
    extends State<RatingScreen> {
  int selectedRating = 5;

  bool isLoading = false;

  List ratings = [];

  final TextEditingController
      nameController =
          TextEditingController();

  final TextEditingController
      reviewController =
          TextEditingController();

  @override
  void initState() {
    super.initState();
    loadRatings();
  }

  Future<void> submitRating() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    String userId =
        prefs.getString("user_id") ?? "";

    if (userId.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please login first",
          ),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
        "https://akashsir.in/atproject/atfinder-web/api/api-add-rating.php",
      ),
    );

    request.fields["user_id"] =
        userId;

    request.fields["product_id"] =
        widget.productId;

    request.fields["rating_number"] =
        selectedRating.toString();

    request.fields["rating_name"] =
        nameController.text;

    request.fields["rating_message"] =
        reviewController.text;

    var response =
        await request.send();

    var result =
        await response.stream.bytesToString();

    var data = jsonDecode(result);

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content:
            Text(data["message"]),
      ),
    );

    if (data["flag"] == "1") {
      nameController.clear();
      reviewController.clear();

      loadRatings();
    }
  }

  Future<void> loadRatings() async {
    try {
      SharedPreferences prefs =
          await SharedPreferences.getInstance();

      String userId =
          prefs.getString("user_id") ?? "";

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "https://akashsir.in/atproject/atfinder-web/api/api-list-rating.php",
        ),
      );

      request.fields["user_id"] =
          userId;

      request.fields["product_id"] =
          widget.productId;

      var response =
          await request.send();

      var result =
          await response.stream.bytesToString();

      var data = jsonDecode(result);

      if (data["flag"] == "1") {
        setState(() {
          ratings =
              data["rate_list"] ?? [];
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget buildStars(int rating) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < rating
              ? Icons.star
              : Icons.star_border,
          color: Colors.amber,
          size: 22,
        ),
      ),
    );
  }

  Widget selectStars() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => IconButton(
          onPressed: () {
            setState(() {
              selectedRating =
                  index + 1;
            });
          },
          icon: Icon(
            index < selectedRating
                ? Icons.star
                : Icons.star_border,
            color: Colors.amber,
            size: 35,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rate Service",
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            const Text(
              "Rate This Service",
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            selectStars(),

            const SizedBox(height: 20),

            TextField(
              controller:
                  nameController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Your Name",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller:
                  reviewController,
              maxLines: 4,
              decoration:
                  const InputDecoration(
                labelText: "Review",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : submitRating,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Submit Rating",
                      ),
              ),
            ),

            const SizedBox(height: 30),

            const Divider(),

            const Text(
              "Customer Reviews",
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ratings.isEmpty
                ? const Center(
                    child: Padding(
                      padding:
                          EdgeInsets.all(
                              20),
                      child: Text(
                        "No Ratings Found",
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount:
                        ratings.length,
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemBuilder:
                        (context, index) {
                      final item =
                          ratings[index];

                      int star =
                          int.tryParse(
                                item[
                                    "rating_number"]
                                    .toString(),
                              ) ??
                              0;

                      return Card(
                        margin:
                            const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(
                                  12),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [

                              Text(
                                item[
                                    "rating_name"],
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(
                                  height: 5),

                              buildStars(star),

                              const SizedBox(
                                  height: 8),

                              Text(
                                item[
                                    "rating_message"],
                              ),

                              const SizedBox(
                                  height: 5),

                              Text(
                                item[
                                    "rating_date"],
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}