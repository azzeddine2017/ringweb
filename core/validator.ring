# ======================================
# RingWeb Framework
# Form Validator Class
# ======================================

Package System.RingWeb

Class Validator
    # Validation properties
    aData = []
    aRules = []
    aErrors = []
    
    func init aInputData, aValidationRules
        aData = aInputData
        aRules = aValidationRules
    
    # Validate data against rules
    func validate
        aErrors = []
        
        for cField in aRules {
            for aFieldRules in aRules[cField] {
                for cRule in aFieldRules {
                    if not validateField(cField, cRule) {
                        return false
                    }
                }
            }
        }
        
        return len(aErrors) = 0
    
    # Get validation errors
    func getErrors
        return aErrors
    
    # Get first error message
    func getFirstError
        if len(aErrors) > 0 {
            return aErrors[1]
        }
        return ""
    
    private
        # Validate a single field
        func validateField cField, cRule
            aRuleParts = split(cRule, ":")
            cRuleType = aRuleParts[1]
            
            switch cRuleType {
                case "required"
                    if not required(cField) {
                        addError(cField, "The " + cField + " field is required")
                        return false
                    }
                
                case "email"
                    if not email(cField) {
                        addError(cField, "The " + cField + " must be a valid email address")
                        return false
                    }
                
                case "min"
                    nMin = number(aRuleParts[2])
                    if not min(cField, nMin) {
                        addError(cField, "The " + cField + " must be at least " + nMin)
                        return false
                    }
                
                case "max"
                    nMax = number(aRuleParts[2])
                    if not max(cField, nMax) {
                        addError(cField, "The " + cField + " must not exceed " + nMax)
                        return false
                    }
                
                case "between"
                    aRange = split(aRuleParts[2], ",")
                    if not between(cField, number(aRange[1]), number(aRange[2])) {
                        addError(cField, "The " + cField + " must be between " + aRange[1] + " and " + aRange[2])
                        return false
                    }
                
                case "numeric"
                    if not numeric(cField) {
                        addError(cField, "The " + cField + " must be numeric")
                        return false
                    }
                
                case "alpha"
                    if not alpha(cField) {
                        addError(cField, "The " + cField + " must only contain letters")
                        return false
                    }
                
                case "alphanumeric"
                    if not alphanumeric(cField) {
                        addError(cField, "The " + cField + " must only contain letters and numbers")
                        return false
                    }
            }
            
            return true
        
        # Add validation error
        func addError cField, cMessage
            aErrors + [cField, cMessage]
        
        # Required field validation
        func required cField
            return aData[cField] != null and len(aData[cField]) > 0
        
        # Email validation
        func email cField
            if not required(cField) { return true }
            cValue = aData[cField]
            return isEmail(cValue)
        
        # Minimum value validation
        func min cField, nMin
            if not required(cField) { return true }
            return len(string(aData[cField])) >= nMin
        
        # Maximum value validation
        func max cField, nMax
            if not required(cField) { return true }
            return len(string(aData[cField])) <= nMax
        
        # Between range validation
        func between cField, nMin, nMax
            if not required(cField) { return true }
            nValue = number(aData[cField])
            return nValue >= nMin and nValue <= nMax
        
        # Numeric validation
        func numeric cField
            if not required(cField) { return true }
            try {
                number(aData[cField])
                return true
            catch
                return false
            }
        
        # Alpha validation
        func alpha cField
            if not required(cField) { return true }
            cValue = aData[cField]
            for i = 1 to len(cValue) {
                if not isalpha(substr(cValue, i, 1)) {
                    return false
                }
            }
            return true
        
        # Alphanumeric validation
        func alphanumeric cField
            if not required(cField) { return true }
            cValue = aData[cField]
            for i = 1 to len(cValue) {
                if not isalnum(substr(cValue, i, 1)) {
                    return false
                }
            }
            return true
