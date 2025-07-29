# ======================================
# Create Certificates Table Migration
# ======================================

func up {
    query("CREATE TABLE certificates (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        course_id INT NOT NULL,
        certificate_number VARCHAR(100) UNIQUE NOT NULL,
        issued_at TIMESTAMP NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (course_id) REFERENCES courses(id)
    )")
}

func down {
    query("DROP TABLE IF EXISTS certificates")
}
