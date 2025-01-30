import 'package:flutter_sms/flutter_sms.dart';

class SmsService {
  Future<List<String>> fetchSms() async {
    // Fetch SMS messages (requires permissions)
    List<String> messages = await FlutterSms.getInboxSms;
    return messages;
  }
}
