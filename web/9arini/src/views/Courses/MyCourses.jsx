import React, { useEffect, useState, useContext } from "react";
import { useNavigate } from "react-router-dom";
import Header from "../../core/components/Header";
import Footer from "../../core/components/Footer";
import CourseCard from "../../core/components/CourseCard";
import { AuthContext } from "../../core/AuthContext";
import { getUserCourses } from "../../services/firebase/userCourseService";
import "./CourseList.css"; // We reuse the CourseList styles

export default function MyCourses() {
  const { user, authLoading } = useContext(AuthContext);
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchCourses = async () => {
      if (!user) return;
      try {
        const myCourses = await getUserCourses(user.uid);
        setCourses(myCourses);
      } catch (error) {
        console.error("Error loading my courses:", error);
      } finally {
        setLoading(false);
      }
    };

    if (!authLoading) {
      if (!user) {
        setLoading(false);
      } else {
        fetchCourses();
      }
    }
  }, [user, authLoading]);

  // Helper to format course data for CourseCard
  const mapCourseToCard = (course) => ({
    courseData: {
      id: course.id,
      title: course.title,
      teacher: course.teacher || "Instructeur 9arini",
      price: course.type === "payant" ? `${course.price} DT` : "Gratuit",
      level: course.level || "Tous niveaux",
      rating: course.rating || 5,
      ratingCount: course.ratingCount || 0,
      badge: "Inscrit",
      badgeColor: "blue", // Special badge for my courses
      image: course.image || "/assets/images/course-dev.jpg",
      teacherAvatar: course.teacherAvatar || "/assets/images/teacher1.jpg",
      description: course.description,
      type: course.type,
    },
    actionLabel: "Accéder",
    actionStyle: "btn-primary",
    onActionClick: () => navigate(`/courses/${course.id}`),
  });

  if (authLoading || loading) {
    return (
      <div className="courses-page">
        <Header />
        <main className="courses-main">
          <p>Chargement de vos cours...</p>
        </main>
        <Footer />
      </div>
    );
  }

  if (!user) {
    return (
      <div className="courses-page">
        <Header />
        <main className="courses-main">
          <p>Veuillez vous connecter pour voir vos cours.</p>
          <button 
            className="btn-primary" 
            style={{ marginTop: '20px' }}
            onClick={() => navigate('/auth/login')}
          >
            Se connecter
          </button>
        </main>
        <Footer />
      </div>
    );
  }

  return (
    <div className="courses-page">
      <Header />
      <main className="courses-main">
        <header className="courses-header">
          <h1>Mes Cours</h1>
          <p>Retrouvez ici tous les cours auxquels vous êtes inscrit.</p>
        </header>

        {courses.length === 0 ? (
          <div style={{ textAlign: "center", marginTop: "40px" }}>
            <p>Vous n'êtes inscrit à aucun cours pour le moment.</p>
            <button 
              className="btn-secondary"
              style={{ marginTop: "20px" }}
              onClick={() => navigate("/courses")}
            >
              Parcourir le catalogue
            </button>
          </div>
        ) : (
          <div className="courses-grid">
            {courses.map((course) => {
              const { courseData, actionLabel, actionStyle, onActionClick } = mapCourseToCard(course);
              return (
                <CourseCard
                  key={course.id}
                  course={courseData}
                  actionLabel={actionLabel}
                  actionStyle={actionStyle}
                  onClick={onActionClick}
                />
              );
            })}
          </div>
        )}
      </main>
      <Footer />
    </div>
  );
}
