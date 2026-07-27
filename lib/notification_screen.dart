import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState
    extends State<NotificationScreen> {

  List notifications = [];

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }
  String formatTime(String time) {
      DateTime dateTime = DateTime.parse(time);

      Duration diff =
          DateTime.now().difference(dateTime);

      String ago = "";

      if (diff.inMinutes < 60) {
        ago = "${diff.inMinutes} min ago";
      } else if (diff.inHours < 24) {
        ago = "${diff.inHours} hr ago";
      } else {
        ago = "${diff.inDays} days ago";
      }

      String formattedDate =
          "${dateTime.day.toString().padLeft(2, '0')}-"
          "${dateTime.month.toString().padLeft(2, '0')}-"
          "${dateTime.year}";

      return "$formattedDate | $ago";
    }
  Future<void> loadNotifications() async {

    final prefs =
        await SharedPreferences.getInstance();

    List<String> data =
        prefs.getStringList(
              "notifications",
            ) ??
            [];
    await prefs.setInt(
      "notification_count",
      0,
    );
    setState(() {
      notifications = data
          .map((e) => jsonDecode(e))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
        ),
      ),

      body: notifications.isEmpty
          ? const Center(
              child: Text(
                "No Notifications Yet",
              ),
            )
          : ListView.builder(
              itemCount:
                  notifications.length,

              itemBuilder:
                  (context, index) {

                final item =
                    notifications[index];

                return Card(
                  margin:
                      const EdgeInsets.all(
                    10,
                  ),

                  child: ListTile(
                    leading: const Icon(
                      Icons.notifications,
                      color: Colors.blue,
                    ),

                   onTap: () async {

                    bool? delete =
                        await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text(
                          "Delete Notification",
                        ),
                        content: const Text(
                          "Remove this notification?",
                        ),
                        actions: [

                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                context,
                                false,
                              );
                            },
                            child: const Text(
                              "Cancel",
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                context,
                                true,
                              );
                            },
                            child: const Text(
                              "Delete",
                            ),
                          ),
                        ],
                      ),
                    );

                    if (delete == true) {

                      final prefs =
                          await SharedPreferences.getInstance();

                      notifications.removeAt(index);

                      await prefs.setStringList(
                        "notifications",
                        notifications
                            .map((e) => jsonEncode(e))
                            .toList(),
                      );

                      setState(() {});
                    }
                  },

                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [

                        Text(
                          item["message"],
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                       Text(
                          formatTime(item["time"]),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
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