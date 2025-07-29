# ======================================
# RingWeb Framework
# File Cache Class
# ======================================

Package System.RingWeb

Class FileCache from CacheInterface
    # Cache properties
    cCachePath = "storage/cache/"
    
    func init
        # Create cache directory if not exists
        if not dirExists(cCachePath) {
            System("mkdir " + cCachePath)
        }
    
    # Get cached value
    func getValue cKey
        cFile = getCacheFile(cKey)
        
        if not fExists(cFile) { return null }
        
        # Read cache data
        cContent = read(cFile)
        aCacheData = json2list(cContent)
        
        # Check expiration
        if isExpired(aCacheData) {
            removeValue(cKey)
            return null
        }
        
        return aCacheData["value"]
    
    # Set cache value
    func setValue cKey, xValue, nMinutes
        cFile = getCacheFile(cKey)
        
        # Create cache data
        aCacheData = [
            "key" = cKey,
            "value" = xValue,
            "expiration" = time() + (nMinutes * 60)
        ]
        
        # Save to file
        write(cFile, list2json(aCacheData))
        return self
    
    # Check if key exists and not expired
    func hasValue cKey
        cFile = getCacheFile(cKey)
        
        if not fExists(cFile) { return false }
        
        # Read cache data
        cContent = read(cFile)
        aCacheData = json2list(cContent)
        
        return not isExpired(aCacheData)
    
    # Remove cached value
    func removeValue cKey
        cFile = getCacheFile(cKey)
        if fExists(cFile) {
            remove(cFile)
        }
        return self
    
    # Clear all cache
    func clear
        aFiles = listdir(cCachePath)
        for cFile in aFiles {
            if right(cFile, 6) = ".cache" {
                remove(cCachePath + cFile)
            }
        }
        return self
    
    private
        # Get cache file path
        func getCacheFile cKey
            cHash = md5(cKey)
            return cCachePath + cHash + ".cache"
        
        # Check if cache is expired
        func isExpired aCacheData
            return aCacheData["expiration"] < time()
