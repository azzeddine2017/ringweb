# ======================================
# Role Model
# ======================================

Package App.Models

Class Role from Model
    # Properties
    cTable = "roles"
    aFillable = ["name", "description"]
    
    # Relationships
    func users
        return new User().where("role_id = ?", [self.id]).get()
    
    func usersCount
        result = query("SELECT COUNT(*) as count FROM users WHERE role_id = ?", [self.id])
        return result[1]["count"]
    
    func hasUsers
        return usersCount() > 0
    
    # Events
    func beforeSave
        if isNew() {
            self.created_at = now()
        }
        self.updated_at = now()
    
    # Validation Rules
    func rules
        return [
            "name" = "required|min:3|unique:roles",
            "description" = "nullable"
        ]
