// src/views/Home/AppHome.jsx
import React, { useContext, useEffect, useMemo, useState } from "react";
import "./Home.css";
import HeaderApp from "../../core/components/HeaderApp";
import Footer from "../../core/components/Footer";
import CourseCard from "../../core/components/CourseCard";
import StatsBanner from "../../core/components/StatsBanner";
import TestimonialCard from "../../core/components/TestimonialCard";
import { getAllCourses } from "../../services/firebase/courseService";
import { getUserCourses } from "../../services/firebase/userCourseService";
import { AuthContext } from "../../core/AuthContext";

export default function AppHome() {
  const { user } = useContext(AuthContext);
  const [courses, setCourses] = useState([]);
  const [userCourseLinks, setUserCourseLinks] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const load = async () => {
      if (!user) return;
      setLoading(true);
      try {
        const [allCourses, userCourses] = await Promise.all([
          getAllCourses(),
          getUserCourses(user.uid),
        ]);
        setCourses(allCourses);
        setUserCourseLinks(userCourses);
      } catch (e) {
        console.error(e);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, [user]);

  // IDs des cours de l'utilisateur
  const userCourseIds = useMemo(
    () => new Set(userCourseLinks.map((uc) => uc.courseId)),
    [userCourseLinks]
  );

  const myCourses = courses.filter((c) => userCourseIds.has(c.id));
  const payantCourses = courses.filter(
    (c) => c.type === "payant" && !userCourseIds.has(c.id)
  );
  const gratuitCourses = courses.filter(
    (c) => c.type !== "payant" && !userCourseIds.has(c.id)
  );

  const mapCourseToCard = (course) => ({
    id: course.id,
    title: course.title,
    teacher: course.teacher || "Instructeur 9arini",
    price:
      course.type === "payant"
        ? `${course.price} DT`
        : course.price || "Gratuit",
    oldPrice: "",
    duration: course.duration || "",
    level: course.level || "Tous niveaux",
    rating: course.rating || 5,
    ratingCount: course.ratingCount || 0,
    badge: course.type === "payant" ? "Payant" : "Gratuit",
    badgeColor: course.type === "payant" ? "orange" : "green",
    isFree: course.type !== "payant",
    image: course.image || "/assets/images/course-dev.jpg",
    teacherAvatar:
      course.teacherAvatar || "/assets/images/teacher1.jpg",
    description: course.description,
  });

  return (
    <div className="home-page">
      <HeaderApp />

      {/* HERO */}
      <section className="hero">
        <div className="hero-overlay" />
        <img
          className="hero-bg"
          src="/assets/images/hero-bg.jpg"
          alt="Étudiants en formation"
        />
        <div className="hero-content">
          <h1>
            Bon retour,
            <br />
            {user?.displayName || user?.email}
          </h1>
          <p>
            Continuez votre apprentissage avec vos cours et découvrez
            de nouvelles formations adaptées au marché tunisien.
          </p>
          <div className="hero-actions">
            <button className="btn-primary">Mes cours</button>
            <button className="btn-secondary">
              Parcourir de nouveaux cours
            </button>
          </div>
        </div>
      </section>

      <StatsBanner />

      <main className="section">
        {loading && <p>Chargement de vos cours...</p>}

        {!loading && (
          <>
            {/* MES COURS */}
            <section className="section">
              <div className="section-header">
                <h2>Mes cours</h2>
                <p>
                  Les cours auxquels vous êtes inscrit, gratuits ou payants.
                </p>
              </div>
              {myCourses.length === 0 ? (
                <p>Vous n'êtes inscrit à aucun cours pour le moment.</p>
              ) : (
                <div className="course-grid">
                  {myCourses.map((course) => (
                    <CourseCard
                      key={course.id}
                      course={mapCourseToCard(course)}
                    />
                  ))}
                </div>
              )}
            </section>

            {/* COURS PAYANTS DISPONIBLES */}
            <section className="section">
              <div className="section-header">
                <h2>Cours payants disponibles</h2>
                <p>
                  Formations complètes pour aller plus loin dans votre carrière.
                </p>
              </div>
              {payantCourses.length === 0 ? (
                <p>Vous avez déjà tous les cours payants disponibles.</p>
              ) : (
                <div className="course-grid">
                  {payantCourses.map((course) => (
                    <CourseCard
                      key={course.id}
                      course={mapCourseToCard(course)}
                    />
                  ))}
                </div>
              )}
            </section>

            {/* COURS GRATUITS DISPONIBLES */}
            <section className="section section-alt">
              <div className="section-header">
                <h2>Cours gratuits à découvrir</h2>
                <p>
                  Complétez vos connaissances avec notre sélection de cours
                  gratuits.
                </p>
              </div>
              {gratuitCourses.length === 0 ? (
                <p>Vous avez déjà tous les cours gratuits disponibles.</p>
              ) : (
                <div className="course-grid">
                  {gratuitCourses.map((course) => (
                    <CourseCard
                      key={course.id}
                      course={mapCourseToCard(course)}
                    />
                  ))}
                </div>
              )}
            </section>

            {/* Témoignages pour garder la même ambiance que la home publique */}
            <section className="section">
              <div className="section-header">
                <h2>Ce que disent nos étudiants</h2>
              </div>
              <div className="testimonial-grid">
                {/* Vous pouvez réutiliser vos testimonials mock ici */}
                {/* Exemple simple: */}
                <TestimonialCard
                  testimonial={{
                    id: 1,
                    name: "Amira Sassi",
                    role: "Étudiante en marketing",
                    avatar: "/assets/images/student1.jpg",
                    rating: 5,
                    text:
                      "Les cours de 9arini m'ont permis de développer mes compétences et de trouver un stage.",
                  }}
                />
              </div>
            </section>
          </>
        )}
      </main>

      <Footer />
    </div>
  );
}
