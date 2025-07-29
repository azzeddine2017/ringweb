# ======================================
# RingWeb Framework
# Session Management Class
# ======================================

Package System.RingWeb

Class Session
    # Session properties
    cSessionId = ""
    cSessionPath = "temp/sessions/"
    nLifetime = 3600  # 1 hour
    
    func init
        # Create sessions directory if not exists
        if not dirExists(cSessionPath) {
            System("mkdir " + cSessionPath)
        }
        
        # Start session handling
        startSession()
    
    # Get session value
    func getValue cKey
        cFile = getSessionFile()
        if fExists(cFile) {
            aData = loadSessionData()
            return aData[cKey]
        }
        return null
    
    # Set session value
    func setValue cKey, xValue
        aData = loadSessionData()
        aData[cKey] = xValue
        saveSessionData(aData)
    
    # Remove session value
    func remove cKey
        aData = loadSessionData()
        del(aData, cKey)
        saveSessionData(aData)
    
    # Clear all session data
    func clear
        cFile = getSessionFile()
        if fExists(cFile) {
            remove(cFile)
        }
    
    # Check if session key exists
    func has cKey
        aData = loadSessionData()
        return aData[cKey] != null
    
    # Regenerate session ID
    func regenerate
        clear()
        cSessionId = generateSessionId()
        cookie("RINGSESSID", cSessionId, time() + nLifetime, "/")
    
    private
        # Start session handling
        func startSession
            cSessionId = request.cookie("RINGSESSID")
            if cSessionId = null {
                cSessionId = generateSessionId()
            }
            
            if not validateSession() {
                cSessionId = generateSessionId()
            }
            
            response.cookie("RINGSESSID", cSessionId, time() + nLifetime, "/")
        
        # Generate new session ID
        func generateSessionId
            cHash = md5(time() + rand(1000000))
            return substr(cHash, 1, 32)
        
        # Validate current session
        func validateSession
            cFile = getSessionFile()
            if not fExists(cFile) { return false }
            
            nFileTime = fTime(cFile)
            if time() - nFileTime > nLifetime {
                remove(cFile)
                return false
            }
            
            return true
        
        # Get session file path
        func getSessionFile
            return cSessionPath + cSessionId + ".session"
        
        # Load session data from file
        func loadSessionData
            cFile = getSessionFile()
            if fExists(cFile) {
                cContent = read(cFile)
                try {
                    return json2list(cContent)
                catch
                    return []
                }
            }
            return []
        
        # Save session data to file
        func saveSessionData aData
            cFile = getSessionFile()
            write(cFile, list2json(aData))
