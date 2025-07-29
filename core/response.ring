# ======================================
# RingWeb Framework
# HTTP Response Handler Class
# ======================================

Package System.RingWeb

Class Response
    # Response properties
    nStatus = 200
    cContent = ""
    aHeaders = []
    aCookies = []
    
    func init
        # Set default headers
        addHeader("Content-Type", "text/html; charset=UTF-8")
    
    # Set response status code
    func setStatusCode nCode
        nStatus = nCode
    
    # Set response content
    func setResponseContent cData
        cContent = cData
    
    # Add response header
    func addHeader cName, cValue
        aHeaders[cName] = cValue
    
    # Set cookie
    func cookie cName, cValue, nExpire, cPath, cDomain, bSecure, bHttpOnly
        aCookies + [
            "name" = cName,
            "value" = cValue,
            "expire" = nExpire,
            "path" = cPath,
            "domain" = cDomain,
            "secure" = bSecure,
            "httponly" = bHttpOnly
        ]
    
    # Send the response
    func send
        # Send status code
        sendStatus()
        
        # Send headers
        sendHeaders()
        
        # Send cookies
        sendCookies()
        
        # Send content
        ? cContent
    
    private
        # Send HTTP status code
        func sendStatus
            switch nStatus
                case 200 cStatus = "200 OK"
                case 201 cStatus = "201 Created"
                case 301 cStatus = "301 Moved Permanently"
                case 302 cStatus = "302 Found"
                case 400 cStatus = "400 Bad Request"
                case 401 cStatus = "401 Unauthorized"
                case 403 cStatus = "403 Forbidden"
                case 404 cStatus = "404 Not Found"
                case 500 cStatus = "500 Internal Server Error"
                case 503 cStatus = "503 Service Unavailable"
                other cStatus = "200 OK"
            off
            
            addHeader("HTTP/1.1 " + cStatus)
        
        # Send response headers
        func sendHeaders
            for cName, cValue in aHeaders {
                addHeader(cName + ": " + cValue)
            }
        
        # Send cookies
        func sendCookies
            for aCookie in aCookies {
                cHeader = "Set-Cookie: " + aCookie["name"] + "=" + aCookie["value"]
                
                if aCookie["expire"] != null {
                    cHeader += "; expires=" + date2cookie(aCookie["expire"])
                }
                
                if aCookie["path"] != null {
                    cHeader += "; path=" + aCookie["path"]
                }
                
                if aCookie["domain"] != null {
                    cHeader += "; domain=" + aCookie["domain"]
                }
                
                if aCookie["secure"] {
                    cHeader += "; secure"
                }
                
                if aCookie["httponly"] {
                    cHeader += "; HttpOnly"
                }
                
                addHeader(cHeader)
            }
