load "model.ring"
load "../models/user.ring"

class Auth
    
    
    # Singleton pattern
    func init
        return null
    
    func self() 
        if oInstance = NULL
            oInstance = new Auth
        return oInstance
    
    # Get authenticated user
    func user
        return oUser
    
    # Check if user is authenticated
    func check
        return oUser != null
    
    # Get user by credentials
    func attempt(email, password)
        oUser = new User()
        user = oUser.where("email = ? AND password = ?", [email, hashPassword(password)]).first()
        if user
            oUser = user
            session("user_id", user.id)
            return true
        return false
    
    # Login user by ID
    func loginUsingId(id)
        oUser = new User().find(id)
        if oUser
            session("user_id", oUser.id)
            return true
        return false
    
    # Logout current user
    func logout
        oUser = null
        session("user_id", null)
    
    # Initialize auth from session
    func initFromSession
        if session("user_id")
            loginUsingId(session("user_id"))
        return self()
    

    private  

    oInstance
    oUser 
    # Hash password using SHA256
    func hashPassword(password)
        load "openssl.ring"
        return SHA256(password)
