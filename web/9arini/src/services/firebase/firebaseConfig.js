// src/services/firebase/firebaseConfig.js
import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore"; 

const firebaseConfig = {
  apiKey: "AIzaSyBNjQSHy0fnXkS0zALFbIdIBD-0oGDpqr0",
  authDomain: "arini-a17ad.firebaseapp.com",
  projectId: "arini-a17ad",
  storageBucket: "arini-a17ad.firebasestorage.app",
  messagingSenderId: "649651343598",
  appId: "1:649651343598:web:9e3c7a98b5664c4ce0a3ff",
  measurementId: "G-0144R8F5EN"
};


const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);