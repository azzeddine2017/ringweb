# ======================================
# Create Courses Table Migration
# ======================================

func up {
    query("CREATE TABLE courses (
        id INT AUTO_INCREMENT PRIMARY KEY,
        category_id INT NOT NULL,
        instructor_id INT NOT NULL,
        title VARCHAR(200) NOT NULL,
        slug VARCHAR(200) UNIQUE NOT NULL,
        description TEXT NOT NULL,
        image VARCHAR(255),
        price DECIMAL(8,2) NOT NULL,
        duration INT NOT NULL,
        level ENUM('beginner', 'intermediate', 'advanced') NOT NULL,
        status ENUM('draft', 'published', 'archived') DEFAULT 'draft',
        featured BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (category_id) REFERENCES categories(id),
        FOREIGN KEY (instructor_id) REFERENCES users(id)
    )")
}

func down {
    query("DROP TABLE IF EXISTS courses")
}
