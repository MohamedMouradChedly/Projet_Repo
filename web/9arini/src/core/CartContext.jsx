import React, { createContext, useState, useEffect } from "react";

export const CartContext = createContext();

export const CartProvider = ({ children }) => {
  const [cart, setCart] = useState([]);

  // Load cart from localStorage on init
  useEffect(() => {
    const storedCart = localStorage.getItem("9arini_cart");
    if (storedCart) {
      setCart(JSON.parse(storedCart));
    }
  }, []);

  // Save to localStorage whenever cart changes
  useEffect(() => {
    localStorage.setItem("9arini_cart", JSON.stringify(cart));
  }, [cart]);

  const addToCart = (course) => {
    // Check if already in cart
    if (cart.find((item) => item.id === course.id)) return;
    setCart([...cart, course]);
  };

  const removeFromCart = (courseId) => {
    setCart(cart.filter((item) => item.id !== courseId));
  };

  const clearCart = () => {
    setCart([]);
  };

  const total = cart.reduce((sum, item) => sum + (Number(item.price) || 0), 0);

  return (
    <CartContext.Provider value={{ cart, addToCart, removeFromCart, clearCart, total }}>
      {children}
    </CartContext.Provider>
  );
};
