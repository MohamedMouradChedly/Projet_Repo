import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../viewmodel/course_view_model.dart';
import '../models/course_model.dart';
import 'login_page.dart';
import 'dashboard_page.dart';
import 'gestion_cours_page.dart';
import 'messages_page.dart';
import 'gestion_users_page.dart';

class AdministrationPage extends StatelessWidget {
  const AdministrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courseVM = Provider.of<CourseViewModel>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      drawer: buildDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Administration",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Déconnexion',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withOpacity(0.25),
        onPressed: () => showCourseDialog(context, courseVM: courseVM),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff7F7CFF), Color(0xffA77BFF), Color(0xffD77BFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: StreamBuilder<List<Course>>(
            stream: courseVM.getCoursesStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.white));
              }

              final courses = snapshot.data ?? [];
              if (courses.isEmpty) {
                return const Center(
                  child: Text(
                    "Aucun cours disponible.",
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              // Semester months: Nov → Apr
              final semesterMonths = [11, 12, 1, 2, 3, 4];
              Map<int, int> coursesPerSemester = { for (var m in semesterMonths) m : 0 };
              for (var course in courses) {
                final month = course.createdAt.month;
                if (semesterMonths.contains(month)) {
                  coursesPerSemester[month] =
                      (coursesPerSemester[month] ?? 0) + 1;
                }
              }

              final freeCourses = courses.where((c) => c.price <= 0).toList();
              final paidCourses = courses.where((c) => c.price > 0).toList();

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (freeCourses.isNotEmpty) ...[
                      sectionHeader("Cours gratuits"),
                      courseAdminHorizontal(context, freeCourses, courseVM),
                    ],
                    if (paidCourses.isNotEmpty) ...[
                      sectionHeader("Cours payants"),
                      courseAdminHorizontal(context, paidCourses, courseVM),
                    ],
                    const SizedBox(height: 20),
                    sectionHeader("Cours par semestre"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        height: 250,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: (coursesPerSemester.values.isEmpty
                                ? 1
                                : coursesPerSemester.values
                                .reduce(max)
                                .toDouble()) + 1,
                            barTouchData: BarTouchData(enabled: true),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 28,
                                  getTitlesWidget: (value, _) => Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 36,
                                  getTitlesWidget: (value, _) {
                                    const monthsNames = [
                                      "Nov", "Dec", "Jan", "Feb", "Mar", "Apr"
                                    ];
                                    final index = value.toInt().clamp(0, 5);
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        monthsNames[index],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            barGroups: List.generate(6, (i) {
                              final month = semesterMonths[i];
                              final value =
                                  coursesPerSemester[month]?.toDouble() ?? 0;
                              return BarChartGroupData(
                                x: i,
                                barRods: [
                                  BarChartRodData(
                                    toY: value,
                                    color: Colors.white.withOpacity(0.8),
                                    width: 16,
                                    borderRadius: BorderRadius.circular(6),
                                  )
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ------------------------- Sidebar -------------------------
  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff7F7CFF), Color(0xffA77BFF), Color(0xffD77BFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            sidebarButton(context, "Dashboard", Icons.dashboard,
                const DashboardPage()),
            sidebarButton(context, "Gestion de cours", Icons.book,
                const GestionCoursPage()),
            sidebarButton(context, "Messages", Icons.message,
                const MessagesPage()),
            sidebarButton(context, "Gestion des utilisateurs", Icons.people,
                const GestionUsersPage()),
          ],
        ),
      ),
    );
  }

  Widget sidebarButton(
      BuildContext context, String title, IconData icon, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.25),
          minimumSize: const Size(180, 50),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }

  Widget sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget courseAdminHorizontal(
      BuildContext context, List<Course> list, CourseViewModel courseVM) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: list.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        itemBuilder: (context, i) => adminCourseCard(context, list[i], courseVM),
      ),
    );
  }

  Widget adminCourseCard(
      BuildContext context, Course course, CourseViewModel courseVM) {
    return Container(
      width: 210,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.asset(
              course.photoAsset,
              height: 120,
              width: 210,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  course.price <= 0 ? "Gratuit" : "${course.price} DT",
                  style: const TextStyle(
                      color: Color(0xffFFD66B),
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                const SizedBox(height: 6),
                Text(
                  course.description ?? "",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white70),
                      onPressed: () => showCourseDialog(
                          context, courseVM: courseVM, course: course),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => courseVM.deleteCourse(course.id),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showCourseDialog(BuildContext context,
      {required CourseViewModel courseVM, Course? course}) {
    final titleController = TextEditingController(text: course?.title ?? "");
    final descController =
    TextEditingController(text: course?.description ?? "");
    final priceController =
    TextEditingController(text: course != null ? course.price.toString() : "0");
    final photoController =
    TextEditingController(text: course?.photoAsset ?? "assets/images/im1.png");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(course == null ? "Ajouter un cours" : "Modifier le cours"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Titre")),
              TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: "Description")),
              TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: "Prix"),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: photoController,
                  decoration:
                  const InputDecoration(labelText: "Photo (Asset Path)")),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text;
              final desc = descController.text;
              final price = double.tryParse(priceController.text) ?? 0;
              final photo = photoController.text;

              if (course == null) {
                courseVM.addCourse(title, desc, price, photoAsset: photo);
              } else {
                courseVM.updateCourse(
                  Course(
                    id: course.id,
                    title: title,
                    description: desc,
                    price: price,
                    photoAsset: photo,
                    createdAt: course.createdAt,
                  ),
                );
              }

              Navigator.pop(context);
            },
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );
  }
}
