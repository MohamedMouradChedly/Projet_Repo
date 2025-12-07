import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/auth_view_model.dart';
import '../models/course_model.dart';
import '../services/paymee_service.dart'; // <-- Make sure the path is correct

class PaymentPage extends StatelessWidget {
  final List<Course> courses;
  final double totalAmount; // in DT

  const PaymentPage({
    super.key,
    required this.courses,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff7F7CFF),
              Color(0xffA77BFF),
              Color(0xffD77BFF),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- App Bar ---
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    const Text(
                      "Payment",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 30),

                // --- Total Amount ---
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Amount",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${totalAmount.toStringAsFixed(2)} DT",
                        style: const TextStyle(
                          color: Color(0xffFFD66B),
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // --- Confirm Payment Button ---
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFFD66B),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          // Optional: check wallet balance first
                          if (auth.walletBalance != null &&
                              auth.walletBalance! < totalAmount) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Insufficient balance in wallet!"),
                              ),
                            );
                            return;
                          }

                          // Use PaymeeService to process payment
                          await PaymeeService.pay(
                            amount: totalAmount, // DT amount as double
                            orderId: DateTime.now().millisecondsSinceEpoch.toString(),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Payment flow initiated!"),
                            ),
                          );

                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Payment failed: $e"),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Confirm Payment",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
