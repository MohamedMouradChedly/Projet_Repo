import React from "react";
import "./StatsBanner.css";

export default function StatsBanner() {
  return (
    <section className="stats-banner">
      <div className="stats-inner">
        <div className="stat-item">
          <div className="stat-number">5000+</div>
          <div className="stat-label">Étudiants actifs</div>
        </div>
        <div className="stat-item">
          <div className="stat-number">150+</div>
          <div className="stat-label">Cours disponibles</div>
        </div>
        <div className="stat-item">
          <div className="stat-number">50+</div>
          <div className="stat-label">Instructeurs experts</div>
        </div>
        <div className="stat-item">
          <div className="stat-number">95%</div>
          <div className="stat-label">Taux de satisfaction</div>
        </div>
      </div>
    </section>
  );
}
