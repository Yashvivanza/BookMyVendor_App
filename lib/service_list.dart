import 'package:flutter/material.dart';
import 'package:flutter_application_88/core/constants/app_colors.dart';
import 'package:flutter_application_88/service_details_screen.dart';
import 'package:flutter_application_88/models/service_model.dart';
import 'package:flutter_application_88/viewmodels/service_view_model.dart';
import 'app_drawer.dart';

class ServiceListScreen extends StatefulWidget {
  final String? subCategoryId;

  const ServiceListScreen({
    super.key,
    this.subCategoryId,
  });

  @override
  State<ServiceListScreen> createState() =>
      _ServiceListScreenState();
}

class _ServiceListScreenState
    extends State<ServiceListScreen> {
      final ServiceViewModel serviceVM =
    ServiceViewModel();

 @override
  void initState() {
    super.initState();

    serviceVM.loadServices().then((_) {

      if (widget.subCategoryId != null &&
          widget.subCategoryId!.isNotEmpty) {

        serviceVM.filteredList = serviceVM.filteredList
            .where(
              (service) =>
                  service.subCategoryId ==
                  widget.subCategoryId,
            )
            .toList();
      }

      setState(() {});
    });
  }
  void searchService(String value) {
  setState(() {
    serviceVM.search(value);
  });
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
        title: const Text("Services", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,)),
      leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: const AppDrawer(),
     body: serviceVM.isLoading
    ? const Center(
        child: CircularProgressIndicator(),
      )
    : Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: searchService,
              decoration: InputDecoration(
                hintText: "Search Services...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: serviceVM.filteredList.length,
              itemBuilder: (context, index) {
               final item = serviceVM.filteredList[index];

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
                                  fontWeight:
                                      FontWeight.bold,
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
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(238, 13, 27, 61),
                                    foregroundColor:
                                        Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ServiceDetailsScreen(
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
          ),
        ],
      ),
    );
  }
}