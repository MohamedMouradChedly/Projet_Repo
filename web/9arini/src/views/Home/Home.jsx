import React, { useEffect, useState } from "react";
import "./Home.css";
import Header from "../../core/components/Header";
import Footer from "../../core/components/Footer"; 
import CourseCard from "../../core/components/CourseCard";
import StatsBanner from "../../core/components/StatsBanner";
import TestimonialCard from "../../core/components/TestimonialCard";
import { getAllCourses } from "../../services/firebase/courseService";

// mock data – replace with real data later
const popularCourses = [
  {
    id: 1,
    title: "Développement Web Complet",
    teacher: "Ahmed Ben Ali",
    price: "299 DT",
    oldPrice: "399 DT",
    duration: "12 semaines",
    level: "Débutant",
    rating: 4.7,
    ratingCount: 1250,
    badge: "Populaire",
    badgeColor: "orange",
    isFree: false,
  },
  {
    id: 2,
    title: "Design Graphique Professionnel",
    teacher: "Karim Mansouri",
    price: "249 DT",
    oldPrice: "349 DT",
    duration: "10 semaines",
    level: "Débutant",
    rating: 4.6,
    ratingCount: 675,
    badge: "Populaire",
    badgeColor: "orange",
    isFree: false,
  },
  {
    id: 3,
    title: "Comptabilité et Finance",
    teacher: "Mohamed Gharbi",
    price: "Gratuit",
    oldPrice: "",
    duration: "10 semaines",
    level: "Débutant",
    rating: 4.5,
    ratingCount: 789,
    badge: "Gratuit",
    badgeColor: "green",
    isFree: true,
  },
];

const freeCourses = [
  {
    id: 4,
    title: "Introduction au Marketing Digital",
    teacher: "Nesrine Trabelsi",
    price: "Gratuit",
    oldPrice: "",
    duration: "6 semaines",
    level: "Débutant",
    rating: 4.5,
    ratingCount: 520,
    badge: "Gratuit",
    badgeColor: "green",
    isFree: true,
  },
  {
    id: 5,
    title: "Bases de la Programmation",
    teacher: "Oussama K.",
    price: "Gratuit",
    oldPrice: "",
    duration: "8 semaines",
    level: "Débutant",
    rating: 4.4,
    ratingCount: 410,
    badge: "Gratuit",
    badgeColor: "green",
    isFree: true,
  },
];

const testimonials = [
  {
    id: 1,
    name: "Amira Sassi",
    role: "Étudiante en marketing",
    rating: 5,
    text:
      "Les cours de 9arini m'ont permis de développer mes compétences en marketing digital. Les instructeurs sont excellents et le contenu est très pratique.",
  },
  {
    id: 2,
    name: "Youssef Mejri",
    role: "Développeur web",
    rating: 5,
    text:
      "Grâce aux cours de développement web, j'ai pu créer mon propre site e-commerce. La qualité de l'enseignement est remarquable.",
  },
  {
    id: 3,
    name: "Salma Khelifi",
    role: "Entrepreneuse",
    rating: 5,
    text:
      "Le cours d'entrepreneuriat m'a donné tous les outils nécessaires pour lancer ma startup. Je recommande vivement 9arini !",
  },
];

export default function Home() {
  return (
    <div className="home-page">
      <Header />

      {/* HERO */}
      <section className="hero">
        <div className="hero-overlay" />
        <img
          className="hero-bg"
          alt="Étudiants en formation"
        />
        <div className="hero-content">
          <h1>
            Apprenez avec les
            <br />
            meilleurs instructeurs
            <br />
            tunisiens
          </h1>
          <p>
            Développez vos compétences avec des cours de qualité, adaptés au
            marché tunisien et dispensés par des experts locaux.
          </p>
          <div className="hero-actions">
            <button className="btn-primary">Parcourir les cours</button>
            <button className="btn-secondary">Voir les offres</button>
          </div>
        </div>
      </section>

      {/* STATS */}
      <StatsBanner />

      {/* POPULAR COURSES */}
      <section className="section">
        <div className="section-header">
          <h2>Cours les plus populaires</h2>
          <p>
            Découvrez les formations les plus appréciées par notre communauté
            d'apprenants.
          </p>
        </div>
        <div className="course-grid">
          {popularCourses.map((course) => (
            <CourseCard key={course.id} course={course} />
          ))}
        </div>
        <div className="section-cta">
          <button className="btn-primary">Voir tous les cours</button>
        </div>
      </section>

      {/* FREE COURSES */}
      <section className="section section-alt">
        <div className="section-header">
          <h2>Cours gratuits pour commencer</h2>
          <p>
            Découvrez notre sélection de cours gratuits pour débuter votre
            apprentissage.
          </p>
        </div>
        <div className="course-grid">
          {freeCourses.map((course) => (
            <CourseCard key={course.id} course={course} />
          ))}
        </div>
      </section>

      {/* TESTIMONIALS */}
      <section className="section">
        <div className="section-header">
          <h2>Ce que disent nos étudiants</h2>
        </div>
        <div className="testimonial-grid">
          {testimonials.map((t) => (
            <TestimonialCard key={t.id} testimonial={t} />
          ))}
        </div>
      </section>

      {/* CTA BANNER */}
      <section className="cta-banner">
        <div className="cta-inner">
          <h2>Prêt à commencer votre apprentissage ?</h2>
          <p>
            Rejoignez des milliers d'étudiants tunisiens qui développent leurs
            compétences avec 9arini.
          </p>
          <div className="cta-actions">
            <button className="btn-primary">Créer un compte gratuit</button>
            <button className="btn-secondary-light">
              Explorer les cours
            </button>
          </div>
        </div>
      </section>

      <Footer />
    </div>
  );
}
