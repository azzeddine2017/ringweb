# ======================================
# RingWeb Framework
# Application Core Class
# ======================================

Package System.RingWeb

Class Application

    # Framework components
    oRouter 
    oRequest
    oResponse
    oSession
    oDB
    oErrorHandler
    oCache
    oAutoloader
    oTranslator
    
    # Configuration
    aConfig = []
    
    # Application state
    bDebugMode = false
    cEnvironment = "development"
    
    func init
        # Initialize autoloader
        oAutoloader = new Autoloader()
        
        # Initialize core components
        oRouter = new Router()
        oRequest = new Request()
        oResponse = new Response()
        oSession = new Session()
        oDB = new Database()
        oErrorHandler = new ErrorHandler()
        oCache = new CacheManager()
        oTranslator = new Translator()
        
        # Load configuration
        loadConfig()
        
        # Set error handler debug mode
        oErrorHandler.setDebugMode(bDebugMode)
        
        # Configure cache driver
        if aConfig[:cache] != null {
            oCache.setDriver(aConfig[:cache][:driver])
        }
        
        # Configure locale
        if aConfig[:locale] != null {
            oTranslator.setLocale(aConfig[:locale])
        }
        if aConfig[:fallback_locale] != null {
            oTranslator.setFallbackLocale(aConfig[:fallback_locale])
        }
        
        # Register additional namespaces from config
        if aConfig[:autoload] != null {
            for item in aConfig[:autoload] {
                oAutoloader.registerNamespace(item[1], item[2])
            }
        }
    
    func loadConfig
        # Load configuration files
        try {
            cContent = read("config/app.json")
            aConfig = json2list(cContent)
            bDebugMode = aConfig[:debug]
            cEnvironment = aConfig[:environment]
        catch
            ? "Warning: Configuration file not found, using defaults"
        }
    
    func run
        # Main application loop
        while true {
            # Handle request
            cRequest = oRequest.parse()
            
            # Find route
            oRoute = oRouter.match(cRequest)
            
            if oRoute != null {
                # Execute middleware
                if executeMiddleware(oRoute) {
                    # Execute controller
                    executeController(oRoute)
                }
            else
                # Route not found
                oResponse.setStatus(404)
                oResponse.setContent("404 - Page Not Found")
            }
            
            # Send response
            oResponse.send()
        }
    
    # Handle application error
    func handleError nCode, cMessage, cFile, nLine
        oErrorHandler.handleError(nCode, cMessage, cFile, nLine)
    
    # Handle exception
    func handleException oException
        oErrorHandler.handleException(oException)
    
    private
        # Execute middleware chain
        func executeMiddleware oRoute
            for oMiddleware in oRoute.getMiddleware() {
                if not oMiddleware.handle(oRequest, oResponse) {
                    return false
                }
            }
            return true
        
        # Execute controller action
        func executeController oRoute
            try {
                oController = new oRoute.getController()
                cAction = oRoute.getAction()
                oController { cAction() }
            catch
                if bDebugMode {
                    oResponse.setContent("Error: " + cCatchError)
                else
                    oResponse.setContent("Internal Server Error")
                }
                oResponse.setStatus(500)
            }
