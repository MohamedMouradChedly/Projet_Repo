// src/views/Admin/AdminDashboard.jsx
import React from "react";
import { Link } from "react-router-dom";
import "./AdminDashboard.css"; 

export default function AdminDashboard() {
  return (
    <div className="admin-home-page">
      <main className="admin-home-main">
        <h1 className="admin-home-title">Espace admin</h1>
        <p className="admin-home-subtitle">
          Connecté avec le compte administrateur.
        </p>

        <div className="admin-menu-grid">
          
          <Link to="/admin/users" className="admin-menu-card">
            <div className="menu-icon">👤</div>
            <div className="menu-title">Utilisateurs</div>
            <div className="menu-desc">Gérer les comptes et les rôles.</div>
          </Link>

          <Link to="/admin/courses" className="admin-menu-card">
            <div className="menu-icon">📚</div>
            <div className="menu-title">Gestion de cours</div>
            <div className="menu-desc">Créer et modifier des cours.</div>
          </Link>

          {/* FIXED: Correct Path and Syntax */}
          <Link to="/admin/stats" className="admin-menu-card">
             <div className="menu-icon">📊</div>
             <div className="menu-title">Statistiques</div>
             <div className="menu-desc">Vue d'ensemble de l'activité.</div>
          </Link>

        </div>
      </main>
    </div>
  );
}
