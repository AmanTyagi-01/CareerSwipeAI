import 'package:flutter_test/flutter_test.dart';
import 'package:career_swipe_ai/core/utils/app_utils.dart';

void main() {
  group('AppUtils Tests', () {
    test('generateId returns non-empty string', () {
      final id = AppUtils.generateId();
      expect(id, isNotEmpty);
      expect(id.length, greaterThan(10));
    });

    test('generateOTP returns 6 digits', () {
      final otp = AppUtils.generateOTP();
      expect(otp.length, equals(6));
      expect(int.tryParse(otp), isNotNull);
    });

    test('formatDate formats correctly', () {
      final date = DateTime(2024, 6, 15);
      final formatted = AppUtils.formatDate(date);
      expect(formatted, equals('Jun 15, 2024'));
    });

    test('formatRelativeTime returns correct string', () {
      final now = DateTime.now();

      expect(
          AppUtils.formatRelativeTime(
              now.subtract(const Duration(seconds: 30))),
          equals('Just now'));
      expect(
          AppUtils.formatRelativeTime(now.subtract(const Duration(minutes: 5))),
          equals('5m ago'));
      expect(
          AppUtils.formatRelativeTime(now.subtract(const Duration(hours: 2))),
          equals('2h ago'));
      expect(AppUtils.formatRelativeTime(now.subtract(const Duration(days: 3))),
          equals('3d ago'));
    });

    test('formatNumber formats correctly', () {
      expect(AppUtils.formatNumber(500), equals('500'));
      expect(AppUtils.formatNumber(1500), equals('1.5K'));
      expect(AppUtils.formatNumber(2500000), equals('2.5M'));
    });

    test('maskEmail masks correctly', () {
      expect(
          AppUtils.maskEmail('john@example.com'), equals('jo***@example.com'));
      expect(AppUtils.maskEmail('ab@example.com'), equals('ab@example.com'));
      expect(AppUtils.maskEmail(''), equals(''));
    });

    test('isValidEmail validates correctly', () {
      expect(AppUtils.isValidEmail('test@example.com'), isTrue);
      expect(AppUtils.isValidEmail('invalid'), isFalse);
      expect(AppUtils.isValidEmail('@example.com'), isFalse);
      expect(AppUtils.isValidEmail(''), isFalse);
    });

    test('isValidPassword validates correctly', () {
      expect(AppUtils.isValidPassword('Password123'), isTrue);
      expect(AppUtils.isValidPassword('short'), isFalse);
      expect(AppUtils.isValidPassword('nouppercase123'), isFalse);
      expect(AppUtils.isValidPassword('NOLOWERCASE123'), isFalse);
      expect(AppUtils.isValidPassword('NoNumbers'), isFalse);
    });

    test('getInitials returns correct initials', () {
      expect(AppUtils.getInitials('John Doe'), equals('JD'));
      expect(AppUtils.getInitials('John'), equals('J'));
      expect(AppUtils.getInitials(''), equals('?'));
    });

    test('formatFileSize formats correctly', () {
      expect(AppUtils.formatFileSize(500), equals('500 B'));
      expect(AppUtils.formatFileSize(2048), equals('2.0 KB'));
      expect(AppUtils.formatFileSize(2097152), equals('2.0 MB'));
    });
  });
}
