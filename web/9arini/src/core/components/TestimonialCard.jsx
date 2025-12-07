import React from "react";
import "./TestimonialCard.css";

export default function TestimonialCard({ testimonial }) {
  const { avatar, name, role, text, rating } = testimonial;

  return (
    <div className="testimonial-card">
      <div className="testimonial-header">
        <img src={avatar} alt={name} className="testimonial-avatar" />
        <div>
          <div className="testimonial-name">{name}</div>
          <div className="testimonial-role">{role}</div>
          <div className="testimonial-stars">
            {"★".repeat(rating)}{" "}
            <span className="testimonial-stars-muted">
              {"★".repeat(5 - rating)}
            </span>
          </div>
        </div>
      </div>
      <p className="testimonial-text">“{text}”</p>
    </div>
  );
}
