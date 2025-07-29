# ======================================
# RingWeb Framework
# Security Middleware Class
# ======================================

Package System.RingWeb

Class SecurityMiddleware
    # Security properties
    aConfig = []
    
    func init
        # Load security configuration
        loadConfig()
    
    # Process request through security middleware
    func process oRequest, oResponse
        # Apply security headers
        applySecurityHeaders(oResponse)
        
        # Check CSRF token for POST requests
        if oRequest.getMethod() = "POST" {
            if not validateCsrfToken(oRequest) {
                oResponse.setStatus(403)
                return false
            }
        }
        
        # Check rate limiting
        if not checkRateLimit(oRequest) {
            oResponse.setStatus(429)
            return false
        }
        
        return true
    
    private
        # Load security configuration
        func loadConfig
            aConfig = Application.aConfig["security"]
        
        # Apply security headers
        func applySecurityHeaders oResponse
            # X-Frame-Options to prevent clickjacking
            oResponse.header("X-Frame-Options", "SAMEORIGIN")
            
            # X-XSS-Protection
            oResponse.header("X-XSS-Protection", "1; mode=block")
            
            # X-Content-Type-Options
            oResponse.header("X-Content-Type-Options", "nosniff")
            
            # Strict-Transport-Security
            if aConfig["hsts"] {
                oResponse.header("Strict-Transport-Security", 
                    "max-age=31536000; includeSubDomains")
            }
            
            # Content-Security-Policy
            if aConfig["csp"] {
                oResponse.header("Content-Security-Policy", 
                    "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';")
            }
        
        # Validate CSRF token
        func validateCsrfToken oRequest
            cToken = oRequest.post("_token")
            cStoredToken = session.get("_token")
            
            if cToken = null or cStoredToken = null {
                return false
            }
            
            return cToken = cStoredToken
        
        # Generate CSRF token
        func generateCsrfToken
            cToken = generateRandomString(40)
            session.set("_token", cToken)
            return cToken
        
        # Check rate limiting
        func checkRateLimit oRequest
            cIp = oRequest.getIp()
            cKey = "ratelimit:" + cIp
            
            nHits = number(session.get(cKey))
            nLimit = aConfig["rateLimit"]
            
            if nHits >= nLimit {
                return false
            }
            
            session.set(cKey, nHits + 1)
            return true
        
        # Generate random string
        func generateRandomString nLength
            cChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            cResult = ""
            
            for i = 1 to nLength {
                nRand = random(len(cChars)) + 1
                cResult += substr(cChars, nRand, 1)
            }
            
            return cResult
