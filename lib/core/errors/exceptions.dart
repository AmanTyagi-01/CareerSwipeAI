import 'package:equatable/equatable.dart';

abstract class AppException implements Exception {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  AppException({
    required this.message,
    this.code,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

class NetworkException extends AppException {
  NetworkException({
    super.message = 'Network connection failed. Please check your internet.',
    String? code,
    super.stackTrace,
  }) : super(code: code ?? 'NETWORK_ERROR');
}

class ServerException extends AppException {
  ServerException({
    super.message = 'Server error occurred. Please try again later.',
    String? code,
    super.stackTrace,
  }) : super(code: code ?? 'SERVER_ERROR');
}

class AuthException extends AppException {
  AuthException({
    super.message = 'Authentication failed.',
    String? code,
    super.stackTrace,
  }) : super(code: code ?? 'AUTH_ERROR');
}

class ValidationException extends AppException {
  ValidationException({
    super.message = 'Validation failed.',
    String? code,
    super.stackTrace,
  }) : super(code: code ?? 'VALIDATION_ERROR');
}

class NotFoundException extends AppException {
  NotFoundException({
    super.message = 'Resource not found.',
    String? code,
    super.stackTrace,
  }) : super(code: code ?? 'NOT_FOUND');
}

class FileException extends AppException {
  FileException({
    super.message = 'File operation failed.',
    String? code,
    super.stackTrace,
  }) : super(code: code ?? 'FILE_ERROR');
}

class AIException extends AppException {
  AIException({
    super.message = 'AI processing failed.',
    String? code,
    super.stackTrace,
  }) : super(code: code ?? 'AI_ERROR');
}

class CacheException extends AppException {
  CacheException({
    super.message = 'Cache operation failed.',
    String? code,
    super.stackTrace,
  }) : super(code: code ?? 'CACHE_ERROR');
}

class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

class NetworkFailure extends Failure {
  const NetworkFailure(
      {super.message = 'Network connection failed',
      super.code = 'NETWORK_ERROR'});
}

class ServerFailure extends Failure {
  const ServerFailure(
      {super.message = 'Server error occurred', super.code = 'SERVER_ERROR'});
}

class AuthFailure extends Failure {
  const AuthFailure(
      {super.message = 'Authentication failed', super.code = 'AUTH_ERROR'});
}

class ValidationFailure extends Failure {
  const ValidationFailure(
      {super.message = 'Validation failed', super.code = 'VALIDATION_ERROR'});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(
      {super.message = 'Resource not found', super.code = 'NOT_FOUND'});
}

class FileFailure extends Failure {
  const FileFailure(
      {super.message = 'File operation failed', super.code = 'FILE_ERROR'});
}

class AIFailure extends Failure {
  const AIFailure(
      {super.message = 'AI processing failed', super.code = 'AI_ERROR'});
}
