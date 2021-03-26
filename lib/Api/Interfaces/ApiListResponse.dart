import 'package:flutter/material.dart';

class ApiListResponse<T> {
  List<T> items = [];
  int total = 0;

  ApiListResponse({this.items, this.total});

  @override
  String toString() {
    return items.join(',');
  }

  factory ApiListResponse.fromJson(
    Map<String, dynamic> json, {
    @required T Function(Map<String, dynamic> json) mapper,
  }) {
    if (mapper == null) {
      throw ArgumentError.notNull('mapper');
    }

    return ApiListResponse(
      items: List.from(json['elements']).map((el) => mapper(el)).toList(),
      total: json['total'],
    );
  }
}
