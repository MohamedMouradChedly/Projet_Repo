import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import "./Admin.css";
import {
  createCourse,
  getAllCourses,
  deleteCourse,
} from "../../services/firebase/courseService";

export default function ManageCourses() {
  const [courses, setCourses] = useState([]);
  const [form, setForm] = useState({
    title: "",
    description: "",
    price: "",
    type: "payant",
  });
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const [showForm, setShowForm] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    const load = async () => {
      setLoading(true);
      setError("");
      try {
        const data = await getAllCourses();
        setCourses(data);
      } catch (err) {
        console.error(err);
        setError("Erreur lors du chargement des cours.");
      } finally {
        setLoading(false);
      }
    };
    load();
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setSaving(true);
    setError("");
    try {
      const course = {
        title: form.title,
        description: form.description,
        type: form.type,
        price: form.type === "payant" ? Number(form.price || 0) : 0,
        createdAt: Date.now(),
      };
      const created = await createCourse(course);
      setCourses((prev) => [created, ...prev]);
      setForm({ title: "", description: "", price: "", type: "payant" });
      setShowForm(false);
    } catch (err) {
      console.error(err);
      setError("Erreur lors de la création du cours.");
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm("Supprimer ce cours ?")) return;
    try {
      await deleteCourse(id);
      setCourses((prev) => prev.filter((c) => c.id !== id));
    } catch (err) {
      console.error(err);
      alert("Erreur lors de la suppression.");
    }
  };

  return (
    <div className="admin-page">
      <main className="admin-main">
        <h1 className="admin-title">Gestion de cours</h1>

        {error && <p className="admin-error">{error}</p>}

        <section className="admin-section">
          <h2>Vos cours</h2>
          {loading && <p>Chargement...</p>}
          {!loading && courses.length === 0 && (
            <p>Aucun cours pour le moment. Cliquez sur + pour créer un cours.</p>
          )}

          <div className="course-admin-grid">
            {courses.map((course) => (
              <div key={course.id} className="course-admin-card">
                <h3>{course.title}</h3>
                <p className="muted">{course.description}</p>
                <p>
                  Type : {course.type === "payant" ? "Payant" : "Gratuit"}
                </p>
                {course.type === "payant" && <p>Prix : {course.price} DT</p>}
                
                <div className="admin-card-actions">
                  <button
                    className="admin-btn-secondary"
                    onClick={() => navigate(`/admin/courses/${course.id}/chapters`)}
                  >
                    Gérer le contenu
                  </button>
                  <button
                    className="admin-delete"
                    onClick={() => handleDelete(course.id)}
                  >
                    Supprimer
                  </button>
                </div>
              </div>
            ))}

            <button
              type="button"
              className="course-admin-add"
              onClick={() => setShowForm((v) => !v)}
            >
              <span className="course-admin-add-plus">+</span>
              <span>Créer un cours</span>
            </button>
          </div>
        </section>

        {showForm && (
          <section className="admin-section">
            <h2>Créer un cours</h2>
            <form className="admin-form" onSubmit={handleSubmit}>
              <label>
                Titre du cours
                <input
                  name="title"
                  value={form.title}
                  onChange={handleChange}
                  required
                />
              </label>

              <label>
                Description
                <textarea
                  name="description"
                  value={form.description}
                  onChange={handleChange}
                  required
                />
              </label>

              <label>
                Type
                <select name="type" value={form.type} onChange={handleChange}>
                  <option value="payant">Payant</option>
                  <option value="gratuit">Gratuit</option>
                </select>
              </label>

              {form.type === "payant" && (
                <label>
                  Prix (DT)
                  <input
                    name="price"
                    type="number"
                    min="0"
                    value={form.price}
                    onChange={handleChange}
                    required
                  />
                </label>
              )}

              <button type="submit" className="btn-primary" disabled={saving}>
                {saving ? "Enregistrement..." : "Enregistrer le cours"}
              </button>
            </form>
          </section>
        )}
      </main>
    </div>
  );
}
