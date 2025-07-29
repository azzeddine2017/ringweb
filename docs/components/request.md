# Request Component Documentation

## Overview
The Request component handles HTTP requests and provides methods to access request data.

## Features
- Input handling
- File uploads
- Headers management
- Cookie handling
- Session integration
- Request validation

## Basic Usage

### Input Handling
```ring
# Get input value
cName = request("name")

# Get input with default
cSort = request("sort", "asc")

# Check if input exists
if hasInput("email") {
    # Process email
}

# Get all input
aData = request().all()

# Get specific inputs
aData = request().only(["name", "email"])
aData = request().except(["password"])
```

### File Uploads
```ring
# Check if file was uploaded
if hasFile("photo") {
    # Get file information
    cOriginalName = request().file("photo").getClientOriginalName()
    nSize = request().file("photo").getSize()
    cMime = request().file("photo").getMimeType()
    
    # Store the file
    cPath = request().file("photo").store("uploads")
}

# Store with custom filename
request().file("photo").storeAs("uploads", "custom-name.jpg")

# Store in public directory
request().file("photo").storePublicly("photos")
```

### Headers
```ring
# Get header
cUserAgent = request().header("User-Agent")

# Get header with default
cAccept = request().header("Accept", "*/*")

# Check header existence
if request().hasHeader("X-Requested-With") {
    # Process AJAX request
}

# Get all headers
aHeaders = request().headers()
```

### Cookies
```ring
# Get cookie value
cToken = request().cookie("token")

# Get cookie with default
cTheme = request().cookie("theme", "light")

# Check cookie existence
if request().hasCookie("remember") {
    # Process remembered login
}
```

## Advanced Usage

### Request Information
```ring
# Get request method
cMethod = request().method()

# Get request path
cPath = request().path()

# Get full URL
cUrl = request().url()
cFullUrl = request().fullUrl()

# Get request IP
cIp = request().ip()

# Get user agent
cUserAgent = request().userAgent()
```

### JSON Requests
```ring
# Check if request wants JSON
if request().wantsJson() {
    return response().json(["status" = "success"])
}

# Get JSON input
if request().isJson() {
    aData = request().json()
    cName = request().json("user.name")
}
```

### Request Validation
```ring
# Basic validation
if not validate([
    "name" = "required|min:3",
    "email" = "required|email",
    "age" = "required|numeric|min:18"
]) {
    return redirect()->withErrors(getValidationErrors())
}

# Custom validation messages
validate([
    "name" = "required|min:3"
], [
    "name.required" = "Please enter your name",
    "name.min" = "Name must be at least 3 characters"
])
```

## Best Practices

### Security
1. Always validate input
2. Sanitize file uploads
3. Use CSRF protection
4. Implement rate limiting
5. Validate content types

### Performance
1. Limit file upload sizes
2. Cache request data when appropriate
3. Use efficient validation rules
4. Monitor request processing time
5. Clean up uploaded files

## Examples

### Form Processing
```ring
Class UserController
    func store
        # Validate input
        if not validate([
            "name" = "required|min:3",
            "email" = "required|email|unique:users",
            "password" = "required|min:6|confirmed"
        ]) {
            return redirect("/users/create")
                   .withErrors(getValidationErrors())
                   .withInput()
        }
        
        # Create user
        User.create([
            "name" = request("name"),
            "email" = request("email"),
            "password" = hash(request("password"))
        ])
        
        return redirect("/users")
               .withSuccess("User created successfully")
```

### File Upload Handling
```ring
Class PhotoController
    func upload
        # Validate file
        if not validate([
            "photo" = "required|image|max:2048"
        ]) {
            return redirect()->withErrors(getValidationErrors())
        }
        
        # Store file
        cPath = request().file("photo")
                        .storeAs("photos", generateFileName())
        
        # Create photo record
        Photo.create([
            "path" = cPath,
            "user_id" = auth().id()
        ])
        
        return redirect()->withSuccess("Photo uploaded successfully")
```

### API Request Handling
```ring
Class ApiController
    func search
        # Get search parameters
        cQuery = request("q")
        nPage = number(request("page", "1"))
        nLimit = number(request("limit", "10"))
        
        # Validate parameters
        if not validate([
            "q" = "required|min:3",
            "page" = "numeric|min:1",
            "limit" = "numeric|min:1|max:100"
        ]) {
            return response().json([
                "error" = "Invalid parameters",
                "messages" = getValidationErrors()
            ], 422)
        }
        
        # Perform search
        aResults = performSearch(cQuery, nPage, nLimit)
        
        # Return JSON response
        return response().json([
            "data" = aResults,
            "meta" = [
                "query" = cQuery,
                "page" = nPage,
                "limit" = nLimit
            ]
        ])
```

## Error Handling

### Validation Errors
```ring
# Get all validation errors
aErrors = getValidationErrors()

# Get first error
cError = getValidationErrors().first()

# Get specific field error
cNameError = getValidationErrors("name")
```

### File Upload Errors
```ring
try {
    request().file("document").store("uploads")
catch e
    return redirect()->withError("Upload failed: " + e.message)
}
```

## Debugging

### Request Dump
```ring
# Dump all request data
request().dump()

# Dump specific sections
request().dumpHeaders()
request().dumpServer()
request().dumpFiles()
```
