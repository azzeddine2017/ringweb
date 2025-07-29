# ======================================
# RingWeb Framework
# Authentication System Class
# ======================================

Package System.RingWeb

Class Auth
    # Auth properties
    oUser = null
    cUserModel = "User"
    cUsername = "email"
    cPassword = "password"
    
    func init
        # Check for logged in user
        checkAuth()
    
    # Attempt to log in a user
    func attempt cUsername, cPassword
        oModel = new cUserModel()
        oUser = oModel.whereCondition(cUsername, "=", cUsername)[1]
        
        if oUser != null {
            if verifyPassword(cPassword, oUser[cPassword]) {
                loginUser(oUser)
                return true
            }
        }
        
        return false
    
    # Log in a user
    func login oUserData
        loginUser(oUserData)
        return true
    
    # Log out the current user
    func logout
        session.remove("auth_user")
        oUser = null
    
    # Check if user is logged in
    func check
        return oUser != null
    
    # Get the current authenticated user
    func user
        return oUser
    
    # Get user ID
    func id
        if oUser != null {
            return oUser["id"]
        }
        return null
    
    private
        # Check for authenticated user in session
        func checkAuth
            aUser = session.getValue("auth_user")
            if aUser != null {
                oUser = aUser
            }
        
        # Login user and store in session
        func loginUser oUserData
            oUser = oUserData
            session.setValue("auth_user", oUserData)
        
        # Verify password hash
        func verifyPassword cPassword, cHash
            return checkHash(cPassword, cHash)
