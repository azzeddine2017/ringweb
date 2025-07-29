# ======================================
# RingWeb Framework
# Memory Cache Class
# ======================================

Package System.RingWeb

Class MemoryCache from CacheInterface
    # Cache storage
    aCache = []
    
    func init
        aCache = []
    
    # Get cached value
    func getValue cKey
        if not hasValue(cKey) { return null }
        return aCache[cKey]["value"]
    
    # Set cache value
    func setValue cKey, xValue, nMinutes
        aCache[cKey] = [
            "value" = xValue,
            "expiration" = time() + (nMinutes * 60)
        ]
        return self
    
    # Check if key exists and not expired
    func hasValue cKey
        if aCache[cKey] = null { return false }
        return not isExpired(aCache[cKey])
    
    # Remove cached value
    func removeValue cKey
        del(aCache, cKey)
        return self
    
    # Clear all cache
    func clear
        aCache = []
        return self
    
    private
        # Check if cache is expired
        func isExpired aCacheData
            return aCacheData["expiration"] < time()
