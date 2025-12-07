import {
  collection,
  addDoc,
  query,
  where,
  getDocs,
  deleteDoc,
} from "firebase/firestore";
import { db } from "./firebaseConfig";

const ENROLL_COLLECTION = "user_courses"; // Matches your "Mes cours" collection

// Check if user is enrolled in a specific course (Single check)
export async function checkEnrollment(userId, courseId) {
  try {
    const q = query(
      collection(db, ENROLL_COLLECTION),
      where("userId", "==", userId),
      where("courseId", "==", courseId)
    );
    const snapshot = await getDocs(q);
    return !snapshot.empty;
  } catch (error) {
    console.error("Error checking enrollment:", error);
    return false;
  }
}

// Enroll user in a course
export async function enrollUserInCourse(userId, courseId) {
  try {
    // Prevent duplicate enrollment
    const isEnrolled = await checkEnrollment(userId, courseId);
    if (isEnrolled) {
      console.log(`User ${userId} already enrolled in ${courseId}`);
      return;
    }

    await addDoc(collection(db, ENROLL_COLLECTION), {
      userId,
      courseId,
      enrolledAt: Date.now(),
    });
    console.log(`Successfully enrolled ${userId} in ${courseId}`);
  } catch (error) {
    console.error("Error enrolling user:", error);
    throw error;
  }
}

// NEW: Get all enrollments for a user (Required for filtering Browse List)
export async function getUserEnrollments(userId) {
  try {
    const q = query(
      collection(db, ENROLL_COLLECTION),
      where("userId", "==", userId)
    );
    const snapshot = await getDocs(q);
    
    // Returns an array of objects: [{ userId: "...", courseId: "...", enrolledAt: ... }, ...]
    return snapshot.docs.map((doc) => ({
      id: doc.id, 
      ...doc.data()
    }));
  } catch (error) {
    console.error("Error getting user enrollments:", error);
    return [];
  }
}

// Unenroll (optional)
export async function unenrollUser(userId, courseId) {
  try {
    const q = query(
      collection(db, ENROLL_COLLECTION),
      where("userId", "==", userId),
      where("courseId", "==", courseId)
    );
    const snapshot = await getDocs(q);
    snapshot.forEach(async (doc) => {
      await deleteDoc(doc.ref);
    });
  } catch (error) {
    console.error("Error unenrolling user:", error);
  }
}

// Get ALL enrollments (for Admin Stats)
export async function getAllEnrollments() {
  try {
    const q = query(collection(db, ENROLL_COLLECTION));
    const snapshot = await getDocs(q);
    return snapshot.size; // Returns just the count (number)
  } catch (error) {
    console.error("Error getting all enrollments:", error);
    return 0;
  }
}
