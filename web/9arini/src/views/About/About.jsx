import React from "react";
import "./About.css";
import Header from "../../core/components/Header";
import Footer from "../../core/components/Footer";

export default function About() {
  const team = [
    {
      id: 1,
      name: "Ahmed Ben Salah",
      role: "Fondateur & CEO",
      description:
        "Expert en technologie éducative avec plus de 15 ans d'expérience dans le secteur de l'éducation en Tunisie.",
      
    },
    {
      id: 2,
      name: "Fatma Trabelsi",
      role: "Directrice Pédagogique",
      description:
        "Spécialiste en ingénierie pédagogique, elle supervise la qualité de tous nos contenus éducatifs.",
     
    },
    {
      id: 3,
      name: "Karim Mansouri",
      role: "Directeur Technique",
      description:
        "Ingénieur logiciel passionné, il développe les solutions techniques innovantes de notre plateforme.",
    },
    {
      id: 4,
      name: "Salma Khelifi",
      role: "Responsable Marketing",
      description:
        "Experte en marketing digital, elle développe nos stratégies de communication et de croissance.",
    },
  ];

  const values = [
    {
      id: 1,
      title: "Innovation",
      text:
        "Nous utilisons les dernières technologies pour créer des expériences d'apprentissage uniques et engageantes.",
      icon: "💡",
    },
    {
      id: 2,
      title: "Passion",
      text:
        "Notre équipe est passionnée par l'éducation et s'engage à offrir la meilleure expérience possible.",
      icon: "💙",
    },
    {
      id: 3,
      title: "Communauté",
      text:
        "Nous croyons en la force de la communauté pour créer un environnement d'apprentissage bienveillant.",
      icon: "🤝",
    },
    {
      id: 4,
      title: "Excellence",
      text:
        "Nous nous efforçons d'atteindre l'excellence dans tout ce que nous faisons, du contenu au support client.",
      icon: "⭐",
    },
  ];

  const timeline = [
    {
      year: "2020",
      title: "Création de 9arini",
      text: "Lancement de la plateforme avec 10 cours et 3 instructeurs.",
    },
    {
      year: "2021",
      title: "Expansion du catalogue",
      text:
        "Ajout de 50+ cours et partenariats avec des experts tunisiens.",
    },
    {
      year: "2022",
      title: "Reconnaissance nationale",
      text: "Prix de la meilleure plateforme éducative tunisienne.",
    },
    {
      year: "2023",
      title: "Innovation technologique",
      text:
        "Lancement des fonctionnalités IA et apprentissage adaptatif.",
    },
    {
      year: "2024",
      title: "Expansion régionale",
      text:
        "Ouverture vers les marchés maghrébins et africains.",
    },
  ];

  return (
    <div className="about-page">
      <Header />

      {/* HERO */}
      <section className="about-hero">
        <div className="about-hero-overlay" />
        <img
          src="/src/assets/images/about-hero.jpg"
          alt="Campus"
          className="about-hero-bg"
        />
        <div className="about-hero-content">
          <h1>À propos de 9arini</h1>
          <p>
            Nous démocratisons l'accès à l'éducation de qualité en Tunisie
            grâce à une plateforme innovante qui connecte les apprenants
            avec les meilleurs instructeurs du pays.
          </p>
        </div>
      </section>

      {/* MISSION */}
      <section className="about-section about-mission">
        <div className="about-mission-text">
          <h2>Notre mission</h2>
          <p>
            Chez 9arini, nous croyons que chaque Tunisien mérite d'avoir accès
            à une éducation de qualité, peu importe sa localisation
            géographique ou sa situation économique.
          </p>
          <p>
            Notre plateforme connecte les apprenants avec des instructeurs
            experts tunisiens, offrant des cours pratiques et adaptés au
            marché local du travail.
          </p>
          <button className="btn-primary">Rejoindre la communauté</button>
        </div>
        <div className="about-mission-image-wrapper">
          
        </div>
      </section>

      {/* VALUES */}
      <section className="about-section about-values">
        <div className="about-section-header">
          <h2>Nos valeurs</h2>
          <p>
            Les principes qui guident notre action quotidienne et notre vision
            de l'éducation.
          </p>
        </div>
        <div className="values-grid">
          {values.map((v) => (
            <div key={v.id} className="value-card">
              <div className="value-icon">{v.icon}</div>
              <h3>{v.title}</h3>
              <p>{v.text}</p>
            </div>
          ))}
        </div>
      </section>

      {/* TEAM */}
      <section className="about-section about-team">
        <div className="about-section-header">
          <h2>Notre équipe</h2>
          <p>
            Des professionnels passionnés qui travaillent chaque jour pour
            améliorer l'éducation en Tunisie.
          </p>
        </div>
        <div className="team-grid">
          {team.map((m) => (
            <div key={m.id} className="team-card">
              <img src={m.avatar} alt={m.name} className="team-avatar" />
              <h3>{m.name}</h3>
              <p className="team-role">{m.role}</p>
              <p className="team-text">{m.description}</p>
            </div>
          ))}
        </div>
      </section>

      {/* TIMELINE */}
      <section className="about-section about-timeline">
        <div className="about-section-header">
          <h2>Notre parcours</h2>
          <p>L'évolution de 9arini depuis sa création.</p>
        </div>
        <div className="timeline">
          <div className="timeline-line" />
          <div className="timeline-items">
            {timeline.map((item, index) => (
              <div
                key={item.year}
                className={`timeline-card timeline-card-${
                  index % 2 === 0 ? "left" : "right"
                }`}
              >
                <div className="timeline-year">{item.year}</div>
                <h3>{item.title}</h3>
                <p>{item.text}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CONTACT */}
      <section className="about-section about-contact">
        <div className="about-section-header">
          <h2>Contactez-nous</h2>
          <p>
            Une question ? Une suggestion ? Notre équipe est là pour vous aider.
          </p>
        </div>
        <div className="contact-grid">
          <div className="contact-card">
            <div className="contact-icon">✉️</div>
            <h3>Email</h3>
            <p>contact@9arini.tn</p>
          </div>
          <div className="contact-card">
            <div className="contact-icon">📞</div>
            <h3>Téléphone</h3>
            <p>+216 70 123 456</p>
          </div>
          <div className="contact-card">
            <div className="contact-icon">📍</div>
            <h3>Adresse</h3>
            <p>Tunis, Tunisie</p>
          </div>
        </div>
        <div className="about-contact-cta">
          <button className="btn-primary">Nous contacter</button>
        </div>
      </section>

      <Footer />
    </div>
  );
}
