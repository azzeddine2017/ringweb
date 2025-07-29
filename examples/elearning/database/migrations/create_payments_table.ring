# ======================================
# Create Payments Table Migration
# ======================================

func up {
    query("CREATE TABLE payments (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        course_id INT,
        subscription_id INT,
        amount DECIMAL(10,2) NOT NULL,
        currency VARCHAR(3) DEFAULT 'USD',
        payment_method VARCHAR(50) NOT NULL,
        transaction_id VARCHAR(100) UNIQUE NOT NULL,
        status ENUM('pending', 'completed', 'failed', 'refunded') NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (course_id) REFERENCES courses(id),
        FOREIGN KEY (subscription_id) REFERENCES subscriptions(id)
    )")
}

func down {
    query("DROP TABLE IF EXISTS payments")
}
