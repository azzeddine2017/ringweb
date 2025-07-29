# Authentication Component Documentation

## Overview
The Authentication component provides a complete authentication system with support for multiple authentication guards and providers.

## Features
- Multiple authentication guards
- User providers
- Password hashing
- Remember me functionality
- Event handling
- Session integration
- Token-based authentication
- Social authentication

## Basic Usage

### Authentication
```ring
# Attempt login
if Auth.attempt([
    "email" = request("email"),
    "password" = request("password")
]) {
    return redirect("/dashboard")
}

# Login with remember
Auth.attempt(aCredentials, true)

# Login specific user
Auth.login(oUser)

# Logout
Auth.logout()

# Check authentication
if Auth.check() {
    # User is logged in
}

# Get authenticated user
oUser = Auth.user()
```

### Password Management
```ring
# Hash password
cHash = Auth.hash("password123")

# Check password
if Auth.checkPassword(oUser, "password123") {
    # Password is correct
}

# Update password
Auth.updatePassword(oUser, "newpassword")
```

## Advanced Usage

### Guards

#### Session Guard
```ring
# Use session guard
Auth.guard("session")

# Attempt login
Auth.guard("session").attempt(aCredentials)
```

#### Token Guard
```ring
# Use token guard
Auth.guard("token")

# Validate token
if Auth.guard("token").check(cToken) {
    # Token is valid
}
```

### User Providers
```ring
# Database provider
Auth.provider("database")
     .table("users")
     .fields(["id", "name", "email"])

# Custom provider
Class CustomUserProvider
    func retrieveById nId
        return User.find(nId)
    
    func retrieveByCredentials aCredentials
        return User.where("email", aCredentials["email"])
                  .first()
```

## Best Practices

### Security
1. Use secure password hashing
2. Implement rate limiting
3. Use HTTPS
4. Implement session security
5. Use secure token generation

### Performance
1. Cache user data
2. Use appropriate guards
3. Optimize database queries
4. Monitor authentication attempts
5. Implement request throttling

## Examples

### Authentication Controller
```ring
Class AuthController
    # Login action
    func login
        if not validate([
            "email" = "required|email",
            "password" = "required"
        ]) {
            return redirect()
                   .withErrors(getValidationErrors())
        }
        
        if Auth.attempt([
            "email" = request("email"),
            "password" = request("password")
        ], request("remember")) {
            return redirect()->intended("/dashboard")
        }
        
        return redirect()
               .withError("auth", "Invalid credentials")
    
    # Logout action
    func logout
        Auth.logout()
        return redirect("/")
```

### Registration Controller
```ring
Class RegisterController
    func register
        # Validate input
        if not validate([
            "name" = "required|string|max:255",
            "email" = "required|email|unique:users",
            "password" = "required|min:8|confirmed"
        ]) {
            return redirect()
                   .withErrors(getValidationErrors())
        }
        
        # Create user
        oUser = User.create([
            "name" = request("name"),
            "email" = request("email"),
            "password" = Auth.hash(request("password"))
        ])
        
        # Login user
        Auth.login(oUser)
        
        return redirect("/dashboard")
```

### Password Reset
```ring
Class PasswordController
    # Request reset
    func forgot
        if not validate(["email" = "required|email"]) {
            return redirect()->withErrors(getValidationErrors())
        }
        
        cToken = Auth.createPasswordResetToken(request("email"))
        Mail.send("reset-password", [
            "token" = cToken
        ])
        
        return redirect()->withSuccess("Reset link sent")
    
    # Reset password
    func reset
        if not Auth.validatePasswordResetToken(
            request("email"),
            request("token")
        ) {
            return redirect()->withError("Invalid token")
        }
        
        Auth.resetPassword(
            request("email"),
            request("password")
        )
        
        return redirect("/login")
```

### API Authentication
```ring
Class ApiAuthController
    # Login and get token
    func login
        if Auth.attempt([
            "email" = request("email"),
            "password" = request("password")
        ]) {
            oUser = Auth.user()
            cToken = Auth.createToken(oUser)
            
            return response().json([
                "token" = cToken
            ])
        }
        
        return response().json([
            "error" = "Invalid credentials"
        ], 401)
    
    # Validate token
    func validateToken
        cToken = request().bearerToken()
        
        if Auth.guard("token").check(cToken) {
            return true
        }
        
        return response().json([
            "error" = "Invalid token"
        ], 401)
```

## Error Handling

### Authentication Exceptions
```ring
try {
    Auth.guard("invalid")
catch e
    log("Auth error: " + e.message)
}
```

### Login Attempts
```ring
Class LoginAttemptHandler
    func failed cEmail
        # Log failed attempt
        log("Failed login attempt: " + cEmail)
        
        # Increment counter
        Cache.increment("login_attempts:" + cEmail)
        
        # Check if should throttle
        if this.shouldThrottle(cEmail) {
            throw("Too many login attempts")
        }
```

## Debugging

### Authentication Information
```ring
# Get current guard
cGuard = Auth.getDefaultDriver()

# Get all guards
aGuards = Auth.getGuards()

# Get provider
oProvider = Auth.getProvider()

# Check capabilities
if Auth.supportRememberMe() {
    # Remember me is supported
}
```
