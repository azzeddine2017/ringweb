# ======================================
# User Model
# ======================================

Package App.Models

Class User from Model
    # Properties
    cTable = "users"
    aFillable = ["role_id", "name", "email", "password", "avatar", "bio"]
    aHidden = ["password", "remember_token"]
    
    # Relationships
    func role
        return new Role().find(role_id)
    
    func coursesTeaching
        return new Course().where("instructor_id = ?", [id]).get()
    
    func coursesEnrolled
        return query("
            SELECT courses.* 
            FROM courses 
            JOIN enrollments ON courses.id = enrollments.course_id 
            WHERE enrollments.user_id = ?
            ORDER BY enrollments.created_at DESC
        ", [id])
    
    func forumTopics
        return new ForumTopic().where("user_id = ?", [id]).orderBy("created_at", "DESC").get()
    
    func forumReplies
        return new ForumReply().where("user_id = ?", [id]).orderBy("created_at", "DESC").get()
    
    func certificates
        return new Certificate().where("user_id = ?", [id]).orderBy("issued_at", "DESC").get()
    
    func notifications
        return new Notification().where("user_id = ?", [id]).orderBy("created_at", "DESC").get()
    
    func unreadNotificationsCount
        result = query("SELECT COUNT(*) as count FROM notifications WHERE user_id = ? AND read_at IS NULL", [id])
        return result[1]["count"]
    
    func receivedMessages
        return new Message().where("receiver_id = ?", [id]).orderBy("created_at", "DESC").get()
    
    func sentMessages
        return new Message().where("sender_id = ?", [id]).orderBy("created_at", "DESC").get()
    
    func unreadMessagesCount
        result = query("SELECT COUNT(*) as count FROM messages WHERE receiver_id = ? AND read_at IS NULL", [id])
        return result[1]["count"]
    
    func activeSubscription
        return query("
            SELECT * FROM subscriptions 
            WHERE user_id = ? 
            AND status = 'active' 
            AND starts_at <= NOW() 
            AND ends_at >= NOW() 
            ORDER BY created_at DESC 
            LIMIT 1
        ", [id])[1]
    
    # Custom Methods
    func isAdmin
        return self.role.name = "admin"
    
    func isInstructor
        return self.role.name = "instructor"
    
    func isStudent
        return self.role.name = "student"
    
    # Events
    func beforeSave
        if isNew() {
            self.created_at = now()
        }
        self.updated_at = now()
    
    # Validation Rules
    func rules
        return [
            "role_id" = "required|exists:roles,id",
            "name" = "required|min:3",
            "email" = "required|email|unique:users",
            "password" = "required|min:6",
            "avatar" = "nullable|image",
            "bio" = "nullable"
        ]
