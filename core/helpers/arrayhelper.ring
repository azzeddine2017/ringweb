# ======================================
# RingWeb Framework
# Array Helper Functions
# ======================================

Package System.RingWeb

Class ArrayHelper

    # Get first element that matches condition
    func first aList, fpCallback
        for item in aList {
            if call fpCallback(item) { return item }
        }
        return null
    
    # Get last element that matches condition
    func last aList, fpCallback
        for i = len(aList) to 1 step -1 {
            if call fpCallback(aList[i]) { return aList[i] }
        }
        return null
    
    # Filter array elements
    func filter aList, fpCallback
        aResult = []
        for item in aList {
            if call fpCallback(item) {
                add(aResult, item)
            }
        }
        return aResult
    
    # Map array elements
    func map aList, fpCallback
        aResult = []
        for item in aList {
            add(aResult, call fpCallback(item))
        }
        return aResult
    
    # Reduce array to single value
    func reduce aList, fpCallback, xInitial
        xResult = xInitial
        for item in aList {
            xResult = call fpCallback(xResult, item)
        }
        return xResult
    
    # Group array by key
    func groupBy aList, cKey
        aResult = []
        for item in aList {
            cGroup = item[cKey]
            if aResult[cGroup] = null { aResult[cGroup] = [] }
            add(aResult[cGroup], item)
        }
        return aResult
    
    # Sort array by key
    func sortBy aList, cKey
        return sort(aList, func(x, y) {
            return x[cKey] <= y[cKey]
        })
    
    # Check if array contains value
    func contains aList, xValue
        for item in aList {
            if item = xValue { return true }
        }
        return false
    
    # Get array difference
    func difference aList1, aList2
        aResult = []
        for item in aList1 {
            if not contains(aList2, item) {
                add(aResult, item)
            }
        }
        return aResult
    
    # Get array intersection
    func intersection aList1, aList2
        aResult = []
        for item in aList1 {
            if contains(aList2, item) {
                add(aResult, item)
            }
        }
        return aResult
