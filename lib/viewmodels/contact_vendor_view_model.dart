import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactVendorViewModel extends ChangeNotifier {

  Future<void> contactVendor({
    required Map booking,
  }) async {
   
    final prefs =
        await SharedPreferences.getInstance();
    await prefs.reload();
   String name =
    prefs.getString("user_name") ?? "";

  String email =
    prefs.getString("user_email") ?? "";


   print("===== ALL SAVED DATA =====");

for (String key in prefs.getKeys()) {
  print("$key : ${prefs.get(key)}");
}

print("==========================");

    final String subject =
        'Booking Inquiry - ${booking["service_name"]} - Booking #${booking["booking_id"]}';

    final String body = '''
Hello Vendor,

I have booked your service through the Book My Vendor app.

Customer Details:

Name: $name
Email: $email


Booking Details:

Booking ID: ${booking["booking_id"]}
Service Name: ${booking["service_name"]}
Booking Date: ${booking["booking_date"]}
Requirements: ${booking["requirements"]}
Price: ₹${booking["booking_price"]}

Please contact me regarding this booking.

Thank you.
''';

    final Uri emailUri = Uri.parse(
      'mailto:yashvivanza01@gmail.com'
      '?subject=${Uri.encodeComponent(subject)}'
      '&body=${Uri.encodeComponent(body)}',
    );

    await launchUrl(
  emailUri,
  mode: LaunchMode.externalApplication,
    );
  }
  
}