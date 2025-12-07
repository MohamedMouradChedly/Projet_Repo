import React, { useEffect, useState } from "react";
import Header from "../../core/components/Header";
import Footer from "../../core/components/Footer";
import "./ManageUsers.css"; // Ensure this file exists with the code I gave you previously
import { getAllUsers, deleteUserProfile } from "../../services/firebase/userService";

export default function ManageUsers() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    const load = async () => {
      setLoading(true);
      setError("");
      try {
        const data = await getAllUsers();
        setUsers(data);
      } catch (err) {
        console.error(err);
        setError("Erreur lors du chargement des utilisateurs.");
      } finally {
        setLoading(false);
      }
    };
    load();
  }, []);

  const handleDelete = async (id, email) => {
    if (!window.confirm(`Supprimer l'utilisateur ${email} ?`)) return;
    try {
      await deleteUserProfile(id);
      setUsers((prev) => prev.filter((u) => u.id !== id));
    } catch (err) {
      console.error(err);
      alert("Erreur lors de la suppression.");
    }
  };

  return (
    <div className="users-page"> {/* UPDATED CLASS */}
      <Header />
      <main className="users-main"> {/* UPDATED CLASS */}
        <h1 className="users-title">Gestion des utilisateurs</h1>
        <p className="users-subtitle">
          Liste des comptes créés sur la plateforme.
        </p>

        <section className="users-section">
          <h2>Utilisateurs ({users.length})</h2>

          {loading && <p>Chargement...</p>}
          {error && <p style={{color: 'red'}}>{error}</p>}

          {!loading && users.length === 0 && !error && (
            <p>Aucun utilisateur pour le moment.</p>
          )}

          {!loading && users.length > 0 && (
            <div className="users-grid"> {/* UPDATED CLASS: Grid Layout */}
              {users.map((user) => (
                <div key={user.id} className="user-card"> {/* UPDATED CLASS: Card */}
                  <h3 className="user-name">
                    {user.firstName} {user.lastName}
                  </h3>
                  <p className="user-email">{user.email}</p>
                  
                  {user.phone && <p className="user-info-row">Téléphone : {user.phone}</p>}
                  
                  <span className="user-role">
                    Rôle : {user.role === "admin" ? "Admin" : "Utilisateur"}
                  </span>
                  
                  <button
                    className="btn-delete-user"
                    onClick={() => handleDelete(user.id, user.email)}
                    disabled={user.role === "admin"}
                    style={{ opacity: user.role === "admin" ? 0.5 : 1 }}
                  >
                    Supprimer
                  </button>
                </div>
              ))}
            </div>
          )}
        </section>
      </main>
      <Footer />
    </div>
  );
}
