# ======================================
# RingWeb Framework
# Router Class
# ======================================

Package System.RingWeb

Class Router
    # Route collections
    aRoutes = []
    aMiddleware = []
    
    # Current route parameters
    aParams = []
    
    func init
        # Initialize routes array with common HTTP methods
        aRoutes = [
            "GET" = [],
            "POST" = [],
            "PUT" = [],
            "DELETE" = []
        ]
    
    # Add a new route
    func addRoute cMethod, cPath, cController, cAction
        aRoutes[upper(cMethod)] + [
            "path" = cPath,
            "controller" = cController,
            "action" = cAction,
            "middleware" = []
        ]
        return self
    
    # Shorthand methods for common HTTP verbs
    func addGet cPath, cController, cAction
        return addRoute("GET", cPath, cController, cAction)
    
    func addPost cPath, cController, cAction
        return addRoute("POST", cPath, cController, cAction)
    
    func addPut cPath, cController, cAction
        return addRoute("PUT", cPath, cController, cAction)
    
    func addDelete cPath, cController, cAction
        return addRoute("DELETE", cPath, cController, cAction)
    
    # Add middleware to the last added route
    func addMiddleware cMiddleware
        if len(aRoutes[cCurrentMethod]) > 0 {
            aLastRoute = aRoutes[cCurrentMethod][len(aRoutes[cCurrentMethod])]
            aLastRoute["middleware"] + cMiddleware
        }
        return self
    
    # Match the current request to a route
    func matchRoute oRequest
        cMethod = upper(oRequest.getRequestMethod())
        cPath = oRequest.getRequestPath()
        
        # Search for matching route
        for route in aRoutes[cMethod] {
            if matchPath(route["path"], cPath) {
                return new Route(route)
            }
        }
        return null
    
    private
        # Match route path with parameters
        func matchPath cRoutePath, cRequestPath
            aRouteParts = split(cRoutePath, "/")
            aRequestParts = split(cRequestPath, "/")
            
            if len(aRouteParts) != len(aRequestParts) {
                return false
            }
            
            aParams = []  # Reset parameters
            
            for i = 1 to len(aRouteParts) {
                if left(aRouteParts[i], 1) = ":" {
                    # Parameter
                    aParams + [
                        substr(aRouteParts[i], 2) = aRequestParts[i]
                    ]
                else
                    # Static segment
                    if aRouteParts[i] != aRequestParts[i] {
                        return false
                    }
                }
            }
            
            return true
