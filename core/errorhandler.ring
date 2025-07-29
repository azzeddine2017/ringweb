# ======================================
# RingWeb Framework
# Error Handler Class
# ======================================

Package System.RingWeb

Class ErrorHandler
    # Error properties
    cLogPath = "storage/logs/"
    cErrorViewPath = "views/errors/"
    bDebugMode = false
    
    # Error types
    aErrorTypes = [
        404 = "Not Found",
        500 = "Internal Server Error",
        403 = "Forbidden",
        401 = "Unauthorized",
        400 = "Bad Request",
        422 = "Unprocessable Entity"
    ]
    
    func init
        # Create logs directory if not exists
        if not dirExists(cLogPath) {
            System("mkdir " + cLogPath)
        }
    
    # Handle application error
    func handleError nCode, cMessage, cFile, nLine
        # Log error
        logError(nCode, cMessage, cFile, nLine)
        
        # Show error page or JSON response
        if isAjaxRequest() {
            showJsonError(nCode, cMessage)
        else
            showErrorPage(nCode, cMessage)
        }
    
    # Handle exception
    func handleException oException
        handleError(500, oException.getMessage(), 
                   oException.getFile(), oException.getLine())
    
    # Set debug mode
    func setDebugMode bMode
        bDebugMode = bMode
        return self
    
    # Show error page
    func showErrorPage nCode, cMessage
        oResponse = new Response()
        oResponse.setStatusCode(nCode)
        
        cViewFile = cErrorViewPath + nCode + ".ring"
        if not fExists(cViewFile) {
            cViewFile = cErrorViewPath + "default.ring"
        }
        
        oView = new View()
        cContent = oView.renderView(cViewFile, [
            "code" = nCode,
            "message" = cMessage,
            "debug" = bDebugMode
        ])
        
        oResponse.setResponseContent(cContent)
        oResponse.send()
    
    # Show JSON error
    func showJsonError nCode, cMessage
        oResponse = new Response()
        oResponse.setStatusCode(nCode)
        oResponse.addHeader("Content-Type", "application/json")
        
        cJson = list2json([
            "error" = true,
            "code" = nCode,
            "message" = cMessage
        ])
        
        oResponse.setResponseContent(cJson)
        oResponse.send()
    
    private
        # Log error to file
        func logError nCode, cMessage, cFile, nLine
            cDate = date()
            cTime = time()
            cLogFile = cLogPath + "error-" + substr(cDate, "-", "") + ".log"
            
            cLog = "
                [" + cDate + " " + cTime + "]
                Code: " + nCode + "
                Message: " + cMessage + "
                File: " + cFile + "
                Line: " + nLine + "
                ----------------------------------------
            "
            
            write(cLogFile, cLog)
        
        # Check if request is AJAX
        func isAjaxRequest
            oRequest = new Request()
            return oRequest.isAjax()
