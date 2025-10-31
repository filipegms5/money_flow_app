
import 'package:meta/meta.dart';
import 'dart:convert';

Scan scanFromJson(String str) => Scan.fromJson(json.decode(str));

String scanToJson(Scan data) => json.encode(data.toJson());

class Scan {
  final String url;

  Scan({
    required this.url,
  });

  factory Scan.fromJson(Map<String, dynamic> json) => Scan(
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
  };
}
