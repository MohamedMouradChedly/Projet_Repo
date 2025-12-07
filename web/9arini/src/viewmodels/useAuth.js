import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { registerWithEmail, loginWithEmail } from "../services/firebase/authService";

export function useAuth() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const navigate = useNavigate();

const register = async (userData) => {
  setLoading(true);
  setError("");
  try {
    const user = await registerWithEmail(userData);
    // normal user goes to app home
    navigate("/app/home");
    return user;
  } catch (err) {
    setError(err.message);
  } finally {
    setLoading(false);
  }
};

const login = async (email, password) => {
  setLoading(true);
  setError("");
  try {
    const user = await loginWithEmail(email, password);

    if (email === "admin@9arini.tn") {
      navigate("/admin");
    } else {
      navigate("/app/home");
    }
    return user;
  } catch (err) {
    setError(err.message);
  } finally {
    setLoading(false);
  }
};

  return { loading, error, register, login };
}
