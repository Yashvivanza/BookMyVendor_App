import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_88/core/constants/app_colors.dart';
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
        "s";

    var response =
        await request.send();

    var result =
        await response.stream.bytesToString();
    
    print("RATING API RESPONSE");
    print(result);

    var data = jsonDecode(result);

    if (data["flag"] == "1") {
      ratings = data["rate_list"];
        print("TOTAL RATINGS = ${ratings.length}");

    for (var item in ratings) {
      print(item);
  }
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
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title:
            const Text("Ratings",style: TextStyle(color: Colors.white),),
        
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
                color: AppColors.card,
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Row(
                          children: [

                            const CircleAvatar(
                              child: Icon(Icons.person),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                item["rating_name"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),

                            stars(
                              item["rating_number"],
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Text(
                          item["rating_message"],
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Align(
                          alignment:
                              Alignment.centerRight,
                          child: Text(
                            item["rating_date"],
                            style: const TextStyle(
                              color: Colors.grey,
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