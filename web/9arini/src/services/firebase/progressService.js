import { db } from "../../config/firebase";
import { doc, getDoc, setDoc, arrayUnion } from "firebase/firestore";

// Get the list of completed chapter IDs
export const getCourseProgress = async (userId, courseId) => {
  try {
    const ref = doc(db, "users", userId, "courseProgress", courseId);
    const snap = await getDoc(ref);
    if (snap.exists()) {
      return snap.data().completedChapters || [];
    }
    return [];
  } catch (err) {
    console.error("Error getting progress:", err);
    return [];
  }
};

// Mark a chapter as "Done"
export const markChapterRead = async (userId, courseId, chapterId) => {
  try {
    const ref = doc(db, "users", userId, "courseProgress", courseId);
    // arrayUnion adds the ID only if it doesn't already exist
    await setDoc(ref, { 
      completedChapters: arrayUnion(chapterId),
      lastUpdated: new Date()
    }, { merge: true });
  } catch (err) {
    console.error("Error marking chapter:", err);
  }
};
