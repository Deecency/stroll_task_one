// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:flutter/material.dart';

///This is the base class exception which can be
///used to throw with a message
class BaseException implements Exception {
  BaseException({this.message = 'Unknown Error'});
  final String? message;
}

///This class used to throw error from API Providers
@immutable
class APIException implements BaseException {
  const APIException({
    required this.errorMessage,
    this.statusCode,
    this.statusMessage,
  });

  factory APIException.fromMap(Map<String, dynamic> map) {
    return APIException(
      statusCode: map['statusCode']?.toInt() as int,
      statusMessage: map['statusMessage'] as String?,
      errorMessage: (map['errorMessage'] as String?) ?? '',
    );
  }

  factory APIException.fromJson(String source) {
    final j = json.decode(source);

    if (j is Map<String, dynamic>) {
      return APIException.fromMap(j);
    }
    throw BaseException();
  }

  final int? statusCode;
  final String? statusMessage;
  final String errorMessage;

  APIException copyWith({
    int? statusCode,
    String? statusMessage,
    String? errorMessage,
  }) {
    return APIException(
      statusCode: statusCode ?? this.statusCode,
      statusMessage: statusMessage ?? this.statusMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'statusCode': statusCode,
      'statusMessage': statusMessage,
      'errorMessage': errorMessage,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'APIException(statusCode: $statusCode, statusMessage: $statusMessage, errorMessage: $errorMessage)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is APIException &&
        other.statusCode == statusCode &&
        other.statusMessage == statusMessage &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode =>
      statusCode.hashCode ^ statusMessage.hashCode ^ errorMessage.hashCode;

  @override
  String get message => errorMessage;
}
