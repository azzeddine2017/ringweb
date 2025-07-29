# ======================================
# Create Quiz Questions Table Migration
# ======================================

func up {
    query("CREATE TABLE quiz_questions (
        id INT AUTO_INCREMENT PRIMARY KEY,
        quiz_id INT NOT NULL,
        question TEXT NOT NULL,
        type ENUM('multiple_choice', 'true_false', 'text') NOT NULL,
        options JSON,
        correct_answer TEXT NOT NULL,
        points INT DEFAULT 1,
        order_num INT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (quiz_id) REFERENCES quizzes(id)
    )")
}

func down {
    query("DROP TABLE IF EXISTS quiz_questions")
}
