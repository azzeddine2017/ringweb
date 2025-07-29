# ======================================
# RingWeb Framework
# User Controller
# ======================================

Package App.Controllers

Load "app/models/user.ring"

Class UserController
    # Properties
    oUser
    
    func init
        oUser = new User()
    
    func index
        # Get all users
        aUsers = oUser.all()
        return view("users/index", ["users" = aUsers])
    
    func show nId
        # Get specific user
        oUserData = oUser.find(nId)
        if oUserData = null {
            return redirect("/users").withError("user_not_found", "User not found")
        }
        return view("users/show", ["user" = oUserData])
    
    func create
        return view("users/create")
    
    func store
        # Validate request
        aRules = [
            "name" = "required|min:3",
            "email" = "required|email|unique:users",
            "password" = "required|min:6"
        ]
        
        if not validate(aRules) {
            return redirect("/users/create")
                   .withErrors(getValidationErrors())
                   .withInput()
        }
        
        # Create user
        oNewUser = oUser.create([
            "name" = request("name"),
            "email" = request("email"),
            "password" = hash(request("password"))
        ])
        
        return redirect("/users")
               .withSuccess("user_created", "User created successfully")
    
    func edit nId
        oUserData = oUser.find(nId)
        if oUserData = null {
            return redirect("/users").withError("user_not_found", "User not found")
        }
        return view("users/edit", ["user" = oUserData])
    
    func update nId
        # Validate request
        aRules = [
            "name" = "required|min:3",
            "email" = "required|email|unique:users," + nId
        ]
        
        if not validate(aRules) {
            return redirect("/users/" + nId + "/edit")
                   .withErrors(getValidationErrors())
                   .withInput()
        }
        
        # Update user
        oUser.update(nId, [
            "name" = request("name"),
            "email" = request("email")
        ])
        
        return redirect("/users")
               .withSuccess("user_updated", "User updated successfully")
    
    func delete nId
        oUser.delete(nId)
        return redirect("/users")
               .withSuccess("user_deleted", "User deleted successfully")
