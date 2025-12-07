import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";
import { AuthProvider } from "./core/AuthContext";
import { CartProvider } from "./core/CartContext";

const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(
  <AuthProvider>
    <CartProvider>
     <App />
    </CartProvider>
  </AuthProvider>
);
