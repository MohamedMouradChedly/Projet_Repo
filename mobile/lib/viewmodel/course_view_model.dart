import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_model.dart';

class CourseViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Random _random = Random();

  List<Course> _courses = [];
  List<Course> get courses => _courses;

  List<Course> cartItems = [];

  // Stream to listen for courses from Firestore
  Stream<List<Course>> getCoursesStream() {
    return _firestore.collection('courses').snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) =>
          Course.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList(),
    );
  }

  // -------------------------
  // CRUD OPERATIONS
  // -------------------------
  Future<void> addCourse(String title, String description, double price,
      {required String photoAsset}) async {
    final now = DateTime.now();

    final docRef = await _firestore.collection('courses').add({
      'title': title,
      'description': description,
      'price': price,
      'photoAsset': photoAsset,
      'createdAt': now.toIso8601String(),
    });

    _courses.add(Course(
      id: docRef.id,
      title: title,
      description: description,
      price: price,
      photoAsset: photoAsset,
      createdAt: now,
    ));
    notifyListeners();
  }

  Future<void> updateCourse(Course course) async {
    await _firestore.collection('courses').doc(course.id).update({
      'title': course.title,
      'description': course.description,
      'price': course.price,
      'photoAsset': course.photoAsset,
      'createdAt': course.createdAt.toIso8601String(),
    });

    int index = _courses.indexWhere((c) => c.id == course.id);
    if (index != -1) _courses[index] = course;
    notifyListeners();
  }

  Future<void> deleteCourse(String id) async {
    await _firestore.collection('courses').doc(id).delete();
    _courses.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // -------------------------
  // CART METHODS
  // -------------------------
  void addToCart(Course course) {
    if (!cartItems.contains(course)) {
      cartItems.add(course);
      notifyListeners();
    }
  }

  void removeFromCart(Course course) {
    cartItems.remove(course);
    notifyListeners();
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }

  // -------------------------
  // INITIALIZE CART FOR NEW USER
  // -------------------------
  void initializeCartForNewUser(List<Course> availableCourses,
      {int itemCount = 3}) {
    if (availableCourses.isEmpty) return;

    cartItems = List.generate(itemCount, (_) {
      final course = availableCourses[_random.nextInt(availableCourses.length)];
      return Course(
        id: course.id,
        title: course.title,
        description: course.description,
        price: course.price > 0 ? course.price : (_random.nextInt(50) + 1),
        photoAsset: course.photoAsset,
        createdAt: course.createdAt,
      );
    });

    notifyListeners();
  }
}
