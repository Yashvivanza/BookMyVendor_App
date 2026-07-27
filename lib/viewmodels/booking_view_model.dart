import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BookingViewModel extends ChangeNotifier {

  bool isLoading = false;

  List bookingList = [];

  Future<void> getBookings(String userId) async {

    try {

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

        bookingList = data["booking_list"];
      }

    } catch (e) {
      print(e);
    }
  }
  Future<Map<String, dynamic>> addBooking({
    required String bookingDate,
    required String userId,
    required String serviceMasterId,
    required String requirements,
  }) async {

    isLoading = true;
    notifyListeners();

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://akashsir.in/atproject/atfinder-web/api/api-add-booking.php',
        ),
      );

      request.fields["booking_date"] = bookingDate;
      request.fields["user_id"] = userId;
      request.fields["service_master_id"] = serviceMasterId;
      request.fields["requirements"] = requirements;
      print("Requirements = $requirements");
      var response = await request.send();

      var responseData =
          await response.stream.bytesToString();

      var data = jsonDecode(responseData);

      isLoading = false;
      notifyListeners();

      return data;
    } catch (e) {

      isLoading = false;
      notifyListeners();

      return {
        "flag": "0",
        "message": e.toString(),
      };
    }
  }
  Future<Map<String, dynamic>> deleteBooking({
    required String bookingId,
  }) async {

    try {

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://akashsir.in/atproject/atfinder-web/api/api-delete-booking.php',
        ),
      );


      request.fields["booking_id"] = bookingId;


      var response = await request.send();


      var responseData =
          await response.stream.bytesToString();


      var data = jsonDecode(responseData);


      return data;


    } catch (e) {

      return {
        "flag": "0",
        "message": e.toString(),
      };

    }
  }
  Map? getLatestBooking() {

  if (bookingList.isEmpty) {
    return null;
  }

  return bookingList.first;
}
  }