# ======================================
# Create Forum Replies Table Migration
# ======================================

func up {
    query("CREATE TABLE forum_replies (
        id INT AUTO_INCREMENT PRIMARY KEY,
        topic_id INT NOT NULL,
        user_id INT NOT NULL,
        content TEXT NOT NULL,
        is_solution BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (topic_id) REFERENCES forum_topics(id),
        FOREIGN KEY (user_id) REFERENCES users(id)
    )")
}

func down {
    query("DROP TABLE IF EXISTS forum_replies")
}
