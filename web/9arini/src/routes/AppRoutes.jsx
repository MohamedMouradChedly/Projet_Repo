import React from "react";
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Home from "../views/Home/Home";
import Register from '../views/Auth/Register';
import Login from '../views/Auth/Login';
import About from "../views/About/About";
import AdminDashboard from "../views/Admin/AdminDashboard";
import ManageCourses from "../views/Admin/ManageCourses";
import CourseList from "../views/Courses/CourseList";
import AppHome from "../views/Home/AppHome";
import ManageUsers from "../views/Admin/ManageUsers";
import MyCourses from "../views/Courses/MyCourses";
import Profile from "../views/Profile/Profile";
import ManageChapters from "../views/Admin/ManageChapters";
import CourseDetails from "../views/Courses/CourseDetails"; //
import Cart from "../views/Cart/Cart";
import PaymentSuccess from "../views/Cart/PaymentSuccess";
import AdminStats from "../views/Admin/AdminStats";



export default function AppRoutes() {
  return (
    <Router>
      <Routes>
        {/* PUBLIC PAGES */}
        <Route path="/" element={<Home />} />
        <Route path="/about" element={<About />} />
        <Route path="/courses" element={<CourseList />} />
        <Route path="/auth/login" element={<Login />} />
        <Route path="/auth/register" element={<Register />} />

        {/* LOGGED-IN AREA */}
        <Route path="/app/home" element={<AppHome />} />
        <Route path="/my-courses" element={<MyCourses />} />
        <Route path="/profile" element={<Profile />} />
        <Route path="/admin/courses/:courseId/chapters" element={<ManageChapters />} />
        <Route path="/courses/:courseId" element={<CourseDetails />} />
        <Route path="/cart" element={<Cart />} />
        <Route path="/payment/success" element={<PaymentSuccess />} />

        {/* ADMIN */}
        <Route path="/admin" element={<AdminDashboard />} />
        <Route path="/admin/courses" element={<ManageCourses />} />
        <Route path="/admin/users" element={<ManageUsers />} />
        <Route path="/admin/stats" element={<AdminStats />} />

      </Routes>
    </Router>
  );
}

