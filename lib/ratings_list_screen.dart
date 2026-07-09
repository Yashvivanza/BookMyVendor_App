import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RatingsListScreen
    extends StatefulWidget {
  const RatingsListScreen({
    super.key,
  });

  @override
  State<RatingsListScreen> createState() =>
      _RatingsListScreenState();
}

class _RatingsListScreenState
    extends State<RatingsListScreen> {
  List ratings = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRatings();
  }

  Future<void> loadRatings() async {
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
        "";

    var response =
        await request.send();

    var result =
        await response.stream.bytesToString();

    var data = jsonDecode(result);

    if (data["flag"] == "1") {
      ratings = data["rate_list"];
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget stars(String rating) {
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Ratings"),
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount:
                  ratings.length,
              itemBuilder:
                  (context, index) {
                var item =
                    ratings[index];

                return Card(
                  margin:
                      const EdgeInsets.all(
                          10),
                  child: ListTile(
                    title: Text(
                      item[
                          "rating_name"],
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        stars(item[
                            "rating_number"]),
                        const SizedBox(
                            height: 5),
                        Text(item[
                            "rating_message"]),
                        Text(
                          item[
                              "rating_date"],
                          style:
                              const TextStyle(
                            color:
                                Colors.grey,
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