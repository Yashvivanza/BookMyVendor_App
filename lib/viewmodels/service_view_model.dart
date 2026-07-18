import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_88/models/service_model.dart';

class ServiceViewModel {

  List<ServiceModel> serviceList = [];
  List<ServiceModel> filteredList = [];

  bool isLoading = true;

  Future<void> loadServices() async {

    try {

      final response = await http.post(
        Uri.parse(
          'https://akashsir.in/atproject/atfinder-web/api/api-list-service.php',
        ),
      );

      final data = jsonDecode(response.body);

      if (data["flag"] == "1") {

        List list = data["service_list"];

        serviceList =
            list.map((e) => ServiceModel.fromJson(e)).toList();

        filteredList = List.from(serviceList);
      }

    } catch (e) {
      print(e);
    }

    isLoading = false;
  }

  void search(String value) {

    filteredList = serviceList.where((service) {

      return service.serviceName
          .toLowerCase()
          .contains(value.toLowerCase());

    }).toList();
  }

  Future<Object?> getServices() async {}
}