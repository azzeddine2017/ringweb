# Response Component Documentation

## Overview
The Response component handles HTTP responses and provides methods to send various types of responses.

## Features
- Multiple response types (HTML, JSON, File, etc.)
- Header management
- Cookie handling
- Redirects
- File downloads
- Status codes
- Content types

## Basic Usage

### HTML Responses
```ring
# Basic response
return response("Hello World")

# With status code
return response("Not Found", 404)

# With headers
return response("Content")
       .header("X-Custom-Header", "Value")

# View response
return view("home.index", ["name" = "John"])
```

### JSON Responses
```ring
# Basic JSON
return response().json([
    "status" = "success",
    "data" = aUsers
])

# With status code
return response().json([
    "error" = "Not found"
], 404)

# JSONP
return response().jsonp("callback", [
    "data" = aResults
])
```

### File Responses
```ring
# Download file
return response().download("path/to/file.pdf")

# Download with custom name
return response().download("path/to/file.pdf", "custom-name.pdf")

# Stream file
return response().file("path/to/large-file.zip")

# Inline display
return response().inline("path/to/image.jpg")
```

### Redirects
```ring
# Basic redirect
return redirect("/home")

# Redirect with flash data
return redirect("/users")
       .with("success", "User created successfully")

# Redirect with errors
return redirect("/users/create")
       .withErrors(aErrors)
       .withInput()

# Redirect to named route
return redirect().route("profile", ["id" = 1])

# Redirect back
return redirect().back()
```

## Advanced Usage

### Response Macros
```ring
# Define custom response macro
Response.macro("success", func(cMessage) {
    return response().json([
        "status" = "success",
        "message" = cMessage
    ])
})

# Use custom macro
return response().success("Operation completed")
```

### Content Types
```ring
# Set content type
return response("<?xml version="1.0"?>")
       .header("Content-Type", "application/xml")

# PDF response
return response(pdfContent)
       .header("Content-Type", "application/pdf")
```

### Caching
```ring
# Set cache headers
return response(content)
       .cache(["max-age" = 3600])

# Prevent caching
return response(content)
       .noCache()
```

## Best Practices

### Security
1. Set appropriate headers
2. Validate file downloads
3. Sanitize JSON responses
4. Use HTTPS redirects
5. Implement proper error handling

### Performance
1. Use appropriate response types
2. Implement caching when possible
3. Stream large files
4. Compress responses when appropriate
5. Monitor response times

## Examples

### API Response Handler
```ring
Class ApiResponse
    # Success response
    func success cMessage, xData
        return response().json([
            "status" = "success",
            "message" = cMessage,
            "data" = xData
        ])
    
    # Error response
    func error cMessage, nCode = 400
        return response().json([
            "status" = "error",
            "message" = cMessage
        ], nCode)
    
    # Validation error response
    func validationError aErrors
        return response().json([
            "status" = "error",
            "message" = "Validation failed",
            "errors" = aErrors
        ], 422)
```

### File Download Handler
```ring
Class DownloadController
    func download nId
        # Get file record
        oFile = File.find(nId)
        if oFile = null {
            return response().json([
                "error" = "File not found"
            ], 404)
        }
        
        # Check permissions
        if not canDownload(oFile) {
            return response().json([
                "error" = "Unauthorized"
            ], 403)
        }
        
        # Send file
        return response().download(
            oFile.path,
            oFile.original_name
        )
```

### Error Response Handler
```ring
Class ErrorController
    func notFound
        if request().wantsJson() {
            return response().json([
                "error" = "Not found"
            ], 404)
        }
        
        return response()
               .view("errors.404")
               .status(404)
    
    func serverError cMessage
        if app().isDebug() {
            return response()
                   .view("errors.500", [
                       "message" = cMessage,
                       "trace" = getDebugBacktrace()
                   ])
        }
        
        return response()
               .view("errors.500")
               .status(500)
```

## Error Handling

### Exception Responses
```ring
try {
    # Some operation
catch e
    return response().json([
        "error" = e.message
    ], 500)
}
```

### Invalid Input
```ring
if not validate(aRules) {
    return response().json([
        "error" = "Validation failed",
        "messages" = getValidationErrors()
    ], 422)
}
```

## Debugging

### Response Information
```ring
# Get response status
nStatus = response().getStatus()

# Get response headers
aHeaders = response().getHeaders()

# Get response content
cContent = response().getContent()
```
