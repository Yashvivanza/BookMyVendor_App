import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'splash_screen.dart';
import 'viewmodels/home_view_model.dart';
import 'viewmodels/service_view_model.dart';
import 'viewmodels/category_view_model.dart';
import 'viewmodels/booking_view_model.dart';
import 'viewmodels/favourite_view_model.dart';
import 'viewmodels/rating_view_model.dart';
import 'viewmodels/profile_view_model.dart';
import 'viewmodels/search_view_model.dart';
import 'viewmodels/auth_view_model.dart';
import 'viewmodels/change_password_view_model.dart';
import 'viewmodels/splash_view_model.dart';
import "viewmodels/chatbot_view_model.dart";
import 'package:flutter_application_88/viewmodels/contact_vendor_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(const BookMyVendorApp());
}

class BookMyVendorApp extends StatelessWidget {
  const BookMyVendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => HomeViewModel(),
        ),

        ChangeNotifierProvider(
          create: (_) => ServiceViewModel(),
        ),

        ChangeNotifierProvider(
          create: (_) => CategoryViewModel(),
        ),

        ChangeNotifierProvider(
          create: (_) => BookingViewModel(),
        ),

        ChangeNotifierProvider(
          create: (_) => FavouriteViewModel(),
        ),

        ChangeNotifierProvider(
          create: (_) => RatingViewModel(),
        ),

        ChangeNotifierProvider(
          create: (_) => ProfileViewModel(),
        ),

        ChangeNotifierProvider(
          create: (_) => SearchViewModel(),
        ),

        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),

        ChangeNotifierProvider(
          create: (_) => ChangePasswordViewModel(),
        ),

        ChangeNotifierProvider(
          create: (_) => SplashViewModel(),
        ),

        ChangeNotifierProvider(
          create: (_) => ChatBotViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ContactVendorViewModel(),
        ),
      ],
    
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BookMyVendor App',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}