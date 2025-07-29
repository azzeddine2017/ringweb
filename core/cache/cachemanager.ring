# ======================================
# RingWeb Framework
# Cache Manager Class
# ======================================

Package System.RingWeb

Class CacheManager
    # Cache drivers
    oCacheDriver = null
    cDefaultDriver = "file"
    
    func init
        # Initialize default cache driver
        setDriver(cDefaultDriver)
    
    # Set cache driver
    func setDriver cDriver
        switch cDriver
            case "file"
                oCacheDriver = new FileCache()
            case "memory"
                oCacheDriver = new MemoryCache()
            other
                raise("Unsupported cache driver: " + cDriver)
        return self
    
    # Get cached value
    func getValue cKey
        return oCacheDriver.getValue(cKey)
    
    # Set cache value
    func setValue cKey, xValue, nMinutes
        return oCacheDriver.setValue(cKey, xValue, nMinutes)
    
    # Check if key exists
    func hasValue cKey
        return oCacheDriver.hasValue(cKey)
    
    # Remove cached value
    func removeValue cKey
        return oCacheDriver.removeValue(cKey)
    
    # Clear all cache
    func clear
        return oCacheDriver.clear()
    
    # Cache a value forever
    func forever cKey, xValue
        return setValue(cKey, xValue, 525600) # 1 year
    
    # Remember a value (get from cache or compute and cache)
    func remember cKey, nMinutes, fpCallback
        if hasValue(cKey) {
            return getValue(cKey)
        }
        
        xValue = call fpCallback()
        setValue(cKey, xValue, nMinutes)
        return xValue
