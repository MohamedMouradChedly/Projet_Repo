import {
  getAuth,
  createUserWithEmailAndPassword,
  updateProfile,
  signInWithEmailAndPassword,
} from "firebase/auth";
import { db } from "./firebaseConfig";
import { doc, setDoc } from "firebase/firestore";

const auth = getAuth();

export async function registerWithEmail(userData) {
  const { email, password, firstName, lastName, phone } = userData;

  const cred = await createUserWithEmailAndPassword(auth, email, password);

  await updateProfile(cred.user, {
    displayName: `${firstName} ${lastName}`,
  });

  // create user profile document in Firestore
  await setDoc(doc(db, "users", cred.user.uid), {
    uid: cred.user.uid,
    firstName,
    lastName,
    email,
    phone: phone || "",
    role: email === "admin@9arini.tn" ? "admin" : "user",
    createdAt: Date.now(),
  });

  return cred.user;
}

export async function loginWithEmail(email, password) {
  const cred = await signInWithEmailAndPassword(auth, email, password);
  return cred.user;
}
