# View Component Documentation

## Overview
The View component provides a powerful templating system for rendering HTML content with support for layouts, partials, and data binding.

## Features
- Template inheritance
- View composers
- Data sharing
- Partial views
- Custom directives
- Asset management
- Error handling
- View caching

## Basic Usage

### Rendering Views
```ring
# Basic view
return view("home")

# View with data
return view("users.show", [
    "user" = oUser,
    "posts" = oPosts
])

# View with status code
return view("errors.404", [], 404)
```

### Template Syntax
```ring
# Variables
Name: {{ oUser.name }}
Email: {{ oUser.email }}

# Escaped output
Message: {{{ cHtmlContent }}}

# Conditionals
if isAdmin {
    # Admin content
}

# Loops
for oUser in aUsers {
    Name: {{ oUser.name }}
}

# Include partial
include("partials.header")

# Extend layout
extend("layouts.main")

# Section definition
section("content") {
    # Page content
}
```

## Advanced Usage

### Layouts
```ring
# layouts/main.ring
<!DOCTYPE html>
<html>
<head>
    <title>{{ yield("title") }}</title>
    {{ yield("styles") }}
</head>
<body>
    {{ include("partials.nav") }}
    
    <div class="container">
        {{ yield("content") }}
    </div>
    
    {{ yield("scripts") }}
</body>
</html>

# views/home.ring
extend("layouts.main")

section("title", "Home Page")

section("content") {
    <h1>Welcome</h1>
    <p>{{ message }}</p>
}
```

### View Composers
```ring
Class UserComposer
    func compose oView
        oView.with("users", User.all())
        oView.with("categories", Category.all())

# Register composer
View.composer("users.*", new UserComposer())

# Callback composer
View.composer("dashboard", func(oView) {
    oView.with("stats", getDashboardStats())
})
```

## Best Practices

### Security
1. Always escape output
2. Validate user input
3. Use CSRF protection
4. Implement XSS prevention
5. Secure sensitive data display

### Performance
1. Use view caching
2. Optimize database queries
3. Minimize view nesting
4. Cache partial views
5. Use efficient loops

## Examples

### User Profile View
```ring
# views/users/profile.ring
extend("layouts.app")

section("content") {
    <div class="profile">
        <h1>{{ oUser.name }}</h1>
        
        <div class="info">
            <p>Email: {{ oUser.email }}</p>
            <p>Joined: {{ formatDate(oUser.created_at) }}</p>
        </div>
        
        <div class="posts">
            for oPost in oPosts {
                {{ include("partials.post", ["post" = oPost]) }}
            }
        </div>
    </div>
}

# partials/post.ring
<div class="post">
    <h3>{{ oPost.title }}</h3>
    <p>{{ oPost.content }}</p>
    <span>Posted on: {{ formatDate(oPost.created_at) }}</span>
</div>
```

### Dashboard Layout
```ring
# views/layouts/dashboard.ring
extend("layouts.app")

section("sidebar") {
    <div class="sidebar">
        <ul>
            <li><a href="/dashboard">Overview</a></li>
            <li><a href="/users">Users</a></li>
            <li><a href="/settings">Settings</a></li>
        </ul>
    </div>
}

section("content") {
    <div class="dashboard">
        <div class="header">
            {{ yield("dashboard-header") }}
        </div>
        
        <div class="main">
            {{ yield("dashboard-content") }}
        </div>
    </div>
}
```

### Form Partial
```ring
# partials/form/input.ring
func formInput aAttributes
    <div class="form-group">
        if aAttributes["label"] {
            <label for="{{ aAttributes['id'] }}">
                {{ aAttributes["label"] }}
            </label>
        }
        
        <input
            type="{{ aAttributes['type'] or 'text' }}"
            name="{{ aAttributes['name'] }}"
            id="{{ aAttributes['id'] }}"
            value="{{ aAttributes['value'] }}"
            class="form-control {{ aAttributes['class'] }}"
        >
        
        if hasError(aAttributes["name"]) {
            <span class="error">
                {{ getError(aAttributes["name"]) }}
            </span>
        }
    </div>
```

### Error Pages
```ring
# views/errors/404.ring
extend("layouts.error")

section("content") {
    <div class="error-page">
        <h1>404 - Not Found</h1>
        <p>{{ message or "The requested page could not be found." }}</p>
        <a href="/" class="btn">Return Home</a>
    </div>
}
```

## Error Handling

### View Errors
```ring
try {
    return view("invalid.view")
catch e
    return view("errors.500", [
        "message" = e.message
    ])
}
```

### Missing Variables
```ring
func handleMissingVariable cVariable
    if app().isDebug() {
        throw("Undefined variable: " + cVariable)
    }
    return ""
```

## Debugging

### View Information
```ring
# Get view path
cPath = View.getPath("home")

# Check if view exists
if View.exists("page") {
    # View exists
}

# Get shared data
aShared = View.getShared()
```

### View Factory
```ring
Class ViewFactory
    # Find view file
    func find cView
        for cPath in this.paths {
            cFullPath = cPath + "/" + cView + ".ring"
            if exists(cFullPath) {
                return cFullPath
            }
        }
        throw("View not found: " + cView)
    
    # Add view path
    func addPath cPath
        this.paths.add(cPath)
```

### Asset Management
```ring
# Register asset
Asset.register("app.css", "/css/app.css")
Asset.register("app.js", "/js/app.js")

# Render assets
Asset.styles()
Asset.scripts()

# Version assets
Asset.version("app.css", "v1.2.3")
```
