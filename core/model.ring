# ======================================
# RingWeb Framework
# Base Model Class
# ======================================

Package System.RingWeb

Class Model
    # Database connection
    oDB 
    
    # Table information
    cTable = ""        # Table name
    cPrimaryKey = "id" # Primary key field
    
    # Relationships
    aRelations = []
    
    # Query builder properties
    aSelect = ["*"]
    aWhere = []
    aOrderBy = []
    nLimit = 0
    nOffset = 0
    
    func init
        # Get database connection from application
        oDB = Application.oDB
        
        # Set default table name if not specified
        if cTable = "" {
            cTable = lower(className(self))
        }
    
    # Basic CRUD Operations
    
    func findById nId
        return oDB.query("SELECT * FROM " + cTable + " WHERE " + cPrimaryKey + " = ?", [nId])
    
    func findAll
        return oDB.query("SELECT * FROM " + cTable)
    
    func createRecord aData
        # Generate column names and values
        cColumns = ""
        cValues = ""
        aParams = []
        
        for item in aData {
            if cColumns != "" {
                cColumns += ","
                cValues += ","
            }
            cColumns += item[1]
            cValues += "?"
            aParams + item[2]
        }
        
        cSQL = "INSERT INTO " + cTable + " (" + cColumns + ") VALUES (" + cValues + ")"
        return oDB.execute(cSQL, aParams)
    
    func updateRecord nId, aData
        cSet = ""
        aParams = []
        
        for item in aData {
            if cSet != "" {
                cSet += ","
            }
            cSet += item[1] + " = ?"
            aParams + item[2]
        }
        
        aParams + nId
        
        cSQL = "UPDATE " + cTable + " SET " + cSet + " WHERE " + cPrimaryKey + " = ?"
        return oDB.execute(cSQL, aParams)
    
    func deleteRecord nId
        return oDB.execute("DELETE FROM " + cTable + " WHERE " + cPrimaryKey + " = ?", [nId])
    
    # Query Builder Methods
    
    func selectColumns vColumns
        if type(vColumns) = "LIST" {
            aSelect = vColumns
        else
            aSelect = [vColumns]
        }
        return self
    
    func whereCondition cColumn, cOperator, xValue
        aWhere + [cColumn, cOperator, xValue]
        return self
    
    func orderByColumn cColumn, cDirection
        aOrderBy + [cColumn, cDirection]
        return self
    
    func limitRecords nValue
        nLimit = nValue
        return self
    
    func offsetRecords nValue
        nOffset = nValue
        return self
    
    func getRecords
        cSQL = "SELECT " + substr(aSelect, ",")
        cSQL += " FROM " + cTable
        
        # Add WHERE conditions
        if len(aWhere) > 0 {
            cSQL += " WHERE "
            for i = 1 to len(aWhere) step 3 {
                if i > 1 { cSQL += " AND " }
                cSQL += aWhere[i] + " " + aWhere[i+1] + " ?"
            }
        }
        
        # Add ORDER BY
        if len(aOrderBy) > 0 {
            cSQL += " ORDER BY "
            for i = 1 to len(aOrderBy) step 2 {
                if i > 1 { cSQL += ", " }
                cSQL += aOrderBy[i] + " " + aOrderBy[i+1]
            }
        }
        
        # Add LIMIT and OFFSET
        if nLimit > 0 {
            cSQL += " LIMIT " + nLimit
            if nOffset > 0 {
                cSQL += " OFFSET " + nOffset
            }
        }
        
        return oDB.query(cSQL, getWhereValues())
    
    private
        # Extract values from WHERE conditions
        func getWhereValues
            aValues = []
            for i = 3 to len(aWhere) step 3 {
                aValues + aWhere[i]
            }
            return aValues
