import {
  collection,
  getDocs,
  deleteDoc,
  doc,
  orderBy,
  query,
} from "firebase/firestore";
import { db } from "./firebaseConfig";

const USERS_COLLECTION = "users";

export async function getAllUsers() {
  const ref = collection(db, USERS_COLLECTION);
  const q = query(ref, orderBy("createdAt", "desc"));
  const snapshot = await getDocs(q);
  return snapshot.docs.map((d) => ({ id: d.id, ...d.data() }));
}

export async function deleteUserProfile(id) {
  const ref = doc(db, USERS_COLLECTION, id);
  await deleteDoc(ref);
}
