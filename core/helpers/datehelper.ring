# ======================================
# RingWeb Framework
# Date Helper Functions
# ======================================

Package System.RingWeb

Class DateHelper

    # Format date
    func format cDate, cFormat
        oDate = date(cDate)
        
        # Replace format tokens
        cResult = cFormat
        cResult = substr(cResult, "Y", string(oDate.year))
        cResult = substr(cResult, "m", right("0" + oDate.month, 2))
        cResult = substr(cResult, "d", right("0" + oDate.day, 2))
        cResult = substr(cResult, "H", right("0" + oDate.hour, 2))
        cResult = substr(cResult, "i", right("0" + oDate.minute, 2))
        cResult = substr(cResult, "s", right("0" + oDate.second, 2))
        
        return cResult
    
    # Get difference between dates in days
    func diffInDays cDate1, cDate2
        oDate1 = date(cDate1)
        oDate2 = date(cDate2)
        return ceil((oDate2 - oDate1) / 86400)
    
    # Add days to date
    func addDays cDate, nDays
        oDate = date(cDate)
        return oDate + (nDays * 86400)
    
    # Subtract days from date
    func subDays cDate, nDays
        return addDays(cDate, -nDays)
    
    # Check if date is in the future
    func isFuture cDate
        return date(cDate) > date()
    
    # Check if date is in the past
    func isPast cDate
        return date(cDate) < date()
    
    # Get start of day
    func startOfDay cDate
        oDate = date(cDate)
        oDate.hour = 0
        oDate.minute = 0
        oDate.second = 0
        return oDate
    
    # Get end of day
    func endOfDay cDate
        oDate = date(cDate)
        oDate.hour = 23
        oDate.minute = 59
        oDate.second = 59
        return oDate
    
    # Get readable time ago
    func timeAgo cDate
        nDiff = diffInDays(cDate, date())
        
        if nDiff = 0 { return "Today" }
        if nDiff = 1 { return "Yesterday" }
        if nDiff < 7 { return string(nDiff) + " days ago" }
        if nDiff < 30 { return string(ceil(nDiff/7)) + " weeks ago" }
        if nDiff < 365 { return string(ceil(nDiff/30)) + " months ago" }
        return string(ceil(nDiff/365)) + " years ago"
