# ======================================
# Module Controller
# ======================================

load "controller.ring"
load "app/models/course.ring"
load "app/models/module.ring"
load "app/auth/auth.ring"

class ModuleController from Controller
    # Properties
    oModule
    oCourse
    oAuth
    
    func init
        oModule = new Module()
        oCourse = new Course()
        oAuth = new Auth().initFromSession()
    
    func create cCourseSlug
        # Get course
        courseId = oCourse.where("slug", "=", cCourseSlug).first()
        
        if courseId = null {
            return redirect("/courses")
                   .withError("course_not_found", "Course not found")
        }
        
        # Check if user is the instructor
        if !oAuth.check() or !oAuth.user().isInstructor()
            return redirect("/courses")
                   .withError("unauthorized", "You are not authorized to add modules to this course")
        
        return view("modules/create", ["course" = courseId])
    
    func store cCourseSlug
        # Get course
        courseId = oCourse.where("slug", "=", cCourseSlug).first()
        
        if courseId = null {
            return redirect("/courses")
                   .withError("course_not_found", "Course not found")
        }
        
        # Check if user is the instructor
        if !oAuth.check() or !oAuth.user().isInstructor()
            return redirect("/courses")
                   .withError("unauthorized", "You are not authorized to add modules to this course")
        
        # Validate request
        if not validate(oModule.rules()) {
            return redirect("/courses/" + cCourseSlug + "/modules/create")
                   .withErrors(getValidationErrors())
                   .withInput()
        }
        
        # Get the next order number
        nOrder = oModule.where("course_id", "=", courseId)
                       .count() + 1
        
        # Create module
        moduleId = oModule.create([
            "course_id" = courseId,
            "title" = request("title"),
            "description" = request("description"),
            "order_num" = nOrder
        ])
        
        return redirect("/courses/" + cCourseSlug)
               .withSuccess("module_created", "Module created successfully")
    
    func edit cCourseSlug, nModuleId
        # Get module
        module = oModule.find(nModuleId)
        
        if module = null {
            return redirect("/courses/" + cCourseSlug)
                   .withError("module_not_found", "Module not found")
        }
        
        # Check if user is the instructor
        if !oAuth.check() or !oAuth.user().isInstructor()
            return redirect("/courses")
                   .withError("unauthorized", "You are not authorized to edit this module")
        
        return view("modules/edit", ["module" = module])
    
    func update cCourseSlug, nModuleId
        # Get module
        module = oModule.find(nModuleId)
        
        if module = null {
            return redirect("/courses/" + cCourseSlug)
                   .withError("module_not_found", "Module not found")
        }
        
        # Check if user is the instructor
        if !oAuth.check() or !oAuth.user().isInstructor()
            return redirect("/courses")
                   .withError("unauthorized", "You are not authorized to edit this module")
        
        # Validate request
        if not validate(oModule.rules()) {
            return redirect("/courses/" + cCourseSlug + "/modules/" + nModuleId + "/edit")
                   .withErrors(getValidationErrors())
                   .withInput()
        }
        
        # Update module
        oModule.update(nModuleId, [
            "title" = request("title"),
            "description" = request("description")
        ])
        
        return redirect("/courses/" + cCourseSlug)
               .withSuccess("module_updated", "Module updated successfully")
    
    func delete cCourseSlug, nModuleId
        # Get module
        module = oModule.find(nModuleId)
        
        if module = null {
            return redirect("/courses/" + cCourseSlug)
                   .withError("module_not_found", "Module not found")
        }
        
        # Check if user is the instructor
        if !oAuth.check() or !oAuth.user().isInstructor()
            return redirect("/courses")
                   .withError("unauthorized", "You are not authorized to delete this module")
        
        # Delete module
        oModule.delete(nModuleId)
        
        # Reorder remaining modules
        query("SET @order = 0")
        query("
            UPDATE modules 
            SET order_num = (@order := @order + 1) 
            WHERE course_id = ? 
            ORDER BY order_num ASC
        ", [courseId])
        
        return redirect("/courses/" + cCourseSlug)
               .withSuccess("module_deleted", "Module deleted successfully")
