import { db } from "../../services/firebase/firebaseConfig"; 
import { 
  collection, 
  getDocs, 
  query, 
  where, 
  orderBy, 
  addDoc, 
  deleteDoc, 
  doc 
} from "firebase/firestore";

// 1. GET ALL CHAPTERS for a course
export const getChaptersByCourse = async (courseId) => {
  try {
    const q = query(
      collection(db, "chapters"), 
      where("courseId", "==", courseId)
      // orderBy("createdAt", "asc") // Optional: sort by creation date if you have it
    );
    
    const snapshot = await getDocs(q);
    return snapshot.docs.map(d => ({ id: d.id, ...d.data() }));
  } catch (error) {
    console.error("Error fetching chapters:", error);
    return [];
  }
};

// 2. ADD A NEW CHAPTER
export const addChapter = async (courseId, chapterData) => {
  try {
    const docRef = await addDoc(collection(db, "chapters"), {
      courseId: courseId,
      title: chapterData.title,
      fileUrl: chapterData.fileUrl || "",
      type: chapterData.type || "file", // 'file', 'video', etc.
      createdAt: new Date()
    });
    
    return { id: docRef.id, ...chapterData };
  } catch (error) {
    console.error("Error adding chapter:", error);
    throw error;
  }
};

// 3. DELETE A CHAPTER
export const deleteChapter = async (chapterId) => {
  try {
    await deleteDoc(doc(db, "chapters", chapterId));
    return true;
  } catch (error) {
    console.error("Error deleting chapter:", error);
    throw error;
  }
};
