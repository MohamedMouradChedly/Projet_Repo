import { collection, query, where, getDocs, doc, getDoc } from "firebase/firestore";
import { db } from "./firebaseConfig";

// MUST match the collection name in enrollmentService.js
const ENROLL_COLLECTION = "user_courses"; 
const COURSES_COLLECTION = "courses";

export async function getUserCourses(userId) {
  try {
    // 1. Query the enrollment collection for this user
    const q = query(
      collection(db, ENROLL_COLLECTION),
      where("userId", "==", userId)
    );
    const snapshot = await getDocs(q);

    if (snapshot.empty) {
      return [];
    }

    // 2. Get all course IDs from the enrollment documents
    const enrollments = snapshot.docs.map((doc) => ({
      enrollmentId: doc.id,
      ...doc.data(),
    }));

    // 3. Fetch the full course details for each ID
    const coursePromises = enrollments.map(async (enrollment) => {
      // enrollment.courseId comes from the document we saved in enrollmentService
      if (!enrollment.courseId) return null;

      const courseRef = doc(db, COURSES_COLLECTION, enrollment.courseId);
      const courseSnap = await getDoc(courseRef);
      
      if (courseSnap.exists()) {
        return {
          id: courseSnap.id,
          ...courseSnap.data(),
          enrolledAt: enrollment.enrolledAt,
        };
      } else {
        // Course might have been deleted by admin
        return null;
      }
    });

    // 4. Wait for all courses to load and remove any nulls
    const courses = await Promise.all(coursePromises);
    return courses.filter((course) => course !== null);

  } catch (error) {
    console.error("Error fetching user courses:", error);
    throw error;
  }
}
