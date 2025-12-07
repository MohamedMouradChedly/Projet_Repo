import { doc, getDoc, updateDoc } from "firebase/firestore";
import { db } from "./firebaseConfig";

const USERS_COLLECTION = "users";

export async function getUserProfile(uid) {
  const ref = doc(db, USERS_COLLECTION, uid);
  const snap = await getDoc(ref);
  if (!snap.exists()) return null;
  return { id: snap.id, ...snap.data() };
}

export async function updateUserProfile(uid, data) {
  const ref = doc(db, USERS_COLLECTION, uid);
  await updateDoc(ref, data);
}
