# ======================================
# Create Subscriptions Table Migration
# ======================================

func up {
    query("CREATE TABLE subscriptions (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        plan ENUM('basic', 'premium', 'enterprise') NOT NULL,
        price DECIMAL(8,2) NOT NULL,
        status ENUM('active', 'cancelled', 'expired') NOT NULL,
        starts_at TIMESTAMP NOT NULL,
        ends_at TIMESTAMP NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id)
    )")
}

func down {
    query("DROP TABLE IF EXISTS subscriptions")
}
