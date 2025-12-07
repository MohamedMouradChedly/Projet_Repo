import React, { useEffect, useState } from "react";
import { getAllUsers } from "../../services/firebase/userService";
import { getAllCourses } from "../../services/firebase/courseService";
import { getAllEnrollments } from "../../services/firebase/enrollmentService";
import "./AdminStats.css"; // We will create this simple CSS

export default function AdminStats() {
  const [stats, setStats] = useState({
    users: 0,
    courses: 0,
    enrollments: 0,
    paidCourses: 0,
    freeCourses: 0
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadData = async () => {
      setLoading(true);
      try {
        // 1. Fetch all data in parallel for speed
        const [usersData, coursesData, enrollmentsCount] = await Promise.all([
          getAllUsers(),
          getAllCourses(),
          getAllEnrollments()
        ]);

        // 2. Calculate specifics
        const paid = coursesData.filter(c => c.type === 'payant').length;
        const free = coursesData.filter(c => c.type !== 'payant').length;

        setStats({
          users: usersData.length,
          courses: coursesData.length,
          enrollments: enrollmentsCount,
          paidCourses: paid,
          freeCourses: free
        });

      } catch (error) {
        console.error("Error loading stats:", error);
      } finally {
        setLoading(false);
      }
    };

    loadData();
  }, []);

  return (
    <div className="stats-page">
      <main className="stats-main">
        <h1 className="stats-title">Tableau de bord</h1>
        <p className="stats-subtitle">Vue d'ensemble des performances de 9arini.</p>

        {loading ? (
          <p>Chargement des données...</p>
        ) : (
          <div className="stats-grid">
            {/* Card 1: Users */}
            <div className="stat-card blue-card">
              <div className="stat-icon">👥</div>
              <div className="stat-info">
                <h3>Utilisateurs</h3>
                <p className="stat-number">{stats.users}</p>
              </div>
            </div>

            {/* Card 2: Total Courses */}
            <div className="stat-card purple-card">
              <div className="stat-icon">📚</div>
              <div className="stat-info">
                <h3>Cours Totaux</h3>
                <p className="stat-number">{stats.courses}</p>
              </div>
            </div>

            {/* Card 3: Enrollments */}
            <div className="stat-card green-card">
              <div className="stat-icon">🎓</div>
              <div className="stat-info">
                <h3>Inscriptions</h3>
                <p className="stat-number">{stats.enrollments}</p>
              </div>
            </div>

            {/* Card 4: Catalog Breakdown */}
            <div className="stat-card orange-card">
              <div className="stat-icon">📊</div>
              <div className="stat-info">
                <h3>Catalogue</h3>
                <div className="stat-details">
                  <span>Payants: <strong>{stats.paidCourses}</strong></span>
                  <span>Gratuits: <strong>{stats.freeCourses}</strong></span>
                </div>
              </div>
            </div>
          </div>
        )}
      </main>
    </div>
  );
}
