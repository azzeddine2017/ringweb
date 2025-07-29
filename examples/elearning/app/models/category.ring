# ======================================
# Category Model
# ======================================

Package App.Models

Class Category from Model
    # Properties
    cTable = "categories"
    aFillable = ["name", "slug", "description", "image", "parent_id"]
    
    # Relationships
    func parent
        if self.parent_id {
            return new Category().findById(self.parent_id)
        }
        return null
    
    func subcategories
        return new Category().where("parent_id = ?", [self.id]).get()
    
    func subcategoriesCount
        result = query("SELECT COUNT(*) as count FROM categories WHERE parent_id = ?", [self.id])
        return result[1]["count"]
    
    func courses
        return new Course().where("category_id = ?", [self.id]).get()
    
    func courseCount
        result = query("SELECT COUNT(*) as count FROM courses WHERE category_id = ?", [self.id])
        return result[1]["count"]
    
    func hasSubcategories
        return self.subcategoriesCount() > 0
    
    func hasCourses
        return self.courseCount() > 0
    
    # Events
    func beforeSave
        if isNew() {
            self.created_at = now()
        }
        self.updated_at = now()
        
        # Generate slug if not provided
        if self.slug = null {
            self.slug = slugify(self.name)
        }
    
    # Validation Rules
    func rules
        return [
            "name" = "required|min:3",
            "slug" = "nullable|unique:categories",
            "description" = "nullable",
            "image" = "nullable|image",
            "parent_id" = "nullable|exists:categories,id"
        ]
    
    # Custom Methods
    private func slugify cStr
        # Convert string to lowercase URL-friendly slug
        cStr = lower(cStr)
        cStr = replaceAll(cStr, " ", "-")
        cStr = replaceAll(cStr, "[^a-z0-9\-]", "")
        return cStr
