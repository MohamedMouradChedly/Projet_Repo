import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import "./ManageChapters.css"; // Uses the specific CSS we created
import {
  addChapter,
  getChaptersByCourse,
  deleteChapter,
} from "../../services/firebase/chapterService";

export default function ManageChapters() {
  const { courseId } = useParams();
  const navigate = useNavigate();
  const [chapters, setChapters] = useState([]);
  const [showForm, setShowForm] = useState(false);
  const [form, setForm] = useState({ title: "", fileUrl: "" });
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    const load = async () => {
      setLoading(true);
      try {
        const data = await getChaptersByCourse(courseId);
        setChapters(data);
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, [courseId]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!form.title) return;
    try {
      const newChapter = await addChapter(courseId, {
        title: form.title,
        fileUrl: form.fileUrl,
        type: "file",
      });
      setChapters([...chapters, newChapter]);
      setForm({ title: "", fileUrl: "" });
      setShowForm(false);
    } catch (err) {
      console.error(err);
      alert("Erreur lors de l'ajout.");
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm("Supprimer ce chapitre ?")) return;
    await deleteChapter(id);
    setChapters(chapters.filter((c) => c.id !== id));
  };

  return (
    <div className="chapters-page"> {/* UPDATED CLASS */}
      <main className="chapters-main"> {/* UPDATED CLASS */}
        
        <button className="back-link" onClick={() => navigate("/admin/courses")} style={{border: "none", cursor: "pointer"}}>
          ← Retour aux cours
        </button>

        <h1 className="chapters-title">Contenu du cours</h1>
        <p className="chapters-subtitle">Ajoutez des fichiers et des chapitres.</p>

        <div className="chapters-container"> {/* UPDATED CLASS */}
          <h2 className="section-header">Chapitres</h2>
          
          {/* Chapter List */}
          {chapters.map((chapter) => (
            <div key={chapter.id} className="chapter-item"> {/* UPDATED CLASS */}
              <div style={{display: 'flex', alignItems: 'center', gap: '15px'}}>
                 <div style={{fontSize: '1.5rem'}}>📄</div>
                 <div>
                    <h4>{chapter.title}</h4>
                    {chapter.fileUrl && (
                        <a
                        href={chapter.fileUrl}
                        target="_blank"
                        rel="noreferrer"
                        className="file-link"
                        >
                        Ouvrir le fichier
                        </a>
                    )}
                 </div>
              </div>
              
              <div className="chapter-actions">
                <button
                    className="btn-icon btn-delete"
                    onClick={() => handleDelete(chapter.id)}
                    title="Supprimer"
                >
                    🗑
                </button>
              </div>
            </div>
          ))}

          {/* + Button (Hidden when form is open) */}
          {!showForm && (
            <button
                className="btn-add-chapter"
                onClick={() => setShowForm(true)}
            >
                <span>+</span> Ajouter un chapitre
            </button>
          )}

          {/* Add Form */}
          {showForm && (
            <form className="add-form" onSubmit={handleSubmit}>
              <h3 style={{marginTop: 0, marginBottom: '15px'}}>Ajouter un fichier</h3>
              
              <input
                  placeholder="Titre du fichier/chapitre"
                  value={form.title}
                  onChange={(e) =>
                    setForm({ ...form, title: e.target.value })
                  }
                  required
                  autoFocus
               />

               <input
                  placeholder="Lien du fichier (URL) ex: https://..."
                  value={form.fileUrl}
                  onChange={(e) =>
                    setForm({ ...form, fileUrl: e.target.value })
                  }
               />
              
              <div style={{marginTop: '10px'}}>
                  <button type="submit">Ajouter</button>
                  <button 
                    type="button" 
                    className="cancel" 
                    onClick={() => setShowForm(false)}
                    style={{background: '#9ca3af'}}
                  >
                    Annuler
                  </button>
              </div>
            </form>
          )}
        </div>
      </main>
    </div>
  );
}
