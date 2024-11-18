import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestHandler {
  final bool development;
  RequestHandler({this.development = true});
  String get baseUrl {
    return development
        ? 'http://192.168.100.151:8888'
        : 'https://instantmine.netlify.app';
  }

  Future<Map<String, dynamic>> handleRequest(
    BuildContext context,
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    await _showLoading(context);

    try {
      final url = Uri.parse('$baseUrl/.netlify/functions/api/$endpoint');
      final response = await http.post(
        url,
        headers: headers ?? {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        return responseData;
      } else if (responseData['success'] == false) {
        return {
          'success': false,
          'message': responseData['message'] ?? "Invalid username or password."
        };
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return {'success': false, 'message': 'Request failed'};
    }
  }

  Future<void> _showLoading(BuildContext context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const PopScope(
          canPop: true,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
