# ======================================
# Create Lessons Table Migration
# ======================================

func up {
    query("CREATE TABLE lessons (
        id INT AUTO_INCREMENT PRIMARY KEY,
        module_id INT NOT NULL,
        title VARCHAR(200) NOT NULL,
        description TEXT,
        content_type ENUM('video', 'document', 'quiz') NOT NULL,
        content TEXT NOT NULL,
        duration INT,
        order_num INT NOT NULL,
        is_free BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (module_id) REFERENCES modules(id)
    )")
}

func down {
    query("DROP TABLE IF EXISTS lessons")
}
