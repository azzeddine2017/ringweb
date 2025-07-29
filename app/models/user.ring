# ======================================
# RingWeb Framework
# User Model
# ======================================

Package App.Models

Class User from Model
    # Properties
    cTable = "users"
    aFillable = ["name", "email", "password"]
    aHidden = ["password"]
    
    # Relationships
    func posts
        return hasMany("Post")
    
    func comments
        return hasMany("Comment")
    
    # Custom Methods
    func findByEmail cEmail
        return where("email", "=", cEmail).first()
    
    func isAdmin
        return self.role = "admin"
    
    # Events
    func beforeSave
        if isNew() {
            self.created_at = now()
        }
        self.updated_at = now()
    
    func afterFind
        # Custom logic after finding a user
        if self.last_login = null {
            self.last_login = "Never logged in"
        }
    
    # Validation Rules
    func rules
        return [
            "name" = "required|min:3",
            "email" = "required|email|unique:users",
            "password" = "required|min:6"
        ]
    
    # Custom Attributes
    func getFullNameAttribute
        return self.name + " (" + self.email + ")"
