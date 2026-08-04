import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/chat_message_model.dart';
import '../services/groq_service.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
class ChatBotViewModel extends ChangeNotifier { 
  ChatBotViewModel() 
  {
      initSpeech();
      

      messages.add(
        ChatMessageModel(
          text: """
    👋 Welcome to BookMyVendor AI!

    I can help you discover vendors, compare services, and find options within your budget.

    Try:
    📸 Photography
    💄 Makeup
    🎨 Mehendi
    🏛️ Venues
    💰 Budget-friendly services 
    """,
          isUser: false,
        ),
      );
  }

  final GroqService _service = GroqService();

  final TextEditingController messageController =
      TextEditingController();

  final stt.SpeechToText speech =
      stt.SpeechToText();

  List<ChatMessageModel> messages = [];

  bool isLoading = false;

  bool isListening = false;
  Timer? _speechTimer; 

  void clearChat() {
    messages.clear();
    messages.add(
      ChatMessageModel(
        text: """
  👋 Welcome to BookMyVendor AI!

  I can help you discover vendors, compare services, and find options within your budget.

  Try:
  📸 Photography
  💄 Makeup
  🎨 Mehendi
  🏛️ Venues
  💰 Budget-friendly services
  """,
        isUser: false,
      ),
    );

    notifyListeners();
  }
  
 Future<void> initSpeech() async {
  bool available = await speech.initialize(
    onStatus: (status) {
      debugPrint("Status: $status");
    },
    onError: (error) {
      debugPrint("Error: $error");
    },
  );

  debugPrint("Speech Init: $available");
}
  Future<String?> getDeviceLanguage() async {
  var locales = await speech.locales();

  if (locales.isNotEmpty) {
    return locales.first.localeId;
  }

  return null;
}
    
  Future<void> startListening(
    TextEditingController controller,
  ) async {

    if (!await speech.initialize()) {
      debugPrint(
        "Speech not available",
      );
      return;
    }

    isListening = true;
    notifyListeners();
    await speech.listen(
      localeId: await getDeviceLanguage(),
      listenMode: stt.ListenMode.confirmation,

      onResult: (result) {

        controller.text =
            result.recognizedWords;

        controller.selection =
            TextSelection.fromPosition(
          TextPosition(
            offset: controller.text.length,
          ),
        );

        notifyListeners();
      },
    );
    
    _speechTimer?.cancel();

    _speechTimer = Timer(
      const Duration(seconds: 6),
      () async {

        await speech.stop();

        isListening = false;

        notifyListeners();
      },
    );
  }

  Future<void> stopListening() async {

    _speechTimer?.cancel();

    await speech.stop();

    isListening = false;

    notifyListeners();
  }

  Future<void> sendMessage() async {

    String text =
        messageController.text.trim();

    if (text.isEmpty) return;

    messages.add(
      ChatMessageModel(
        text: text,
        isUser: true,
      ),
    );

    messageController.clear();

    isLoading = true;

    notifyListeners();

    try {

    final categories = await getCategories();
    final services = await getServices();
    
    String query = text.toLowerCase();

    /// SHOW AVAILABLE SERVICES
    if (query.contains("available services") ||
        query.contains("what services") ||
        query.contains("list services")) {

      Set<String> categorySet = {};

      for (var service in services) {
        categorySet.add(
            service["category"]["sub_category_name"].toString(),
        );
      }

      String reply =
          "Available Service Categories:\n\n";

      int i = 1;

      for (var category in categorySet) {
        reply += "$i. $category\n";
        i++;
      }

      reply +=
          "\nType a category name to see its services.";

      messages.add(
        ChatMessageModel(
          text: reply,
          isUser: false,
        ),
      );

      isLoading = false;
      notifyListeners();
      return;
    }

    /// CHEAPEST SERVICE
    if (query.contains("cheapest")) {

      services.sort(
        (a, b) => double.parse(
          a["service_price"].toString(),
        ).compareTo(
          double.parse(
            b["service_price"].toString(),
          ),
        ),
      );

      var cheapest = services.first;

      String reply =
          "The cheapest service is "
          "${cheapest["service_name"]} "
          "for ₹${cheapest["service_price"]}";

      messages.add(
        ChatMessageModel(
          text: reply,
          isUser: false,
        ),
      );

      isLoading = false;
      notifyListeners();
      return;
    }

    String categoryContext = categories
        .map((e) => e["category_name"])
        .join(", ");

    String serviceContext = services
    .map(
      (e) =>
          "${e["service_name"]} | Category: ${e["category"]["sub_category_name"]} | Price: ₹${e["service_price"]}",
    )
    .join("\n");

    String prompt = """
    You are BookMyVendor AI Assistant.

    Available Categories:
    $categoryContext

    Available Services:
    $serviceContext

    User Question:
    $text

    Instructions:
    - Answer only using the provided BookMyVendor data.
    - Recommend relevant services when asked.
    - Mention prices whenever available.
    - If no matching service exists, politely say it is not available.
    - Keep answers short and user-friendly.

    LANGUAGE RULE:
    - Detect the language of the user's question.
    - If the user writes in Gujarati, reply in Gujarati.
    - If the user writes in Hindi, reply in Hindi.
    - If the user writes in English, reply in English.
    - Always answer in the same language used by the user.
    """;

String reply = await _service.sendMessage(prompt);
      messages.add(
        ChatMessageModel(
          text: reply,
          isUser: false,
        ),
      );

    } catch (e) {

      messages.add(
        ChatMessageModel(
          text: "Error: $e",
          isUser: false,
        ),
      );
    }

    isLoading = false;

    notifyListeners();
  }

  @override
  void dispose() {

    _speechTimer?.cancel();

    messageController.dispose();

    speech.stop();

    super.dispose();
  }
  Future<List<dynamic>> getCategories() async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://akashsir.in/atproject/atfinder-web/api/api-list-category.php',
        ),
      );

      final data = jsonDecode(response.body);

      if (data["flag"] == "1") {
        return data["category_list"];
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return [];
  }
  Future<List<dynamic>> getServices() async {
  try {
    final response = await http.post(
      Uri.parse(
        'https://akashsir.in/atproject/atfinder-web/api/api-list-service.php',
      ),
    );
    debugPrint(response.body);
    final data = jsonDecode(response.body);

    if (data["flag"] == "1") {
      return data["service_list"];
    }
  } catch (e) {
    debugPrint(e.toString());
  }

  return [];
}
}