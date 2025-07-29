# ======================================
# RingWeb Framework
# HTTP Request Handler Class
# ======================================

Package System.RingWeb

Class Request
    # Request data
    cMethod = ""
    cPath = ""
    aGet = []
    aPost = []
    aFiles = []
    aHeaders = []
    aCookies = []
    
    func init
        parseRequest()
    
    # Get request method
    func getRequestMethod
        return cMethod
    
    # Get request path
    func getRequestPath
        return cPath
    
    # Get query parameter
    func getQuery cKey
        return aGet[cKey]
    
    # Get post data
    func getPost cKey
        return aPost[cKey]
    
    # Get uploaded file
    func getUploadedFile cKey
        return aFiles[cKey]
    
    # Get request header
    func getHeader cName
        return aHeaders[cName]
    
    # Get cookie value
    func cookie cName
        return aCookies[cName]
    
    # Check if request is AJAX
    func isAjax
        return getHeader("X-Requested-With") = "XMLHttpRequest"
    
    # Get client IP address
    func getIp
        return getenv("REMOTE_ADDR")
    
    # Get user agent
    func getUserAgent
        return getHeader("User-Agent")
    
    private
        # Parse incoming request
        func parseRequest
            # Get request method
            cMethod = getenv("REQUEST_METHOD")
            
            # Get request path
            cPath = getenv("PATH_INFO")
            if cPath = null { cPath = "/" }
            
            # Parse query string
            parseQueryString()
            
            # Parse post data
            if cMethod = "POST" {
                parsePostData()
            }
            
            # Parse headers
            parseHeaders()
            
            # Parse cookies
            parseCookies()
        
        # Parse query string parameters
        func parseQueryString
            cQuery = getenv("QUERY_STRING")
            if cQuery != null {
                aParams = str2list(cQuery)
                for cParam in aParams {
                    aPair = split(cParam, "=")
                    if len(aPair) = 2 {
                        aGet[aPair[1]] = urlDecode(aPair[2])
                    }
                }
            }
        
        # Parse POST data
        func parsePostData
            cContentType = getenv("CONTENT_TYPE")
            if substr(cContentType, "multipart/form-data") = 1 {
                parseMultipartData()
            else
                parseUrlEncodedData()
            }
        
        # Parse multipart form data (file uploads)
        func parseMultipartData
            # Implementation for handling file uploads
            # This requires careful handling of multipart boundaries
            # and proper file storage
        
        # Parse URL encoded POST data
        func parseUrlEncodedData
            cInput = getStandardInput()
            aParams = str2list(cInput)
            for cParam in aParams {
                aPair = split(cParam, "=")
                if len(aPair) = 2 {
                    aPost[aPair[1]] = urlDecode(aPair[2])
                }
            }
        
        # Parse request headers
        func parseHeaders
            for cKey in getenv() {
                if substr(cKey, "HTTP_") = 1 {
                    cName = proper(substr(cKey, 6))
                    cName = substr(cName, "_", "-")
                    aHeaders[cName] = getenv(cKey)
                }
            }
        
        # Parse cookies
        func parseCookies
            cCookie = getenv("HTTP_COOKIE")
            if cCookie != null {
                aPairs = split(cCookie, ";")
                for cPair in aPairs {
                    aPair = split(trim(cPair), "=")
                    if len(aPair) = 2 {
                        aCookies[aPair[1]] = aPair[2]
                    }
                }
            }
