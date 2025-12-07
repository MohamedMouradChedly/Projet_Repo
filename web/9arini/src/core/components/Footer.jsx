import React from "react";
import "./Footer.css";
import logo from "../../assets/images/logo-9arini-white.png"; // adjust path/name

export default function Footer() {
  return (
    <footer className="site-footer">
      <div className="footer-top">
        <div className="footer-brand">
          <img src={logo} alt="9arini" />
          <p>
            La plateforme éducative tunisienne qui vous accompagne dans votre
            apprentissage avec des cours de qualité et des instructeurs experts.
          </p>
          <div className="footer-social">
            <a href="#facebook" aria-label="Facebook">
              f
            </a>
            <a href="#twitter" aria-label="Twitter">
              t
            </a>
            <a href="#instagram" aria-label="Instagram">
              i
            </a>
            <a href="#linkedin" aria-label="LinkedIn">
              in
            </a>
          </div>
        </div>

        <div className="footer-columns">
          <div>
            <h4>Liens rapides</h4>
            <a href="/">Accueil</a>
            <a href="/courses">Cours</a>
            <a href="/offers">Offres</a>
            <a href="/about">À propos</a>
          </div>
          <div>
            <h4>Support</h4>
            <a href="/help">Centre d'aide</a>
            <a href="/contact">Contact</a>
            <a href="/faq">FAQ</a>
            <a href="/terms">Conditions</a>
          </div>
        </div>
      </div>

      <div className="footer-bottom">
        <p>© {new Date().getFullYear()} 9arini. Tous droits réservés.</p>
      </div>
    </footer>
  );
}
