import React, { useContext, useState } from "react";
import { CartContext } from "../../core/CartContext";
import { AuthContext } from "../../core/AuthContext";
import Header from "../../core/components/Header";
import Footer from "../../core/components/Footer";
import { createPayment } from "../../services/paymeeService";
import { useNavigate } from "react-router-dom";
import "./Cart.css";

export default function Cart() {
  const { cart, removeFromCart, total } = useContext(CartContext);
  const { user } = useContext(AuthContext);
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handlePayment = async () => {
    if (!user) {
      alert("Veuillez vous connecter pour payer.");
      navigate("/auth/login");
      return;
    }

    setLoading(true);
    try {
      // 1. BACKUP CART (Crucial for post-payment logic)
      localStorage.setItem("temp_cart_backup", JSON.stringify(cart));

      const orderId = `ORDER-${Date.now()}`;
      
      // 2. Call Paymee Service
      const paymentUrl = await createPayment(total, orderId);

      // 3. Redirect to Paymee (via Ngrok/HTTPS)
      if (paymentUrl) {
        window.location.href = paymentUrl;
      }
    } catch (err) {
      console.error(err);
      alert("Erreur d'initialisation du paiement.");
      setLoading(false);
    }
  };

  return (
    <div className="cart-page">
      <Header />
      <main className="cart-main">
        <h1>Mon Panier</h1>

        {cart.length === 0 ? (
          <div className="empty-cart-message">
            <p>Votre panier est vide.</p>
            <button className="browse-btn" onClick={() => navigate("/courses")}>
              Parcourir les cours
            </button>
          </div>
        ) : (
          <div className="cart-container">
            {/* LEFT COLUMN: List of Items */}
            <div className="cart-items-list">
              {cart.map((item) => (
                <div key={item.id} className="cart-item">
                  <div className="cart-item-image">
                    <img src={item.image} alt={item.title} />
                  </div>
                  <div className="cart-item-details">
                    <h3>{item.title}</h3>
                    <p className="item-price">{item.price} DT</p>
                  </div>
                  <div className="cart-item-actions">
                    <button 
                      className="remove-btn"
                      onClick={() => removeFromCart(item.id)}
                      aria-label="Retirer du panier"
                    >
                      Supprimer
                    </button>
                  </div>
                </div>
              ))}
            </div>

            {/* RIGHT COLUMN: Summary & Pay Button */}
            <div className="cart-summary-card">
              <h2>Résumé de la commande</h2>
              <div className="summary-row">
                <span>Nombre d'articles:</span>
                <span>{cart.length}</span>
              </div>
              <div className="summary-row total-row">
                <span>Total:</span>
                <span>{total} DT</span>
              </div>
              
              <button 
                className="checkout-btn" 
                onClick={handlePayment} 
                disabled={loading}
              >
                {loading ? "Chargement..." : "Payer maintenant"}
              </button>
            </div>
          </div>
        )}
      </main>
      <Footer />
    </div>
  );
}
