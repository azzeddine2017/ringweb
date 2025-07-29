# ======================================
# Course Model
# ======================================

Package App.Models

Class Course from Model
    # Properties
    cTable = "courses"
    aFillable = ["category_id", "instructor_id", "title", "slug", "description", 
                 "image", "price", "duration", "level", "status", "featured"]
    
    # Relationships
    func category
        return new Category().find(category_id)
    
    func instructor
        return new User().find(instructor_id)
    
    func modules
        return new Module().where("course_id = ?", [id]).orderBy("order_num", "ASC").get()
    
    func moduleCount
        result = query("SELECT COUNT(*) as count FROM modules WHERE course_id = ?", [id])
        return result[1]["count"]
    
    func enrollments
        return query("SELECT * FROM enrollments WHERE course_id = ? ORDER BY created_at DESC", [id])
    
    func students
        return query("
            SELECT users.* 
            FROM users 
            JOIN enrollments ON users.id = enrollments.user_id 
            WHERE enrollments.course_id = ?
            ORDER BY enrollments.created_at DESC
        ", [id])
    
    func studentCount
        result = query("SELECT COUNT(*) as count FROM enrollments WHERE course_id = ?", [id])
        return result[1]["count"]
    
    func forumTopics
        return new ForumTopic().where("course_id = ?", [id]).orderBy("created_at", "DESC").get()
    
    func forumTopicsCount
        result = query("SELECT COUNT(*) as count FROM forum_topics WHERE course_id = ?", [id])
        return result[1]["count"]
    
    # Events
    func beforeSave
        if isNew() {
            self.created_at = now()
        }
        self.updated_at = now()
        
        # Generate slug if not provided
        if self.slug = null {
            self.slug = slugify(self.title)
        }
    
    # Validation Rules
    func rules
        return [
            "category_id" = "required|exists:categories,id",
            "instructor_id" = "required|exists:users,id",
            "title" = "required|min:5",
            "slug" = "nullable|unique:courses",
            "description" = "required",
            "image" = "nullable|image",
            "price" = "required|numeric|min:0",
            "duration" = "required|integer|min:0",
            "level" = "required|in:beginner,intermediate,advanced",
            "status" = "required|in:draft,published,archived",
            "featured" = "boolean"
        ]
    
    # Custom Methods
    func getTotalLessons
        nTotal = 0
        for module in self.modules {
            nTotal += len(module.lessons)
        }
        return nTotal
    
    func isUserEnrolled(userId)
        result = query("SELECT COUNT(*) as count FROM enrollments WHERE course_id = ? AND user_id = ?", [id, userId])
        return result[1]["count"] > 0
    
    func enrollUser(userId)
        if !isUserEnrolled(userId)
            query("INSERT INTO enrollments (course_id, user_id, created_at, updated_at) VALUES (?, ?, NOW(), NOW())", [id, userId])
            return true
        return false
    
    func unenrollUser(userId)
        if isUserEnrolled(userId)
            query("DELETE FROM enrollments WHERE course_id = ? AND user_id = ?", [id, userId])
            return true
        return false
    
    private func slugify cStr
        # Convert string to lowercase URL-friendly slug
        cStr = lower(cStr)
        cStr = replaceAll(cStr, " ", "-")
        cStr = replaceAll(cStr, "[^a-z0-9\-]", "")
        return cStr
