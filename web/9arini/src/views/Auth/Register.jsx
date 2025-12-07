// /views/Auth/Register.jsx
import "./Register.css";
import React, { useState } from "react";
import Header from "../../core/components/Header";
import Footer from "../../core/components/Footer";
import { useAuth } from "../../viewmodels/useAuth";
import Input from "../../core/components/Input";
import Button from "../../core/components/Button";
import Loader from "../../core/components/Loader";

export default function Register() {
  const { loading, error, register } = useAuth();
  const [form, setForm] = useState({
    firstName: "",
    lastName: "",
    email: "",
    phone: "",
    password: "",
    confirmPassword: "",
  });

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (form.password !== form.confirmPassword) {
      alert("Passwords do not match.");
      return;
    }
    await register(form);
  };

  return (
    <div className="register-page-wrapper">
      <Header />

      <div className="register-page">
        <h2>Créer un compte</h2>
        <form onSubmit={handleSubmit}>
          <Input
            name="firstName"
            label="Prénom"
            required
            value={form.firstName}
            onChange={handleChange}
          />
          <Input
            name="lastName"
            label="Nom"
            required
            value={form.lastName}
            onChange={handleChange}
          />
          <Input
            name="email"
            label="Email"
            type="email"
            required
            value={form.email}
            onChange={handleChange}
          />
          <Input
            name="phone"
            label="Téléphone"
            value={form.phone}
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
          <Input
            name="confirmPassword"
            label="Confirmer le mot de passe"
            type="password"
            required
            value={form.confirmPassword}
            onChange={handleChange}
          />
          <Button type="submit" disabled={loading}>
            {loading ? <Loader /> : "Créer mon compte"}
          </Button>
          {error && <p className="error">{error}</p>}
        </form>
        <p>
          Vous avez déjà un compte ? <a href="/auth/login">Se connecter</a>
        </p>
      </div>

      <Footer />
    </div>
  );
}
