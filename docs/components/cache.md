# Cache Component Documentation

## Overview
The Cache component provides a unified API for various caching systems, supporting multiple cache stores and advanced caching features.

## Features
- Multiple storage drivers
- Automatic and manual cache invalidation
- Cache tags
- Atomic operations
- Cache events
- Cache serialization
- Cache prefixing

## Basic Usage

### Store and Retrieve
```ring
# Store value
Cache.put("key", "value", 60) # Store for 60 minutes

# Get value
cValue = Cache.get("key")

# Get with default
cValue = Cache.get("key", "default")

# Check existence
if Cache.has("key") {
    # Key exists
}

# Remove value
Cache.forget("key")

# Clear all cache
Cache.flush()
```

### Store Types
```ring
# Store string
Cache.put("name", "John")

# Store number
Cache.put("count", 42)

# Store array
Cache.put("users", ["John", "Jane"])

# Store object
Cache.put("user", new User(["name" = "John"]))
```

### Cache Forever
```ring
# Store permanently
Cache.forever("site-settings", aSettings)

# Retrieve permanent data
aSettings = Cache.get("site-settings")
```

## Advanced Usage

### Cache Drivers

#### File Driver
```ring
# Configure file driver
Cache.driver("file")
     .directory("storage/cache")
```

#### Redis Driver
```ring
# Configure Redis driver
Cache.driver("redis")
     .connection([
         "host" = "localhost",
         "port" = 6379
     ])
```

#### Memory Driver
```ring
# Use memory driver
Cache.driver("array")
```

### Cache Tags
```ring
# Store with tags
Cache.tags(["users", "api"])
     .put("user.1", oUser, 60)

# Get tagged cache
oUser = Cache.tags(["users"])
            .get("user.1")

# Flush tagged cache
Cache.tags(["users"]).flush()
```

### Atomic Operations
```ring
# Increment
Cache.increment("visits")
Cache.increment("balance", 50)

# Decrement
Cache.decrement("stock")
Cache.decrement("points", 5)

# Add if not exists
Cache.add("lock", true, 10)
```

## Best Practices

### Security
1. Don't cache sensitive data
2. Use appropriate TTL values
3. Implement cache versioning
4. Validate cached data
5. Use secure connections for remote cache

### Performance
1. Cache expensive operations
2. Use appropriate cache drivers
3. Implement cache warming
4. Monitor cache size
5. Use cache tags for better organization

## Examples

### Data Caching
```ring
Class UserRepository
    # Get user with caching
    func find nId
        return Cache.remember("user." + nId, 60, func() {
            return DB.table("users")
                    .find(nId)
        })
    
    # Cache user count
    func count
        return Cache.remember("users.count", 30, func() {
            return DB.table("users").count()
        })
```

### View Caching
```ring
Class PageController
    func home
        return Cache.remember("home.page", 60, func() {
            return view("home", [
                "posts" = Post.latest(),
                "categories" = Category.all()
            ])
        })
```

### API Response Caching
```ring
Class ApiController
    func getProducts
        cKey = "products.all." + request("page")
        
        return Cache.remember(cKey, 30, func() {
            return response().json([
                "data" = Product.paginate(20)
            ])
        })
```

### Cache Helper
```ring
Class CacheHelper
    # Cache with version
    func versionedCache cKey, nMinutes, fCallback
        cVersionedKey = cKey + ".v" + self.version
        return Cache.remember(cVersionedKey, nMinutes, fCallback)
    
    # Invalidate version
    func invalidateVersion
        self.version = self.version + 1
        Cache.forever("cache.version", self.version)
```

## Error Handling

### Cache Exceptions
```ring
try {
    Cache.driver("invalid")
catch e
    log("Cache error: " + e.message)
}
```

### Data Validation
```ring
func getCachedUser nId
    oUser = Cache.get("user." + nId)
    if not isObject(oUser) {
        throw("Invalid cached user data")
    }
    return oUser
```

## Debugging

### Cache Information
```ring
# Get driver stats
aStats = Cache.getStats()

# Check driver status
if Cache.isAvailable() {
    # Cache is working
}

# Get cache size
nSize = Cache.size()
```

### Cache Events
```ring
Class CacheListener
    func hit cKey
        log("Cache hit: " + cKey)
    
    func miss cKey
        log("Cache miss: " + cKey)
    
    func forget cKey
        log("Cache cleared: " + cKey)
```

## Configuration Examples

### Multiple Stores
```ring
# Configure stores
Cache.stores([
    "file" = [
        "driver" = "file",
        "path" = "storage/cache"
    ],
    "redis" = [
        "driver" = "redis",
        "host" = "localhost",
        "port" = 6379
    ],
    "memory" = [
        "driver" = "array"
    ]
])

# Use specific store
Cache.store("redis").put("key", "value")
```

### Cache Prefixing
```ring
# Set global prefix
Cache.prefix("app")

# Use prefixed key
Cache.put("key", "value") # Stored as "app:key"
```

### Custom Serialization
```ring
Class CacheSerializer
    func serialize xData
        return json_encode(xData)
    
    func unserialize cData
        return json_decode(cData)
```
