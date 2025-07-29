# ======================================
# RingWeb Framework
# Translator Class
# ======================================

Package System.RingWeb

Class Translator
    # Properties
    cCurrentLocale = "en"     # Default locale
    cFallbackLocale = "en"    # Fallback locale
    aTranslations = []        # Loaded translations
    
    func init
        # Initialize translations list
        aTranslations = []
        # Load default translations
        loadTranslations(cCurrentLocale)
    
    # Set current locale
    func setLocale cLocale
        cCurrentLocale = cLocale
        loadTranslations(cLocale)
        return self
    
    # Get current locale
    func getLocale
        return cCurrentLocale
    
    # Set fallback locale
    func setFallbackLocale cLocale
        cFallbackLocale = cLocale
        return self
    
    # Get translation
    func getText cKey
        aVars = []  # Create empty list for variables
        return getTextWithVars(cKey, aVars)
    
    # Get translation with replacements
    func getTextWithVars cKey, aVars
        if aVars = NULL { aVars = [] }
        
        # Split key into parts (e.g., "messages.welcome")
        aParts = splitString(cKey, ".")
        
        # Get translation from current locale
        xValue = getTransValue(aParts, aTranslations[cCurrentLocale])
        
        # If not found, try fallback locale
        if xValue = null and cCurrentLocale != cFallbackLocale {
            xValue = getTransValue(aParts, aTranslations[cFallbackLocale])
        }
        
        # If still not found, return the key
        if xValue = null { return cKey }
        
        # Replace placeholders
        return replaceVars(xValue, aVars)
    
    # Load translations for a locale
    func loadTranslations cLocale
        cPath = "resources/lang/" + cLocale + ".json"
        
        if not fexists(cPath) { return false }
        
        try {
            cContent = read(cPath)
            aTranslations[cLocale] = json2list(cContent)
            return true
        catch
            return false
        }
    
    private
        # Get nested translation value
        func getTransValue aParts, aData
            if aData = null { return null }
            
            xCurrent = aData
            for cPart in aParts {
                if type(xCurrent) != "LIST" { return null }
                xCurrent = xCurrent[cPart]
                if xCurrent = null { return null }
            }
            
            return xCurrent
        
        # Replace placeholders in translation
        func replaceVars cText, aVars
            if aVars = NULL or len(aVars) = 0 { return cText }
            
            for aVar in aVars {
                cText = substr(cText, ":" + aVar[1], string(aVar[2]))
            }
            
            return cText
        
        # Convert string to list using separator
        func splitString cStr, cSep
            aResult = []
            nStart = 1
            nPos = substr(cStr, cSep)
            
            while nPos > 0 {
                add(aResult, substr(cStr, nStart, nPos - nStart))
                nStart = nPos + len(cSep)
                nPos = substr(cStr, cSep, nStart)
            }
            
            add(aResult, substr(cStr, nStart))
            return aResult
