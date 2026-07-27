import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_88/core/constants/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackScreen extends StatefulWidget {
  final String bookingId;
  final String serviceName;

  const FeedbackScreen({
    super.key,
    required this.bookingId,
    required this.serviceName,
  });

  @override
  State<FeedbackScreen> createState() =>
      _FeedbackScreenState();
}

class _FeedbackScreenState
    extends State<FeedbackScreen> {

  final TextEditingController
      feedbackController =
          TextEditingController();

  double rating = 0;

  bool isLoading = false;

  String getRatingText() {
    switch (rating.toInt()) {
      case 1:
        return "Poor";
      case 2:
        return "Fair";
      case 3:
        return "Good";
      case 4:
        return "Very Good";
      case 5:
        return "Excellent";
      default:
        return "Select Rating";
    }
  }

  Future<void> submitFeedback() async {

    if (rating == 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please select rating",
          ),
        ),
      );
      return;
    }

    if (feedbackController.text
        .trim()
        .isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please write feedback",
          ),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      SharedPreferences prefs =
          await SharedPreferences.getInstance();

      String userId =
          prefs.getString("user_id") ?? "";

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "https://akashsir.in/atproject/atfinder-web/api/api-add-feedback.php",
        ),
      );

      request.fields["user_id"] =
          userId;

      request.fields["feedback_rate"] =
          rating.toInt().toString();

      request.fields["feedback_details"] =
          feedbackController.text.trim();

      var response =
          await request.send();

      var result =
          await response.stream.bytesToString();

      print("FEEDBACK RESPONSE");
      print(result);

      var data =
          jsonDecode(result);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            data["message"] ??
                "Feedback Submitted",
          ),
        ),
      );

      if (data["flag"] == "1") {

        Navigator.pop(context);

      }

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );

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
        iconTheme:
            const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Feedback",
          style: TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(
              widget.serviceName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < rating.toInt()
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.amber,
                  size: 32,
                ),
              ),
            ),

            const SizedBox(height: 5),

            Text(
              getRatingText(),
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            Slider(
              value: rating,
              min: 0,
              max: 5,
              divisions: 5,
              label:
                  rating.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  feedbackController,
              maxLines: 5,
              style:
                  const TextStyle(
                color: Colors.white,
              ),
              decoration:
                  const InputDecoration(
                labelText:
                    "Write Feedback",
                hintText:
                    "Share your experience...",
                labelStyle:
                    TextStyle(
                  color:
                      Colors.white,
                ),
                hintStyle:
                    TextStyle(
                  color:
                      Colors.grey,
                ),
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width:
                  double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.send,
                      ),
                label: Text(
                  isLoading
                      ? "Submitting..."
                      : "Submit Feedback",
                ),
                onPressed:
                    isLoading
                        ? null
                        : submitFeedback,
              ),
            ),
          ],
        ),
      ),
    );
  }
}