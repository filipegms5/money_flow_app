import 'dart:convert';

import 'package:money_flow_app/models/scan_model.dart';

import '../utils/endpoints.dart';
import 'package:http/http.dart' as http;

class QrCodeController{
  Future<String> postQrCode(String code) async {
    Scan scan = Scan(url: code);

    final url = Uri.parse('${Endpoint.baseURL}${Endpoint.qrCode}');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(scan.toJson()),);

    if (response.statusCode == 200) {
      return code;
    }else{
      throw Exception('Erro: ${response.statusCode}');
    }

  }
}