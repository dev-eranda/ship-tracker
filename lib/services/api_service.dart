import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/models/user.dart';
import '../core/models/vessel.dart';

class ApiService {
  final String baseUrl;
  final Future<String?> Function() getToken;

  ApiService({required this.baseUrl, required this.getToken});

  Future<Map<String, String>> _headers() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<User> fetchUser(int id) async {
    final res = await http.get(
      Uri.parse('$baseUrl/users/$id'),
      headers: await _headers(),
    );

    if (res.statusCode == 404) {
      throw Exception('User not found');
    }
    if (res.statusCode != 200) {
      throw Exception('Failed to load user (${res.statusCode})');
    }

    final body = jsonDecode(res.body);
    final json =
        (body is Map<String, dynamic> && body['data'] is Map<String, dynamic>)
        ? body['data'] as Map<String, dynamic>
        : body as Map<String, dynamic>;

    return User.fromJson(json);
  }

  Future<List<User>> fetchUsers() async {
    final res = await http.get(
      Uri.parse('$baseUrl/users'),
      // headers: await _headers(),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load users (${res.statusCode})');
    }

    final body = jsonDecode(res.body);
    final list = body is List ? body : (body['data'] as List);
    return list.map((e) => User.fromJson(e)).toList();
  }

  Future<List<Vessel>> fetchVessels() async {
    final res = await http.get(
      Uri.parse('$baseUrl/vessels'),
      headers: await _headers(),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load vessels  (${res.statusCode})');
    }

    final body = jsonDecode(res.body);
    final list = body is List ? body : (body['data'] as List);
    return list.map((e) => Vessel.fromJson(e)).toList();
  }

  Future<List<int>> fetchAssignedVesselIds(String userId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/users/$userId/vessels'),
      headers: await _headers(),
    );
    if (res.statusCode != 200) return [];
    final body = jsonDecode(res.body);
    final list = body is List ? body : (body['data'] as List);
    return list.map<int>((e) => e['id'] as int).toList();
  }

  Future<void> assignVessels(String userId, List<int> vesselIds) async {
    final res = await http.post(
      Uri.parse('$baseUrl/users/$userId/vessels'),
      headers: await _headers(),
      body: jsonEncode({'vessel_ids': vesselIds}),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(
        'Failed to assign vessels (${res.statusCode}): ${res.body}',
      );
    }
  }
}
