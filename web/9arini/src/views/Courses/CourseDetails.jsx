import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import Header from "../../core/components/Header";
import Footer from "../../core/components/Footer";
import { getChaptersByCourse } from "../../services/firebase/chapterService";
import { doc, getDoc } from "firebase/firestore";
import { db } from "../../services/firebase/firebaseConfig";
import "./CourseList.css"; // Reusing existing styles for consistency

export default function CourseDetails() {
  const { courseId } = useParams();
  const navigate = useNavigate();
  const [course, setCourse] = useState(null);
  const [chapters, setChapters] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadData = async () => {
      setLoading(true);
      try {
        // Load course details
        const courseRef = doc(db, "courses", courseId);
        const courseSnap = await getDoc(courseRef);
        
        if (courseSnap.exists()) {
          setCourse({ id: courseSnap.id, ...courseSnap.data() });
          
          // Load chapters
          const chaptersData = await getChaptersByCourse(courseId);
          setChapters(chaptersData);
        } else {
          console.error("Course not found");
        }
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    loadData();
  }, [courseId]);

  if (loading) {
    return (
      <div className="courses-page">
        <Header />
        <main className="courses-main">
          <p>Chargement du cours...</p>
        </main>
        <Footer />
      </div>
    );
  }

  if (!course) {
    return (
      <div className="courses-page">
        <Header />
        <main className="courses-main">
          <p>Cours introuvable.</p>
          <button onClick={() => navigate("/my-courses")}>Retour</button>
        </main>
        <Footer />
      </div>
    );
  }

  return (
    <div className="courses-page">
      <Header />
      <main className="courses-main">
        <button 
          style={{ 
            background: 'none', 
            border: 'none', 
            color: '#6b7280', 
            cursor: 'pointer', 
            marginBottom: '20px',
            fontSize: '1rem'
          }}
          onClick={() => navigate(-1)}
        >
          ← Retour
        </button>

        <header className="courses-header">
          <h1>{course.title}</h1>
          <p>{course.description}</p>
        </header>

        <section className="courses-section">
          <div className="courses-section-header">
            <h2>Contenu du cours</h2>
            <p>{chapters.length} chapitre(s) disponible(s)</p>
          </div>

          {chapters.length === 0 ? (
            <p>Aucun contenu n'a encore été ajouté pour ce cours.</p>
          ) : (
            <div style={{ 
              display: 'grid', 
              gridTemplateColumns: 'repeat(auto-fill, minmax(250px, 1fr))', 
              gap: '20px',
              marginTop: '20px'
            }}>
              {chapters.map((chapter) => (
                <div 
                  key={chapter.id} 
                  style={{
                    background: 'white',
                    padding: '20px',
                    borderRadius: '12px',
                    border: '1px solid #e5e7eb',
                    textAlign: 'center',
                    display: 'flex',
                    flexDirection: 'column',
                    alignItems: 'center',
                    gap: '10px'
                  }}
                >
                  <div style={{ fontSize: '2.5rem' }}>📄</div>
                  <h3 style={{ fontSize: '1.1rem', margin: 0 }}>{chapter.title}</h3>
                  {chapter.fileUrl ? (
                    <a 
                      href={chapter.fileUrl} 
                      target="_blank" 
                      rel="noreferrer"
                      style={{
                        marginTop: 'auto',
                        padding: '8px 16px',
                        background: '#2563eb',
                        color: 'white',
                        textDecoration: 'none',
                        borderRadius: '999px',
                        fontSize: '0.9rem',
                        fontWeight: '600'
                      }}
                    >
                      Ouvrir
                    </a>
                  ) : (
                    <span style={{ color: '#9ca3af', fontSize: '0.9rem' }}>
                      Fichier indisponible
                    </span>
                  )}
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
