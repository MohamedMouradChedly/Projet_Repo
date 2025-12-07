import React, { useContext, useState } from "react";
import { Link, NavLink, useNavigate } from "react-router-dom";
import logo from "../../assets/images/logo-9arini.png";
import "./Header.css";
import { AuthContext } from "../AuthContext";
import { CartContext } from "../CartContext"; // Import CartContext
import { signOut } from "firebase/auth";
import { auth } from "../../services/firebase/firebaseConfig";

export default function Header() {
  const { user } = useContext(AuthContext);
  const { cart } = useContext(CartContext); // Access cart to show count
  const [open, setOpen] = useState(false);
  const navigate = useNavigate();

  const displayName = user?.displayName || user?.email || "";

  const handleLogout = async () => {
    await signOut(auth);
    navigate("/");
  };

  return (
    <header className="site-header">
      <div className="header-inner">
        <Link to="/" className="header-logo">
          <img src={logo} alt="9arini" />
        </Link>

        <nav className="header-nav">
          <NavLink to="/" className="nav-link">
            Accueil
          </NavLink>
          <NavLink to="/courses" className="nav-link">
            Parcourir Cours
          </NavLink>
          <NavLink to="/about" className="nav-link">
            À propos
          </NavLink>
          {user && (
            <NavLink to="/my-courses" className="nav-link">
              Mes cours
            </NavLink>
          )}
        </nav>

        <div className="header-right">
          {/* CART BUTTON */}
          <Link to="/cart" className="header-cart-btn">
            🛒 <span className="cart-count">{cart?.length || 0}</span>
          </Link>

          {!user && (
            <>
              <Link to="/auth/login" className="btn-outline">
                Connexion
              </Link>
              <Link to="/auth/register" className="btn-primary">
                S'inscrire
              </Link>
            </>
          )}

          {user && (
            <div className="header-profile">
              <button
                className="profile-avatar"
                onClick={() => setOpen((p) => !p)}
              >
                {displayName.charAt(0).toUpperCase()}
              </button>
              {open && (
                <div className="profile-dropdown">
                  <div className="profile-info">
                    <div className="profile-name">{displayName}</div>
                    <div className="profile-email">{user.email}</div>
                  </div>
                  <Link to="/profile" className="profile-link">
                    Voir le profil
                  </Link>
                  <button
                    className="profile-link logout"
                    onClick={handleLogout}
                  >
                    Se déconnecter
                  </button>
                </div>
              )}
            </div>
          )}
        </div>
      </div>
    </header>
  );
}
