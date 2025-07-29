# ======================================
# Create Forum Topics Table Migration
# ======================================

func up {
    query("CREATE TABLE forum_topics (
        id INT AUTO_INCREMENT PRIMARY KEY,
        course_id INT NOT NULL,
        user_id INT NOT NULL,
        title VARCHAR(200) NOT NULL,
        content TEXT NOT NULL,
        status ENUM('open', 'closed', 'solved') DEFAULT 'open',
        views INT DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (course_id) REFERENCES courses(id),
        FOREIGN KEY (user_id) REFERENCES users(id)
    )")
}

func down {
    query("DROP TABLE IF EXISTS forum_topics")
}
