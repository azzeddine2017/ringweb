# ======================================
# RingWeb Framework
# Database Manager Class
# ======================================

Package System.RingWeb

Class Database
    # Database connection
    oConnection = null
    
    # Configuration
    cDriver = "mysql"
    cHost = "localhost"
    cDatabase = ""
    cUsername = ""
    cPassword = ""
    nPort = 3306
    
    # Query logging
    bLogQueries = false
    aQueryLog = []
    
    func init
        # Load database configuration
        loadConfig()
        
        # Establish connection
        connect()
    
    # Execute a query and return result
    func query cSQL, aParams
        if bLogQueries {
            logQuery(cSQL, aParams)
        }
        
        try {
            oStmt = oConnection.prepare(cSQL)
            bindParameters(oStmt, aParams)
            oResult = oStmt.execute()
            return fetchResults(oResult)
        catch
            logError(cCatchError)
            return null
        }
    
    # Execute a query without returning result
    func execute cSQL, aParams
        if bLogQueries {
            logQuery(cSQL, aParams)
        }
        
        try {
            oStmt = oConnection.prepare(cSQL)
            bindParameters(oStmt, aParams)
            return oStmt.execute()
        catch
            logError(cCatchError)
            return false
        }
    
    # Begin a transaction
    func beginTransaction
        return oConnection.autocommit(false)
    
    # Commit a transaction
    func commit
        return oConnection.commit()
    
    # Rollback a transaction
    func rollback
        return oConnection.rollback()
    
    # Get last insert ID
    func lastInsertId
        return oConnection.lastInsertId()
    
    private
        # Load database configuration
        func loadConfig
            try {
                aConfig = Application.aConfig["database"]
                cDriver = aConfig["driver"]
                cHost = aConfig["host"]
                cDatabase = aConfig["database"]
                cUsername = aConfig["username"]
                cPassword = aConfig["password"]
                if aConfig["port"] != null {
                    nPort = aConfig["port"]
                }
            catch
                ? "Warning: Database configuration not found"
            }
        
        # Establish database connection
        func connect
            try {
                oConnection = mysql_connect(cHost, cUsername, cPassword, cDatabase, nPort)
                if oConnection = null {
                    raise("Failed to connect to database")
                }
            catch
                raise("Database connection error: " + cCatchError)
            }
        
        # Bind parameters to prepared statement
        func bindParameters oStmt, aParams
            if len(aParams) > 0 {
                for i = 1 to len(aParams) {
                    oStmt.bind_param(i, aParams[i])
                }
            }
        
        # Fetch results from query
        func fetchResults oResult
            aResults = []
            while oRow = oResult.fetch_assoc() {
                aResults + oRow
            }
            return aResults
        
        # Log query for debugging
        func logQuery cSQL, aParams
            aQueryLog + [
                "sql" = cSQL,
                "params" = aParams,
                "time" = date()
            ]
        
        # Log database error
        func logError cError
            if Application.bDebugMode {
                ? "Database Error: " + cError
            }
            # Log to file or error reporting service
