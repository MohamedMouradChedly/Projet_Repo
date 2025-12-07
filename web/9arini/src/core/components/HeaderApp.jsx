import React, { useContext, useState } from "react";
import { Link, NavLink } from "react-router-dom";
import "./HeaderApp.css";
import logo from "../../assets/images/logo-9arini.png";
import { AuthContext } from "../AuthContext";
import { signOut } from "firebase/auth";
import { auth } from "../../services/firebase/firebaseConfig";

export default function HeaderApp() {
  const { user } = useContext(AuthContext);
  const [open, setOpen] = useState(false);

  const displayName = user?.displayName || user?.email || "Mon profil";

  const handleLogout = async () => {
    await signOut(auth);
    window.location.href = "/"; // back to public homepage
  };

  return (
    <header className="site-header">
      <div className="header-inner">
        <Link to="/app/home" className="header-logo">
          <img src={logo} alt="9arini" />
        </Link>

        <nav className="header-nav">
          <NavLink to="/app/home" className="nav-link">
            Accueil
          </NavLink>
          <NavLink to="/courses" className="nav-link">
            Parcourir Cours
          </NavLink>
          <NavLink to="/offers" className="nav-link">
            Offres
          </NavLink>
          <NavLink to="/about" className="nav-link">
            À propos
          </NavLink>
          <NavLink to="/app/my-courses" className="nav-link">
            Mes cours
          </NavLink>

        </nav>

        <div className="header-profile">
          <button
            className="profile-avatar"
            onClick={() => setOpen((prev) => !prev)}
          >
            {displayName.charAt(0).toUpperCase()}
          </button>
          {open && (
            <div className="profile-dropdown">
              <div className="profile-info">
                <div className="profile-name">{displayName}</div>
                <div className="profile-email">{user?.email}</div>
              </div>
              <Link to="/profile" className="profile-link">
                Voir mon profil
              </Link>
              <button className="profile-link logout" onClick={handleLogout}>
                Se déconnecter
              </button>
            </div>
          )}
        </div>
      </div>
    </header>
  );
}
