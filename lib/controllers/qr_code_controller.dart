import 'dart:convert';

import 'package:money_flow_app/models/scan_model.dart';

import '../utils/endpoints.dart';
import 'package:http/http.dart' as http;

import 'base_controller.dart';

class QrCodeController extends BaseController {
  Future<String> postQrCode(String code) async {
    await ensureInitialized();

    Scan scan = Scan(url: code);

    final url = Uri.parse('${Endpoint.baseURL}${Endpoint.qrCode}');
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(scan.toJson()),);

    if (response.statusCode == 200) {
      return code;
    }else{
      throw Exception('Erro: ${response.statusCode}');
    }

  }
}