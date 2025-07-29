# ======================================
# RingWeb Framework
# Base Controller Class
# ======================================

Package System.RingWeb

Class Controller
    # Framework components
    oRequest = null
    oResponse = null
    oSession = null
    oView = null
    
    # Controller properties
    cLayout = "default"
    aMiddleware = []
    
    func init
        # Get framework components
        oRequest = Application.oRequest
        oResponse = Application.oResponse
        oSession = Application.oSession
        oView = new View()
        
        # Set default view path
        oView.setViewPath(getViewPath())
    
    # Render view with data
    func view cView, aData
        try {
            if cLayout != null {
                # Render with layout
                cContent = oView.renderView(cView, aData)
                return oView.renderLayout(cLayout, cContent)
            else
                # Render view only
                return oView.renderView(cView, aData)
            }
        catch
            log("View Error: " + cCatchError)
            return "Error loading view: " + cView
        }
    
    # JSON response
    func json aData
        oResponse.setHeader("Content-Type", "application/json")
        return JSONString(aData)
    
    # Redirect to another route
    func redirect cPath
        oResponse.setHeader("Location", cPath)
        oResponse.setStatus(302)
    
    # Get view path for this controller
    private
        func getViewPath
            # Convert controller name to view path
            # Example: UserController -> views/user/
            cName = className(self)
            cName = substr(cName, 1, len(cName)-10)  # Remove "Controller"
            return "views/" + lower(cName) + "/"
