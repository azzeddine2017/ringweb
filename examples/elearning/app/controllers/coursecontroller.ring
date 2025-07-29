# ======================================
# Course Controller
# ======================================

load "controller.ring"
load "app/models/course.ring"
load "app/models/category.ring"
load "app/auth/auth.ring"

class CourseController from Controller
    # Properties
    oCourse
    oCategory
    oAuth
    
    func init
        oCourse = new Course()
        oCategory = new Category()
        oAuth = new Auth().initFromSession()
    
    func index
        # Get all published courses
        aCourses = oCourse.query("SELECT * FROM courses WHERE status = 'published' ORDER BY created_at DESC")
        
        # Get categories for filter
        aCategories = oCategory.all()
        
        return view("courses/index", {
            "courses": aCourses,
            "categories": aCategories
        })
    
    func show cSlug
        # Get course by slug
        oCourseData = oCourse.find(cSlug)
        
        if !oCourseData
            return redirect("/courses").withError("course_not_found", "Course not found")
        
        return view("courses/show", {
            "course": oCourseData
        })
    
    func create
        # Check if user is instructor
        if !oAuth.check() or !oAuth.user().isInstructor()
            return redirect("/courses").withError("unauthorized", "You are not authorized to create courses")
        
        # Get categories for select menu
        aCategories = oCategory.all()
        
        return view("courses/create", {
            "categories": aCategories
        })
    
    func store
        # Check if user is instructor
        if !oAuth.check() or !oAuth.user().isInstructor()
            return redirect("/courses").withError("unauthorized", "You are not authorized to create courses")
        
        # Validate request
        if !validate(oCourse.rules())
            return redirect("/courses/create").withErrors(getValidationErrors()).withInput()
        
        # Handle image upload
        cImage = ""
        if request("image")
            cImage = uploadFile("image", "courses")
        
        # Create course
        oNewCourse = oCourse.create({
            "category_id": request("category_id"),
            "instructor_id": oAuth.user().id,
            "title": request("title"),
            "description": request("description"),
            "image": cImage,
            "price": request("price"),
            "duration": request("duration"),
            "level": request("level"),
            "status": "draft"
        })
        
        return redirect("/courses/" + oNewCourse.slug).withSuccess("course_created", "Course created successfully")
    
    func edit cSlug
        # Get course
        oCourseData = oCourse.find(cSlug)
        
        if !oCourseData
            return redirect("/courses").withError("course_not_found", "Course not found")
        
        # Check if user is the instructor
        if oCourseData.instructor_id != oAuth.user().id
            return redirect("/courses").withError("unauthorized", "You are not authorized to edit this course")
        
        # Get categories for select menu
        aCategories = oCategory.all()
        
        return view("courses/edit", {
            "course": oCourseData,
            "categories": aCategories
        })
    
    func update cSlug
        # Get course
        oCourseData = oCourse.find(cSlug)
        
        if !oCourseData
            return redirect("/courses").withError("course_not_found", "Course not found")
        
        # Check if user is the instructor
        if oCourseData.instructor_id != oAuth.user().id
            return redirect("/courses").withError("unauthorized", "You are not authorized to edit this course")
        
        # Validate request
        if !validate(oCourse.rules())
            return redirect("/courses/" + cSlug + "/edit").withErrors(getValidationErrors()).withInput()
        
        # Handle image upload
        cImage = oCourseData.image
        if request("image")
            # Delete old image
            if cImage
                deleteFile(cImage)
            cImage = uploadFile("image", "courses")
        
        # Update course
        oCourseData.update({
            "category_id": request("category_id"),
            "title": request("title"),
            "description": request("description"),
            "image": cImage,
            "price": request("price"),
            "duration": request("duration"),
            "level": request("level")
        })
        
        return redirect("/courses/" + oCourseData.slug).withSuccess("course_updated", "Course updated successfully")
    
    func delete cSlug
        # Get course
        oCourseData = oCourse.find(cSlug)
        
        if !oCourseData
            return redirect("/courses").withError("course_not_found", "Course not found")
        
        # Check if user is the instructor
        if oCourseData.instructor_id != oAuth.user().id
            return redirect("/courses").withError("unauthorized", "You are not authorized to delete this course")
        
        # Delete course image
        if oCourseData.image
            deleteFile(oCourseData.image)
        
        # Delete course
        oCourseData.delete()
        
        return redirect("/courses").withSuccess("course_deleted", "Course deleted successfully")
