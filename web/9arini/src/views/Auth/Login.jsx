import "./Login.css";
import React, { useState } from "react";
import { useAuth } from "../../viewmodels/useAuth";
import Input from "../../core/components/Input";
// Assuming Button component accepts className and onClick
import Button from "../../core/components/Button"; 
import Loader from "../../core/components/Loader";

export default function Login() {
  const { loading, error, login } = useAuth(); 
  const [form, setForm] = useState({
    email: "",
    password: "",
    rememberMe: false
  });

  const handleChange = e => {
    const { name, value, type, checked } = e.target;
    setForm({ ...form, [name]: type === "checkbox" ? checked : value });
  };

  const handleSubmit = async e => {
    e.preventDefault();
    await login(form.email, form.password);
  };

  return (
    <div className="login-page">
      <div className="login-split">
        {/* Left Side: Info */}
        <div className="login-info">
          <h1>Bienvenue sur 9arini</h1>
          <p>Rejoignez des milliers d'étudiants tunisiens qui développent leurs compétences avec nos cours de qualité.</p>
          <ul>
            <li>✔ Accès à plus de 150 cours</li>
            <li>✔ Instructeurs experts tunisiens</li>
            <li>✔ Certificats reconnus</li>
            <li>✔ Apprentissage à votre rythme</li>
          </ul>
        </div>

        {/* Right Side: Form */}
        <div className="login-form-container">
          <h2>Connexion</h2>
          <p className="login-subtitle">Connectez-vous à votre compte pour continuer votre apprentissage</p>
          
          <form onSubmit={handleSubmit}>
            <Input 
              name="email" 
              label="Adresse email" 
              type="email" 
              required 
              value={form.email} 
              onChange={handleChange} 
            />
            <Input 
              name="password" 
              label="Mot de passe" 
              type="password" 
              required 
              value={form.password} 
              onChange={handleChange} 
            />
            
            <div className="login-options">
              <div className="checkbox-group">
                <input 
                  type="checkbox" 
                  id="rememberMe" 
                  name="rememberMe" 
                  checked={form.rememberMe} 
                  onChange={handleChange} 
                />
                <label htmlFor="rememberMe">Se souvenir de moi</label>
              </div>
              <a href="/auth/forgot" className="forgot-link">Mot de passe oublié ?</a>
            </div>

            {/* Styled Primary Button */}
            <button type="submit" className="btn-login-submit" disabled={loading}>
              {loading ? <Loader /> : "Se connecter"}
            </button>
            
            {error && <p className="error-msg">{error}</p>}
          </form>

          <p className="login-bottom-text">
            Pas encore de compte ? <a href="/auth/register">Créer un compte</a>
          </p>

          <div className="login-social">
            <div className="separator">
              <hr />
              <span>Ou continuer avec</span>
              <hr />
            </div>
            <div className="social-buttons">
              <button type="button" className="btn-social google">Google</button>
              <button type="button" className="btn-social facebook">Facebook</button>
            </div>
          </div>

          <a href="/" className="back-link">← Retour à l'accueil</a>
        </div>
      </div>
    </div>
  );
}
