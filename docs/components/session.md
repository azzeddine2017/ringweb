# Session Component Documentation

## Overview
The Session component provides a way to persist data across multiple HTTP requests.

## Features
- Session management
- Flash messages
- Session security
- Custom storage drivers
- Session events
- Session garbage collection

## Basic Usage

### Session Data
```ring
# Store data
Session.put("user_id", 1)
Session.put("preferences", ["theme" = "dark"])

# Get data
nUserId = Session.get("user_id")
aPrefs = Session.get("preferences")

# Get with default
cTheme = Session.get("theme", "light")

# Check existence
if Session.has("user_id") {
    # User is logged in
}

# Remove data
Session.forget("temporary_data")

# Clear all data
Session.flush()
```

### Flash Messages
```ring
# Store flash message
Session.flash("success", "Profile updated")
Session.flash("error", "Update failed")

# Store flash input
Session.flashInput(request().all())

# Get flash data
cMessage = Session.flash("success")

# Keep flash data for another request
Session.reflash()

# Keep specific flash data
Session.keep(["error"])
```

### Arrays
```ring
# Push to array
Session.push("users", "John")

# Get array
aUsers = Session.get("users", [])

# Remove from array
Session.pull("users", "John")
```

## Advanced Usage

### Custom Storage
```ring
# File storage
Session.driver("file")

# Database storage
Session.driver("database")

# Redis storage
Session.driver("redis")
```

### Session ID
```ring
# Get session ID
cId = Session.getId()

# Regenerate session ID
Session.regenerate()

# Invalidate and regenerate
Session.invalidate()
```

### Session Token
```ring
# Get CSRF token
cToken = Session.token()

# Regenerate token
Session.regenerateToken()
```

## Best Practices

### Security
1. Use secure session settings
2. Implement proper session expiration
3. Validate session data
4. Use HTTPS only cookies
5. Implement session fixation protection

### Performance
1. Store minimal data
2. Use appropriate storage driver
3. Implement session cleanup
4. Monitor session size
5. Cache frequently accessed data

## Examples

### Authentication
```ring
Class Auth
    # Login user
    func login oUser
        Session.put("user_id", oUser.id)
        Session.put("user_role", oUser.role)
        Session.regenerate()
    
    # Logout user
    func logout
        Session.forget("user_id")
        Session.forget("user_role")
        Session.invalidate()
    
    # Check authentication
    func check
        return Session.has("user_id")
    
    # Get current user
    func user
        nUserId = Session.get("user_id")
        if nUserId = null { return null }
        return User.find(nUserId)
```

### Shopping Cart
```ring
Class Cart
    # Add item
    func add nProductId, nQuantity
        aCart = Session.get("cart", [])
        aCart[nProductId] = nQuantity
        Session.put("cart", aCart)
    
    # Remove item
    func remove nProductId
        aCart = Session.get("cart", [])
        delete(aCart, nProductId)
        Session.put("cart", aCart)
    
    # Get cart contents
    func contents
        return Session.get("cart", [])
    
    # Clear cart
    func clear
        Session.forget("cart")
```

### User Preferences
```ring
Class Preferences
    # Save preference
    func save cKey, xValue
        aPrefs = Session.get("preferences", [])
        aPrefs[cKey] = xValue
        Session.put("preferences", aPrefs)
    
    # Get preference
    func get cKey, xDefault = null
        aPrefs = Session.get("preferences", [])
        if aPrefs[cKey] = null {
            return xDefault
        }
        return aPrefs[cKey]
    
    # Reset preferences
    func reset
        Session.forget("preferences")
```

## Error Handling

### Session Errors
```ring
try {
    Session.driver("invalid")
catch e
    log("Session error: " + e.message)
}
```

### Data Validation
```ring
func getUserId
    nUserId = Session.get("user_id")
    if not isNumber(nUserId) {
        throw("Invalid session data")
    }
    return nUserId
```

## Debugging

### Session Information
```ring
# Get all session data
aData = Session.all()

# Get session metadata
aMetadata = Session.getMetadata()

# Check session status
if Session.isStarted() {
    # Session is active
}
```
