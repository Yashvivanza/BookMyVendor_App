import 'package:flutter/material.dart';
import 'package:flutter_application_88/notification_screen.dart';
import 'package:flutter_application_88/allpayment_booking_screen.dart';
import 'package:flutter_application_88/quick_booking_screen.dart';
import 'package:flutter_application_88/search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'app_drawer.dart';
import 'core/constants/app_colors.dart';
import 'viewmodels/home_view_model.dart';
import 'views/chatbot_screen.dart';
import 'package:flutter_application_88/viewmodels/contact_vendor_view_model.dart';
import 'package:flutter_application_88/viewmodels/booking_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;
      context
          .read<HomeViewModel>()
          .loadHomeData();

    });
  }
Future<void> logout() async {
  final prefs =
      await SharedPreferences.getInstance();

  await prefs.clear();

  if (!mounted) return;

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => const LoginScreen(),
    ),
    (route) => false,
  );
}

  Widget _quickAction(
  IconData icon,
  String title,
  VoidCallback onTap,
  ) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 95,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    final homeVM = context.watch<HomeViewModel>();
    return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          backgroundColor:AppColors.bg,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text("Home",
          style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
    ),),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout,color: Colors.white,),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              
              Row(
                children: [
                  CircleAvatar(
                  radius: 30,
                  backgroundImage: homeVM.photo.isNotEmpty
                      ? NetworkImage(homeVM.photo)
                      : null,
                  child: homeVM.photo.isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, ${homeVM.name} 👋",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Text(
                          "Mumbai, Maharashtra",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                 Stack(
                  children: [

                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: 30,
                      ),

                      onPressed: () async {

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const NotificationScreen(),
                          ),
                        );

                        await homeVM.loadNotificationCount();
                      },
                    ),

                    if (homeVM.notificationCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          homeVM.notificationCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                ],
              ),
              
              

              const SizedBox(height: 25),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Quick Actions",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [

                  Expanded(
                    child: _quickAction(
                      Icons.search,
                      "Find",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SearchScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 9),

                  Expanded(
                    child: _quickAction(
                      Icons.calendar_month,
                      "Book",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const QuickBookingScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: _quickAction(
                      Icons.contact_mail,
                      "Contact Vendor",
                      () async {

                        final prefs =
                            await SharedPreferences.getInstance();

                        String userId =
                            prefs.getString("user_id") ?? "";

                        BookingViewModel bookingVM =
                            BookingViewModel();

                        await bookingVM.getBookings(userId);

                        if (bookingVM.bookingList.isEmpty) {

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                "No bookings found",
                              ),
                            ),
                          );

                          return;
                        }

                        final latestBooking =
                            bookingVM.bookingList.first;

                        if (!context.mounted) return;

                        context
                            .read<ContactVendorViewModel>()
                            .contactVendor(
                              booking: latestBooking,
                            );
                      },
                    ),
                  ),

                  const SizedBox(width: 9),

                  Expanded(
                    child: _quickAction(
                      Icons.qr_code_scanner,
                      "Payment",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const PaymentBookingScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              const SizedBox(height: 15),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Popular Categories",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),
              homeVM.isLoading
    ? const Center(
        child: CircularProgressIndicator(),
      )
    : SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: homeVM.banners.length,
          itemBuilder: (context, index) {
            return Container(
              width: 170,
              margin: const EdgeInsets.only(right: 12),
              child: Card(
                color: AppColors.card,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                        child: Image.network(
                          homeVM.banners[index]
                              ["category_image"],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.all(8),
                      child: Text(
                        homeVM.banners[index]
                            ["category_name"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),

              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: const [
                        Icon(
                          Icons.smart_toy,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Vendor AI Assistant",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Ask about vendors, pricing, bookings and recommendations.",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    SizedBox(height: 15),

                    const SizedBox(height: 15),

                                        Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ChatBotScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.chat_bubble_outline),
                            label: const Text(
                              "Start Chat",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () {
                              // Phone call action
                            },
                            icon: const Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}