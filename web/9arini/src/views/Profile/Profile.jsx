import React, { useContext, useEffect, useState } from "react";
import "./Profile.css";  
import "../Courses/CourseList.css";
import Header from "../../core/components/Header";
import Footer from "../../core/components/Footer";
import { AuthContext } from "../../core/AuthContext";
import {
  getUserProfile,
  updateUserProfile,
} from "../../services/firebase/userProfileService";
import { getUserCourses } from "../../services/firebase/userCourseService";
import { auth } from "../../services/firebase/firebaseConfig";
import {
  updateProfile,
  updatePassword,
  reauthenticateWithCredential,
  EmailAuthProvider,
} from "firebase/auth";

export default function Profile() {
  const { user } = useContext(AuthContext);
  const [profile, setProfile] = useState(null);
  const [enrolledCount, setEnrolledCount] = useState(0);

  const [editForm, setEditForm] = useState({
    firstName: "",
    lastName: "",
    phone: "",
  });
  const [savingProfile, setSavingProfile] = useState(false);

  const [pwdForm, setPwdForm] = useState({
    currentPassword: "",
    newPassword: "",
  });
  const [changingPwd, setChangingPwd] = useState(false);

  const [message, setMessage] = useState("");
  const [error, setError] = useState("");

  // Load profile + enrolled courses
  useEffect(() => {
    const load = async () => {
      if (!user) return;
      try {
        const [p, userCourses] = await Promise.all([
          getUserProfile(user.uid),
          getUserCourses(user.uid),
        ]);
        setProfile(p);
        setEnrolledCount(userCourses.length);
        if (p) {
          setEditForm({
            firstName: p.firstName || "",
            lastName: p.lastName || "",
            phone: p.phone || "",
          });
        }
      } catch (e) {
        console.error(e);
        setError("Erreur lors du chargement du profil.");
      }
    };
    load();
  }, [user]);

  if (!user) {
    return (
      <div className="courses-page">
        <Header />
        <main className="courses-main">
          <p>Veuillez vous connecter pour voir votre profil.</p>
        </main>
        <Footer />
      </div>
    );
  }

  const displayName = user.displayName || "";
  const email = user.email || "";
  const initial = (displayName || email).charAt(0).toUpperCase();

  const handleEditChange = (e) => {
    const { name, value } = e.target;
    setEditForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleSaveProfile = async (e) => {
    e.preventDefault();
    if (!user) return;
    setSavingProfile(true);
    setMessage("");
    setError("");
    try {
      // Update Firestore
      await updateUserProfile(user.uid, {
        firstName: editForm.firstName,
        lastName: editForm.lastName,
        phone: editForm.phone,
      });

      // Update Firebase Auth displayName
      const newDisplay = `${editForm.firstName} ${editForm.lastName}`.trim();
      if (newDisplay) {
        await updateProfile(auth.currentUser, {
          displayName: newDisplay,
        });
      }

      setProfile((prev) =>
        prev
          ? { ...prev, ...editForm }
          : { ...editForm, email, uid: user.uid }
      );
      setMessage("Profil mis à jour avec succès.");
    } catch (e) {
      console.error(e);
      setError("Erreur lors de la mise à jour du profil.");
    } finally {
      setSavingProfile(false);
    }
  };

  const handlePwdChangeInput = (e) => {
    const { name, value } = e.target;
    setPwdForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleChangePassword = async (e) => {
    e.preventDefault();
    if (!user) return;
    setChangingPwd(true);
    setMessage("");
    setError("");
    try {
      const cred = EmailAuthProvider.credential(
        user.email,
        pwdForm.currentPassword
      );
      await reauthenticateWithCredential(auth.currentUser, cred);
      await updatePassword(auth.currentUser, pwdForm.newPassword);
      setMessage("Mot de passe mis à jour avec succès.");
      setPwdForm({ currentPassword: "", newPassword: "" });
    } catch (e) {
      console.error(e);
      setError(
        "Erreur lors du changement de mot de passe. Vérifiez votre mot de passe actuel."
      );
    } finally {
      setChangingPwd(false);
    }
  };

  return (
    <div className="courses-page">
      <Header />
      <main className="courses-main">
        <header className="profile-header">
          <div className="profile-avatar-big">{initial}</div>
          <h1>Profil</h1>
        </header>

        {message && <p className="profile-message">{message}</p>}
        {error && <p className="profile-error">{error}</p>}

        <section className="profile-card">
          <div className="profile-main-info">
            <div className="profile-circle">{initial}</div>
            <div>
              <div className="profile-name">
                {profile
                  ? `${profile.firstName || ""} ${profile.lastName || ""}`.trim()
                  : displayName}
              </div>
              <div className="profile-email">{email}</div>
              <div className="profile-meta">
                Cours suivis : {enrolledCount}
              </div>
            </div>
          </div>

          {/* Edit profile form */}
          <form className="profile-form" onSubmit={handleSaveProfile}>
            <label>
              Prénom
              <input
                name="firstName"
                value={editForm.firstName}
                onChange={handleEditChange}
              />
            </label>
            <label>
              Nom
              <input
                name="lastName"
                value={editForm.lastName}
                onChange={handleEditChange}
              />
            </label>
            <label>
              Téléphone
              <input
                name="phone"
                value={editForm.phone}
                onChange={handleEditChange}
              />
            </label>
            <button
              type="submit"
              className="profile-btn primary"
              disabled={savingProfile}
            >
              {savingProfile ? "Enregistrement..." : "Enregistrer le profil"}
            </button>
          </form>

          {/* Change password */}
          <form className="profile-form profile-form-secondary" onSubmit={handleChangePassword}>
            <label>
              Mot de passe actuel
              <input
                type="password"
                name="currentPassword"
                value={pwdForm.currentPassword}
                onChange={handlePwdChangeInput}
              />
            </label>
            <label>
              Nouveau mot de passe
              <input
                type="password"
                name="newPassword"
                value={pwdForm.newPassword}
                onChange={handlePwdChangeInput}
              />
            </label>
            <button
              type="submit"
              className="profile-btn"
              disabled={changingPwd}
            >
              {changingPwd ? "Changement..." : "Changer le mot de passe"}
            </button>
          </form>
        </section>
      </main>
      <Footer />
    </div>
  );
}
