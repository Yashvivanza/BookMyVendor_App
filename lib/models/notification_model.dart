class NotificationModel {
  String title;
  String message;
  String time;

  NotificationModel({
    required this.title,
    required this.message,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "message": message,
      "time": time,
    };
  }

  factory NotificationModel.fromJson(
      Map<String, dynamic> json) {
    return NotificationModel(
      title: json["title"],
      message: json["message"],
      time: json["time"],
    );
  }
}