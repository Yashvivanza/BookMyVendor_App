import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingViewModel {

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

  Future<Map<String,dynamic>> addBooking({
    required String bookingDate,
    required String userId,
    required String serviceMasterId,
  }) async {

    try {

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://akashsir.in/atproject/atfinder-web/api/api-add-booking.php',
        ),
      );

      request.fields["booking_date"] =
          bookingDate;

      request.fields["user_id"] =
          userId;

      request.fields["service_master_id"] =
          serviceMasterId;

      var response = await request.send();

      return jsonDecode(
        await response.stream.bytesToString(),
      );

    } catch (e) {

      return {
        "flag":"0",
        "message":"Something went wrong"
      };
    }
  }
}