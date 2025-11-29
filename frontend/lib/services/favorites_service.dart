import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Manages favorites locally (SharedPreferences) and optionally syncs with remote API.
/// Stores IDs as Strings because your BookModel.id is String.
class FavoritesService {
  static const _prefsKey = 'favorites_ids';
  final String baseUrl; // e.g. https://api.example.com

  FavoritesService({required this.baseUrl});

  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  Future<List<String>> getLocalFavorites() async {
    try {
      final p = await _prefs;
      final jsonString = p.getString(_prefsKey);
      if (jsonString == null) return [];
      final List<dynamic> list = json.decode(jsonString);
      return list.map((e) => e.toString()).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> setLocalFavorites(List<String> ids) async {
    final p = await _prefs;
    await p.setString(_prefsKey, json.encode(ids));
  }

  Future<bool> isFavorite(String bookId) async {
    final ids = await getLocalFavorites();
    return ids.contains(bookId);
  }

  Future<void> addFavoriteLocal(String bookId) async {
    final ids = await getLocalFavorites();
    if (!ids.contains(bookId)) ids.add(bookId);
    await setLocalFavorites(ids);
  }

  Future<void> removeFavoriteLocal(String bookId) async {
    final ids = await getLocalFavorites();
    ids.remove(bookId);
    await setLocalFavorites(ids);
  }

  // ---------- Remote API (skeletons) ----------
  // These methods assume authToken (JWT) if required. Adapt headers as needed.

  Future<List<String>> fetchRemoteFavorites(String authToken) async {
    final url = Uri.parse('$baseUrl/favorites/list');
    try {
      final res = await http.get(url, headers: {'Authorization': 'Bearer $authToken'});
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as List<dynamic>;
        return data.map((e) => e.toString()).toList();
      }
    } catch (e) {
      // ignore network errors for background sync
    }
    return [];
  }

  Future<void> addFavoriteRemote(String bookId, String authToken) async {
    final url = Uri.parse('$baseUrl/favorites/add');
    final body = json.encode({'book_id': bookId});
    final res = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken'
    }, body: body);
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to add favorite (remote)');
    }
  }

  Future<void> removeFavoriteRemote(String bookId, String authToken) async {
    final url = Uri.parse('$baseUrl/favorites/remove');
    final body = json.encode({'book_id': bookId});
    final res = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken'
    }, body: body);
    if (res.statusCode != 200) {
      throw Exception('Failed to remove favorite (remote)');
    }
  }
}
