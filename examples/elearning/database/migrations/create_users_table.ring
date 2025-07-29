# ======================================
# Create Users Table Migration
# ======================================

func up {
    query("CREATE TABLE users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        role_id INT NOT NULL,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        avatar VARCHAR(255),
        bio TEXT,
        email_verified_at TIMESTAMP,
        remember_token VARCHAR(100),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (role_id) REFERENCES roles(id)
    )")
}

func down {
    query("DROP TABLE IF EXISTS users")
}
