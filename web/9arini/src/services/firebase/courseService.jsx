import {
  collection,
  addDoc,
  getDocs,
  deleteDoc,
  doc,
  query,
  orderBy,
} from "firebase/firestore";
import { db } from "./firebaseConfig";

const COURSES_COLLECTION = "courses";

export async function createCourse(course) {
  const ref = collection(db, COURSES_COLLECTION);
  const docRef = await addDoc(ref, course);
  return { id: docRef.id, ...course };
}

export async function getAllCourses() {
  const ref = collection(db, COURSES_COLLECTION);
  const q = query(ref, orderBy("createdAt", "desc"));
  const snapshot = await getDocs(q);
  return snapshot.docs.map((d) => ({ id: d.id, ...d.data() }));
}

export async function deleteCourse(id) {
  const ref = doc(db, COURSES_COLLECTION, id);
  await deleteDoc(ref);
}
