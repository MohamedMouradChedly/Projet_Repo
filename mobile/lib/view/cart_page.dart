import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/course_view_model.dart';
import '../models/course_model.dart';
import 'PaymentPage.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courseVM = Provider.of<CourseViewModel>(context);

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
              children: [
                buildTopBar(context),
                const SizedBox(height: 20),

                Expanded(
                  child: courseVM.cartItems.isEmpty
                      ? const Center(
                    child: Text(
                      "Your cart is empty.",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                      : ListView.builder(
                    itemCount: courseVM.cartItems.length,
                    itemBuilder: (context, index) {
                      final c = courseVM.cartItems[index];
                      return cartItemCard(context, c, courseVM);
                    },
                  ),
                ),

                if (courseVM.cartItems.isNotEmpty)
                  Column(
                    children: [
                      totalSection(courseVM),
                      const SizedBox(height: 15),
                      checkoutButton(context),
                      const SizedBox(height: 25),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTopBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        const Text(
          "My Cart",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        const SizedBox(width: 40),
      ],
    );
  }

  Widget cartItemCard(
      BuildContext context, Course c, CourseViewModel courseVM) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.3)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.horizontal(left: Radius.circular(18)),
            child: Image.asset(
              c.photoAsset,
              width: 110,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    c.price <= 0 ? "Free" : "${c.price} DT",
                    style: const TextStyle(
                        color: Color(0xffFFD66B),
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () => courseVM.removeFromCart(c),
          )
        ],
      ),
    );
  }

  Widget totalSection(CourseViewModel courseVM) {
    final total = courseVM.cartItems.fold(0.0, (sum, item) => sum + item.price);

    return Container(
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
            "Total",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Text(
            "${total.toStringAsFixed(2)} DT",
            style: const TextStyle(
              color: Color(0xffFFD66B),
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  Widget checkoutButton(BuildContext context) {
    final courseVM = Provider.of<CourseViewModel>(context, listen: false);
    final total = courseVM.cartItems.fold(0.0, (sum, item) => sum + item.price);

    return SizedBox(
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
        onPressed: () {
          // Navigate to PaymentPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PaymentPage(
                courses: courseVM.cartItems,
                totalAmount: total,
              ),
            ),
          );
        },
        child: const Text(
          "Proceed to Checkout",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

}
