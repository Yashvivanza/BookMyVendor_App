import 'package:shared_preferences/shared_preferences.dart';

class FavouriteViewModel {

  Future<bool> isFavourite(
      String serviceId) async {

    final prefs =
        await SharedPreferences.getInstance();

    List<String> favourites =
        prefs.getStringList("favourites") ?? [];

    return favourites.contains(serviceId);
  }

  Future<bool> toggleFavourite(
      String serviceId) async {

    final prefs =
        await SharedPreferences.getInstance();

    List<String> favourites =
        prefs.getStringList("favourites") ?? [];

    bool favourite;

    if (favourites.contains(serviceId)) {

      favourites.remove(serviceId);

      favourite = false;

    } else {

      favourites.add(serviceId);

      favourite = true;
    }

    await prefs.setStringList(
      "favourites",
      favourites,
    );

    return favourite;
  }
}