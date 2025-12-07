import React from "react";
import { useNavigate } from "react-router-dom";
import "./CourseCard.css";

export default function CourseCard({ course, onClick, actionLabel, actionStyle }) {
  const navigate = useNavigate();

  // Handle Image Error to show a fallback if the URL is broken
  const handleImageError = (e) => {
    e.target.src = "https://placehold.co/600x400/png?text=No+Image"; // Fallback
  };

  const handleCardClick = (e) => {
    if (e.target.tagName === "BUTTON") return;
    if (onClick) {
      onClick();
    } else {
      navigate(`/courses/${course.id}`);
    }
  };

  return (
    <div className="course-card" onClick={handleCardClick}>
      <div className="course-image-wrapper">
        {course.badge && (
          <span className={`course-badge badge-${course.badgeColor}`}>
            {course.badge}
          </span>
        )}
        <img 
            src={course.image || "https://placehold.co/600x400/png?text=Course"} 
            alt={course.title} 
            className="course-image" 
            onError={handleImageError} // <--- Add this to catch broken links
        />
      </div>

      {/* FIXED CLASS NAME: course-body matches your CSS */}
      <div className="course-body">
        <div className="course-meta">
          <span className="course-level">{course.level || "Tous niveaux"}</span>
          <span className="course-rating">
            ⭐ {course.rating || "5"}
          </span>
        </div>

        <h3 className="course-title">{course.title}</h3>

        <div className="course-footer">
          <div className="course-price">
            {course.type === "gratuit" ? "Gratuit" : `${course.price} DT`}
          </div>
          
          {actionLabel && (
            <button 
              className={`course-action-btn ${actionStyle || "btn-primary"}`}
              onClick={(e) => {
                e.stopPropagation();
                onClick && onClick();
              }}
            >
              {actionLabel}
            </button>
          )}
        </div>
      </div>
    </div>
  );
}
