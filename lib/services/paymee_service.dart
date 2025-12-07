import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaymeeService {
  static const String apiKey = "98ce51ef202cfa8dc9bf31f3153face567f32ef5";
  static const int vendorId = 4101;

  // -----------------------------
  // CREATE PAYMENT
  // -----------------------------
  static Future<String> createPayment({
    required double amount, // in DT
    required String orderId,
    String firstName = "Test",
    String lastName = "Client",
    String email = "test@paymee.tn",
    String phone = "22222222",
    String returnUrl =
    "https://fulgorous-malakai-unpersonalized.ngrok-free.dev/payment/success",
    String cancelUrl =
    "https://fulgorous-malakai-unpersonalized.ngrok-free.dev/payment/cart",
    String webhookUrl =
    "https://fulgorous-malakai-unpersonalized.ngrok-free.dev/payment/webhook",
  }) async {
    final payload = {
      "vendor": vendorId,
      "amount": amount,
      "note": "Order $orderId",
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "phone": phone,
      "return_url": returnUrl,
      "cancel_url": cancelUrl,
      "webhook_url": webhookUrl,
      "order_id": orderId,
    };

    print("Sending Paymee Payload: $payload");

    try {
      final response = await http.post(
        Uri.parse("https://sandbox.paymee.tn/api/v2/payments/create"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Token $apiKey",
        },
        body: jsonEncode(payload),
      );

      final data = jsonDecode(response.body);
      print("Paymee Response: $data");

      if (data['status'] == true && data['data']?['payment_url'] != null) {
        return data['data']['payment_url'];
      } else {
        throw Exception(data['message'] ?? "Paymee failed");
      }
    } catch (e) {
      print("Paymee Network Error: $e");
      rethrow;
    }
  }

  // -----------------------------
  // OPEN PAYMENT PAGE
  // -----------------------------
  static Future<void> launchPayment(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception("Could not open Paymee payment page");
    }
  }

  // -----------------------------
  // FULL FLOW
  // -----------------------------
  static Future<void> pay({
    required double amount,
    required String orderId,
  }) async {
    print("🔵 STEP 1: Creating Paymee order...");
    final url = await createPayment(amount: amount, orderId: orderId);

    print("🟡 STEP 2: Redirecting to Paymee...");
    await launchPayment(url);
  }
}
