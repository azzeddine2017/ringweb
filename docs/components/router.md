# Router Component Documentation

## Overview
The Router component handles URL routing and request dispatching in RingWeb applications.

## Features
- RESTful routing support
- Route parameters and wildcards
- Route groups and prefixes
- Middleware support
- Named routes
- Resource routing

## Basic Usage

### Route Definition
```ring
# Basic routes
Router.get("/", "HomeController@index")
Router.post("/users", "UserController@store")
Router.put("/users/:id", "UserController@update")
Router.delete("/users/:id", "UserController@delete")

# Named routes
Router.get("/profile", "ProfileController@show").name("profile")

# Route with parameters
Router.get("/posts/:id/comments/:commentId", "CommentController@show")

# Route groups
Router.group(["prefix" = "admin", "middleware" = "auth"], func() {
    Router.get("/dashboard", "AdminController@index")
    Router.resource("users", "AdminUserController")
})
```

### Resource Routes
```ring
# Creates all CRUD routes
Router.resource("photos", "PhotoController")

# Generated routes:
# GET /photos -> index
# GET /photos/create -> create
# POST /photos -> store
# GET /photos/:id -> show
# GET /photos/:id/edit -> edit
# PUT/PATCH /photos/:id -> update
# DELETE /photos/:id -> destroy
```

### Route Parameters
```ring
# Required parameters
Router.get("/users/:id", "UserController@show")

# Optional parameters
Router.get("/users/:id?", "UserController@showOrList")

# Regular expression constraints
Router.get("/users/:id", "UserController@show")
      .where("id", "[0-9]+")
```

### Middleware
```ring
# Single middleware
Router.get("/admin", "AdminController@index")
      .middleware("auth")

# Multiple middleware
Router.get("/admin/users", "AdminController@users")
      .middleware(["auth", "admin"])
```

## Advanced Usage

### Route Groups
```ring
Router.group(["prefix" = "api"], func() {
    Router.group(["prefix" = "v1"], func() {
        Router.get("/users", "Api\V1\UserController@index")
        Router.get("/posts", "Api\V1\PostController@index")
    })
})
```

### Domain Routing
```ring
Router.domain("api.example.com", func() {
    Router.get("/", "ApiController@index")
})
```

### Route Model Binding
```ring
Router.get("/users/:user", "UserController@show")
      .bind("user", "User")
```

### Route Caching
```ring
# Cache routes
Router.cache()

# Clear route cache
Router.clearCache()
```

## Best Practices

### Route Organization
1. Group related routes together
2. Use resource routes for CRUD operations
3. Keep route files clean and organized
4. Use meaningful route names
5. Implement proper middleware

### Security
1. Protect sensitive routes with middleware
2. Validate route parameters
3. Use CSRF protection for forms
4. Implement rate limiting
5. Log route access when needed

### Performance
1. Cache frequently accessed routes
2. Use route model binding
3. Implement proper HTTP caching
4. Optimize middleware stack
5. Monitor route performance

## Examples

### API Routes
```ring
Router.group(["prefix" = "api", "middleware" = "api"], func() {
    # Version 1
    Router.group(["prefix" = "v1"], func() {
        Router.get("/users", "Api\V1\UserController@index")
        Router.post("/users", "Api\V1\UserController@store")
        Router.get("/users/:id", "Api\V1\UserController@show")
    })
    
    # Version 2
    Router.group(["prefix" = "v2"], func() {
        Router.apiResource("users", "Api\V2\UserController")
    })
})
```

### Admin Panel Routes
```ring
Router.group([
    "prefix" = "admin",
    "middleware" = ["auth", "admin"],
    "namespace" = "Admin"
], func() {
    Router.get("/", "DashboardController@index")
    Router.resource("users", "UserController")
    Router.resource("posts", "PostController")
})
```

### Authentication Routes
```ring
Router.group(["middleware" = "guest"], func() {
    Router.get("/login", "Auth\LoginController@showForm")
    Router.post("/login", "Auth\LoginController@login")
    Router.get("/register", "Auth\RegisterController@showForm")
    Router.post("/register", "Auth\RegisterController@register")
})

Router.group(["middleware" = "auth"], func() {
    Router.post("/logout", "Auth\LoginController@logout")
    Router.get("/profile", "Auth\ProfileController@show")
})
```

## Error Handling

### Custom 404 Handler
```ring
Router.missing(func() {
    return view("errors.404")
})
```

### Method Not Allowed
```ring
Router.methodNotAllowed(func() {
    return view("errors.405")
})
```

## Debugging

### Route List
```ring
Router.list() # Shows all registered routes
```

### Route Testing
```ring
Router.has("/users") # Check if route exists
Router.match("GET", "/users") # Test route matching
```
