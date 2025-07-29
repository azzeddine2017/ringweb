# ======================================
# Create Quizzes Table Migration
# ======================================

func up {
    query("CREATE TABLE quizzes (
        id INT AUTO_INCREMENT PRIMARY KEY,
        module_id INT NOT NULL,
        title VARCHAR(200) NOT NULL,
        description TEXT,
        duration INT NOT NULL,
        passing_score INT NOT NULL,
        attempts_allowed INT DEFAULT 1,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (module_id) REFERENCES modules(id)
    )")
}

func down {
    query("DROP TABLE IF EXISTS quizzes")
}
