import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_88/service_details_screen.dart';
import 'package:http/http.dart' as http;
import 'service_model.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key});

  @override
  State<ServiceListScreen> createState() =>
      _ServiceListScreenState();
}

class _ServiceListScreenState
    extends State<ServiceListScreen> {
  List<ServiceModel> serviceList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getServices();
  }

  Future<void> getServices() async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://akashsir.in/atproject/atfinder-web/api/api-list-service.php',
        ),
      );

      final data = jsonDecode(response.body);

      if (data["flag"] == "1") {
        List list = data["service_list"];

        setState(() {
          serviceList = list
              .map((e) => ServiceModel.fromJson(e))
              .toList();

          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Services"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: serviceList.length,
              itemBuilder: (context, index) {
                final item = serviceList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [

                        Image.network(
                          item.serviceImage,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Text(
                                item.serviceName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                item.subCategoryName,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                "₹ ${item.servicePrice}",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ServiceDetailsScreen(
                                          service: item,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "View Details",
                                  ),
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