# HTMLHelper Component Documentation

## Overview
The HTMLHelper component provides methods for generating HTML elements with proper escaping and attribute handling.

## Methods

### Basic Elements

#### tag(cTag, aAttributes, xContent)
Creates any HTML tag.
```ring
cDiv = HTMLHelper.tag("div", ["class" = "container"], "Content")
# <div class="container">Content</div>
```

#### div(aAttributes, xContent)
Creates a div element.
```ring
cDiv = HTMLHelper.div(["class" = "alert"], "Warning message")
# <div class="alert">Warning message</div>
```

#### span(aAttributes, xContent)
Creates a span element.
```ring
cSpan = HTMLHelper.span(["class" = "badge"], "New")
# <span class="badge">New</span>
```

### Form Elements

#### form(aAttributes, xContent)
Creates a form element.
```ring
cForm = HTMLHelper.form([
    "method" = "post",
    "action" = "/submit"
], "Form content")
```

#### input(aAttributes)
Creates an input element.
```ring
cInput = HTMLHelper.input([
    "type" = "text",
    "name" = "username",
    "class" = "form-control"
])
```

#### select(aAttributes, aOptions, xSelected = null)
Creates a select element.
```ring
cSelect = HTMLHelper.select(
    ["name" = "country"],
    [
        "us" = "United States",
        "uk" = "United Kingdom"
    ],
    "us"
)
```

### Links and Images

#### link(cUrl, cText, aAttributes = [])
Creates an anchor tag.
```ring
cLink = HTMLHelper.link("/users", "View Users", ["class" = "btn"])
# <a href="/users" class="btn">View Users</a>
```

#### image(cSrc, cAlt = "", aAttributes = [])
Creates an image tag.
```ring
cImg = HTMLHelper.image(
    "/images/logo.png",
    "Logo",
    ["class" = "img-fluid"]
)
```

### Tables

#### table(aAttributes, aHeaders, aRows)
Creates a table element.
```ring
cTable = HTMLHelper.table(
    ["class" = "table"],
    ["ID", "Name", "Email"],
    [
        [1, "John", "john@example.com"],
        [2, "Jane", "jane@example.com"]
    ]
)
```

### Utility Methods

#### escape(cText)
Escapes HTML special characters.
```ring
cSafe = HTMLHelper.escape("<script>alert('XSS')</script>")
```

#### attributes(aAttributes)
Converts an attributes list to string.
```ring
cAttrs = HTMLHelper.attributes([
    "class" = "btn btn-primary",
    "id" = "submit-btn"
])
# class="btn btn-primary" id="submit-btn"
```

## Best Practices

### Security
1. Always escape user input
2. Use CSRF tokens in forms
3. Validate attributes
4. Implement proper encoding
5. Use secure URLs

### Accessibility
1. Include proper ARIA attributes
2. Use semantic HTML
3. Provide alt text for images
4. Ensure proper contrast
5. Support keyboard navigation

### Examples

#### Creating a Form
```ring
func loginForm
    return HTMLHelper.form([
        "method" = "post",
        "action" = "/login",
        "class" = "login-form"
    ], [
        HTMLHelper.div(["class" = "form-group"], [
            HTMLHelper.label(["for" = "email"], "Email"),
            HTMLHelper.input([
                "type" = "email",
                "name" = "email",
                "class" = "form-control",
                "required" = "required"
            ])
        ]),
        HTMLHelper.div(["class" = "form-group"], [
            HTMLHelper.label(["for" = "password"], "Password"),
            HTMLHelper.input([
                "type" = "password",
                "name" = "password",
                "class" = "form-control",
                "required" = "required"
            ])
        ]),
        HTMLHelper.button([
            "type" = "submit",
            "class" = "btn btn-primary"
        ], "Login")
    ])
```

#### Creating a Data Table
```ring
func usersTable aUsers
    aHeaders = ["ID", "Name", "Email", "Actions"]
    aRows = []
    
    for oUser in aUsers {
        add(aRows, [
            oUser.id,
            oUser.name,
            oUser.email,
            HTMLHelper.div(["class" = "btn-group"], [
                HTMLHelper.link(
                    "/users/" + oUser.id,
                    "View",
                    ["class" = "btn btn-info"]
                ),
                HTMLHelper.link(
                    "/users/" + oUser.id + "/edit",
                    "Edit",
                    ["class" = "btn btn-warning"]
                )
            ])
        ])
    }
    
    return HTMLHelper.table(
        ["class" = "table table-striped"],
        aHeaders,
        aRows
    )
```

## Error Handling
The component includes validation for:
- Invalid tag names
- Invalid attribute names
- Invalid attribute values
- Malformed HTML

Example error handling:
```ring
try {
    cHtml = HTMLHelper.tag("invalid!", [], "")
catch e
    log("Invalid HTML tag: " + e.message)
}
```
