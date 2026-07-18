import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryViewModel {

  Future<List<dynamic>> getCategories() async {

    try {

      final response = await http.get(
        Uri.parse(
          'https://akashsir.in/atproject/atfinder-web/api/api-list-category.php',
        ),
      );

      final data = jsonDecode(response.body);

      if (data["flag"] == "1") {
        return data["category_list"];
      }

      return [];

    } catch (e) {
      print(e);
      return [];
    }
  }
}