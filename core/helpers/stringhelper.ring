# ======================================
# RingWeb Framework
# String Helper Functions
# ======================================

Package System.RingWeb

Class StringHelper

    # Convert string to slug
    func slugify cStr
        cStr = lower(cStr)
        cStr = replaceSpecialChars(cStr)
        cStr = substr(cStr, " ", "-")
        cStr = substr(cStr, "--", "-")
        return trim(cStr)
    
    # Convert string to camel case
    func camelCase cStr
        aWords = split(cStr, " ")
        cResult = lower(aWords[1])
        
        for i = 2 to len(aWords) {
            cResult += upper(left(aWords[i], 1)) + 
                      lower(substr(aWords[i], 2))
        }
        
        return cResult
    
    # Convert string to snake case
    func snakeCase cStr
        cResult = ""
        for i = 1 to len(cStr) {
            if isUpper(substr(cStr, i, 1)) {
                if i > 1 { cResult += "_" }
                cResult += lower(substr(cStr, i, 1))
            else
                cResult += substr(cStr, i, 1)
            }
        }
        return cResult
    
    # Limit string length with ellipsis
    func truncate cStr, nLength
        if len(cStr) <= nLength { return cStr }
        return left(cStr, nLength - 3) + "..."
    
    # Generate random string
    func randomString nLength
        cChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        cResult = ""
        for i = 1 to nLength {
            nRand = random(len(cChars)) + 1
            cResult += substr(cChars, nRand, 1)
        }
        return cResult
    
    private
        # Replace special characters
        func replaceSpecialChars cStr
            aReplacements = [
                "á"="a", "à"="a", "ã"="a", "â"="a", "ä"="a",
                "é"="e", "è"="e", "ê"="e", "ë"="e",
                "í"="i", "ì"="i", "î"="i", "ï"="i",
                "ó"="o", "ò"="o", "õ"="o", "ô"="o", "ö"="o",
                "ú"="u", "ù"="u", "û"="u", "ü"="u",
                "ý"="y", "ÿ"="y",
                "ñ"="n",
                " "="_", " "="_", ","  ="", "."="", "!"="", "?"="", 
                "("="", ")"="", "["="", "]"="", "{"="", "}"="", 
                "'"="", '\"'="", ":"="", ";"="", "/"="-"
            ]
            
            for cChar = 1 to len(aReplacements) {
                cStr = substr(cStr, aReplacements[cChar][1], aReplacements[cChar][2])
            }
            return cStr
