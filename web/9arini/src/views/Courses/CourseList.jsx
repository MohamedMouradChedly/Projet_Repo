import React, { useEffect, useState, useContext } from "react";
import { useNavigate } from "react-router-dom";
import "./CourseList.css";
import Header from "../../core/components/Header";
import Footer from "../../core/components/Footer";
import CourseCard from "../../core/components/CourseCard";
import { getAllCourses } from "../../services/firebase/courseService";
import { getUserCourses } from "../../services/firebase/userCourseService";
import { enrollUserInCourse } from "../../services/firebase/enrollmentService";
import { AuthContext } from "../../core/AuthContext";
import { CartContext } from "../../core/CartContext";

export default function CourseList() {
  const { user } = useContext(AuthContext);
  const { addToCart } = useContext(CartContext);
  const navigate = useNavigate();

  const [courses, setCourses] = useState([]);
  const [enrolledCourseIds, setEnrolledCourseIds] = useState(new Set());
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    const load = async () => {
      setLoading(true);
      try {
        const allCourses = await getAllCourses();
        setCourses(allCourses);

        if (user) {
          const userEnrollments = await getUserCourses(user.uid);
          const ids = new Set(userEnrollments.map((c) => c.courseId));
          setEnrolledCourseIds(ids);
        }
      } catch (err) {
        console.error("Erreur chargement des cours", err);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, [user]);

  const handleEnroll = async (courseId) => {
    if (!user) {
      navigate("/auth/login");
      return;
    }
    try {
      await enrollUserInCourse(user.uid, courseId);
      setEnrolledCourseIds((prev) => new Set(prev).add(courseId));
      alert("Inscription réussie ! Vous pouvez retrouver ce cours dans 'Mes cours'.");
    } catch (err) {
      console.error(err);
      alert("Erreur lors de l'inscription.");
    }
  };

  const mapCourseToCard = (course) => {
    const isEnrolled = enrolledCourseIds.has(course.id);
    const isFree = course.type !== "payant";

    let actionLabel = "";
    let actionStyle = "";
    let onActionClick = null;

    if (isEnrolled) {
      actionLabel = "Accéder";
      actionStyle = "btn-secondary";
      onActionClick = () => navigate(`/courses/${course.id}`);
    } else if (isFree) {
      actionLabel = "S'inscrire";
      actionStyle = "btn-primary";
      onActionClick = () => handleEnroll(course.id);
    } else {
      actionLabel = "Ajouter au panier";
      actionStyle = "btn-accent";
      onActionClick = () => {
        addToCart(course);
        alert("Ajouté au panier !");
      };
    }

    return {
      courseData: {
        id: course.id,
        title: course.title,
        teacher: course.teacher || "Instructeur 9arini",
        price: course.type === "payant" ? `${course.price} DT` : "Gratuit",
        oldPrice: "",
        duration: course.duration || "",
        level: course.level || "Tous niveaux",
        rating: course.rating || 5,
        ratingCount: course.ratingCount || 0,
        badge: course.type === "payant" ? "Payant" : "Gratuit",
        badgeColor: course.type === "payant" ? "orange" : "green",
        image: course.image || "/assets/images/course-dev.jpg",
        teacherAvatar: course.teacherAvatar || "/assets/images/teacher1.jpg",
        description: course.description,
        type: course.type,
      },
      actionLabel,
      actionStyle,
      onActionClick,
    };
  };

  const payantCourses = courses.filter((c) => c.type === "payant");
  const gratuitCourses = courses.filter((c) => c.type !== "payant");

  return (
    <div className="courses-page">
      <Header />
      <main className="courses-main">
        <header className="courses-header">
          <h1>Parcourir les cours</h1>
          <p>
            Découvrez tous les cours disponibles sur la plateforme, payants et
            gratuits.
          </p>
        </header>

        {loading && <p>Chargement des cours...</p>}

        {!loading && courses.length === 0 && (
          <p>Aucun cours n'est disponible pour le moment.</p>
        )}

        {!loading && courses.length > 0 && (
          <>
            <section className="courses-section">
              <div className="courses-section-header">
                <h2>Cours payants</h2>
                <p>Formations complètes pour aller plus loin.</p>
              </div>
              {payantCourses.length === 0 ? (
                <p>Aucun cours payant pour le moment.</p>
              ) : (
                <div className="courses-grid">
                  {payantCourses.map((c) => {
                    const { courseData, actionLabel, actionStyle, onActionClick } =
                      mapCourseToCard(c);
                    return (
                      <CourseCard
                        key={c.id}
                        course={courseData}
                        actionLabel={actionLabel}
                        actionStyle={actionStyle}
                        onClick={onActionClick}
                      />
                    );
                  })}
                </div>
              )}
            </section>

            <section className="courses-section courses-section-alt">
              <div className="courses-section-header">
                <h2>Cours gratuits</h2>
                <p>Commencez gratuitement votre apprentissage.</p>
              </div>
              {gratuitCourses.length === 0 ? (
                <p>Aucun cours gratuit pour le moment.</p>
              ) : (
                <div className="courses-grid">
                  {gratuitCourses.map((c) => {
                    const { courseData, actionLabel, actionStyle, onActionClick } =
                      mapCourseToCard(c);
                    return (
                      <CourseCard
                        key={c.id}
                        course={courseData}
                        actionLabel={actionLabel}
                        actionStyle={actionStyle}
                        onClick={onActionClick}
                      />
                    );
                  })}
                </div>
              )}
            </section>
          </>
        )}
      </main>
      <Footer />
    </div>
  );
}

/* ------------------------------------------------------------
   📌 ADD THIS TO CourseList.css to fix the alignment issue
------------------------------------------------------------ */

 /*
.courses-main,
.courses-header,
.courses-section {
  text-align: left !important;
  display: block !important;
  justify-content: flex-start !important;
  align-items: flex-start !important;
}

.courses-main {
  width: 100%;
}

.courses-header,
.courses-section {
  width: 100%;
  max-width: 1200px; 
  margin: 0 auto;
}
*/
