# Validation Component Documentation

## Overview
The Validation component provides a comprehensive system for validating input data using rules and custom validators.

## Features
- Built-in validation rules
- Custom validation rules
- Error messages
- Form request validation
- Array validation
- Conditional validation
- File validation

## Basic Usage

### Simple Validation
```ring
# Basic validation
if not validate([
    "name" = "required|min:3",
    "email" = "required|email",
    "age" = "required|numeric|min:18"
]) {
    return redirect()->withErrors(getValidationErrors())
}

# Get validated data
aData = getValidated()
```

### Common Rules
```ring
# String rules
"name" = "required|string|min:2|max:100"

# Numeric rules
"age" = "required|numeric|between:18,100"

# Date rules
"birth_date" = "required|date|before:today"

# Boolean rules
"terms" = "required|accepted"

# Array rules
"items" = "required|array|min:1"

# File rules
"photo" = "required|file|image|max:2048"
```

### Custom Messages
```ring
validate([
    "name" = "required|min:3"
], [
    "name.required" = "Please enter your name",
    "name.min" = "Name must be at least 3 characters"
])
```

## Advanced Usage

### Custom Rules
```ring
Class PhoneRule
    func passes cAttribute, xValue
        return isString(xValue) and 
               len(xValue) >= 10 and
               isMatch("\d+", xValue)
    
    func message
        return "The :attribute must be a valid phone number"

# Register custom rule
Validator.extend("phone", new PhoneRule())

# Use custom rule
validate([
    "phone" = "required|phone"
])
```

### Conditional Validation
```ring
# Required if
"reason" = "required_if:status,rejected"

# Required unless
"photo" = "required_unless:type,guest"

# Required with
"last_name" = "required_with:first_name"

# Required without
"phone" = "required_without:email"
```

### Array Validation
```ring
# Validate array
"users" = "required|array",
"users.*.name" = "required|string",
"users.*.email" = "required|email"

# Validate nested array
"categories.*.subcategories.*.name" = "required|string"
```

## Best Practices

### Security
1. Validate all input
2. Use appropriate rules
3. Sanitize validated data
4. Implement CSRF protection
5. Validate file uploads carefully

### Performance
1. Use efficient validation rules
2. Cache compiled rules
3. Validate early
4. Use form requests
5. Implement request throttling

## Examples

### Form Request
```ring
Class CreateUserRequest
    # Validation rules
    func rules
        return [
            "name" = "required|string|max:255",
            "email" = "required|email|unique:users",
            "password" = "required|min:8|confirmed",
            "role" = "required|in:user,admin"
        ]
    
    # Custom messages
    func messages
        return [
            "email.unique" = "This email is already registered"
        ]
    
    # Custom attributes
    func attributes
        return [
            "email" = "email address"
        ]
```

### Complex Validation
```ring
Class ProductValidator
    # Validate product
    func validate aData
        return validate(aData, [
            "name" = "required|string|max:255",
            "price" = "required|numeric|min:0",
            "category_id" = "required|exists:categories,id",
            "tags" = "array",
            "tags.*" = "string|max:50",
            "images" = "array|max:5",
            "images.*" = "image|max:2048"
        ], [
            "images.max" = "Maximum 5 images allowed",
            "images.*.max" = "Each image must be less than 2MB"
        ])
```

### API Validation
```ring
Class ApiController
    func store
        # Validate request
        if not validate(request().all(), [
            "title" = "required|string|max:255",
            "content" = "required|string",
            "status" = "in:draft,published"
        ]) {
            return response().json([
                "errors" = getValidationErrors()
            ], 422)
        }
        
        # Process validated data
        return Post.create(getValidated())
```

### File Validation
```ring
Class UploadController
    func upload
        # Validate file upload
        if not validate([
            "document" = "required|file|mimes:pdf,doc,docx|max:10240",
            "photos.*" = "image|mimes:jpeg,png|max:2048"
        ]) {
            return redirect()
                   .withErrors(getValidationErrors())
        }
        
        # Process files
        processUpload(request().file("document"))
```

## Error Handling

### Validation Errors
```ring
# Get all errors
aErrors = getValidationErrors()

# Get first error
cError = getValidationErrors().first()

# Get specific field error
cNameError = getValidationErrors("name")

# Format error message
func formatError cField, cMessage
    return substitute(cMessage, [
        ":field" = cField
    ])
```

### Custom Error Handling
```ring
Class ValidationHandler
    # Handle validation failure
    func failed aErrors
        if request().wantsJson() {
            return response().json([
                "errors" = aErrors
            ], 422)
        }
        
        return redirect()
               .back()
               .withErrors(aErrors)
               .withInput()
```

## Debugging

### Validation Information
```ring
# Get validation rules
aRules = Validator.getRules()

# Get custom messages
aMessages = Validator.getCustomMessages()

# Check if field passed
if Validator.passed("email") {
    # Field is valid
}
```

### Rule Analysis
```ring
Class RuleAnalyzer
    # Analyze rule
    func analyze cRule
        return [
            "name" = this.getRuleName(cRule),
            "parameters" = this.getRuleParameters(cRule)
        ]
    
    # Get rule parameters
    func getRuleParameters cRule
        if ":" in cRule {
            return split(substr(cRule, find(cRule, ":") + 1), ",")
        }
        return []
```
