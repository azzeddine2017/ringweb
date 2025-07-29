# RingWeb Framework Documentation

## Table of Contents
1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
3. [Core Concepts](#core-concepts)
4. [Framework Components](#framework-components)
5. [Advanced Topics](#advanced-topics)
6. [Best Practices](#best-practices)
7. [API Reference](#api-reference)

## Introduction

### What is RingWeb?
RingWeb is a modern, lightweight MVC framework built with the Ring programming language. It provides a robust foundation for building web applications with clean architecture and powerful features.

### Key Features
- MVC Architecture
- Routing System
- Database ORM
- Template Engine
- Multi-language Support
- File Management
- HTML Generation
- Form Validation
- Session Management
- Security Features

## Getting Started

### Requirements
- Ring 1.22 or higher
- Web Server (Apache/Nginx)
- MySQL Database
- Composer (optional, for package management)

### Installation
```bash
# Clone the repository
git clone https://github.com/Azzeddine2017/ringweb.git

# Navigate to project directory
cd ringweb

# Initialize the framework
ring bootstrap.ring
```

### Directory Structure
```
ringweb/
├── app/                    # Application code
│   ├── controllers/        # Controller classes
│   ├── models/            # Model classes
│   └── middleware/        # Middleware classes
├── config/                # Configuration files
│   └── app.json          # Main configuration
├── core/                  # Framework core
│   ├── application.ring   # Application class
│   ├── autoloader.ring    # Class autoloader
│   └── helpers/          # Helper classes
├── public/                # Public assets
│   ├── css/              # CSS files
│   ├── js/               # JavaScript files
│   └── index.php         # Entry point
├── resources/             # Application resources
│   ├── lang/             # Language files
│   └── views/            # View templates
└── bootstrap.ring         # Framework bootstrap
```

## Core Concepts

### MVC Pattern
RingWeb strictly follows the MVC (Model-View-Controller) pattern:

#### Controllers
Controllers handle user requests and coordinate between models and views.

```ring
Class UserController
    func index
        aUsers = new User().all()
        return view("users/index", ["users" = aUsers])
    
    func show nId
        oUser = new User().find(nId)
        return view("users/show", ["user" = oUser])
```

#### Models
Models represent data and business logic.

```ring
Class User from Model
    # Table name
    cTable = "users"
    
    # Fillable fields
    aFillable = ["name", "email", "password"]
    
    # Hidden fields
    aHidden = ["password"]
    
    # Relationships
    func posts
        return hasMany("Post")
```

#### Views
Views define how data should be presented.

```ring
func getView aData
    return HTMLHelper.div([
        "class" = "container"
    ], [
        HTMLHelper.h1([], "Welcome"),
        HTMLHelper.p([], aData[:message])
    ])
```

### Routing
Define routes in `routes.ring`:

```ring
# Basic routes
Router.get("/", "HomeController@index")
Router.get("/about", "HomeController@about")

# Resource routes
Router.resource("users", "UserController")

# Route with parameters
Router.get("/users/:id", "UserController@show")

# Route groups
Router.group(["prefix" = "admin", "middleware" = "auth"], func() {
    Router.get("/dashboard", "AdminController@index")
    Router.resource("users", "AdminUserController")
})
```

### Database Operations

#### Query Builder
```ring
# Select
aUsers = DB.table("users")
          .where("age", ">", 18)
          .orderBy("name", "asc")
          .get()

# Insert
DB.table("users").insert([
    "name" = "John Doe",
    "email" = "john@example.com"
])

# Update
DB.table("users")
  .where("id", 1)
  .update(["status" = "active"])

# Delete
DB.table("users").where("id", 1).delete()
```

#### Model Operations
```ring
# Create
oUser = new User([
    "name" = "John Doe",
    "email" = "john@example.com"
])
oUser.save()

# Find
oUser = User.find(1)

# Update
oUser.name = "Jane Doe"
oUser.save()

# Delete
oUser.delete()
```

### Internationalization

#### Configuration
In `config/app.json`:
```json
{
    "locale": "en",
    "fallback_locale": "en"
}
```

#### Usage
```ring
# Simple translation
cMessage = getText("messages.welcome")

# Translation with variables
cError = getTextWithVars("validation.min", [
    ["field", "password"],
    ["min", "6"]
])
```

### File Management

#### Basic Operations
```ring
# File upload
FileHelper.upload(request("file"), "uploads/images")

# File information
cExt = FileHelper.extension("path/to/file.jpg")
nSize = FileHelper.size("path/to/file.jpg")
cMime = FileHelper.mime("path/to/file.jpg")

# Directory operations
FileHelper.createDirectory("path/to/dir")
FileHelper.deleteDirectory("path/to/dir")
```

### HTML Generation

#### Basic Elements
```ring
# Create div
cDiv = HTMLHelper.div(["class" = "container"], "Content")

# Create form
cForm = HTMLHelper.form([
    "method" = "post",
    "action" = "/users"
], [
    HTMLHelper.input([
        "type" = "text",
        "name" = "username"
    ]),
    HTMLHelper.button([], "Submit")
])
```

## Advanced Topics

### Middleware
```ring
Class AuthMiddleware
    func handle oRequest, next
        if not Session.has("user_id")
            return redirect("/login")
        }
        return next(oRequest)
```

### Events
```ring
# Define event
Event.on("user.registered", func(oUser) {
    # Send welcome email
    Mail.send("welcome", oUser.email, [
        "name" = oUser.name
    ])
})

# Trigger event
Event.trigger("user.registered", oUser)
```

### Validation
```ring
# Define rules
aRules = [
    "name" = "required|min:3",
    "email" = "required|email|unique:users",
    "password" = "required|min:6|confirmed"
]

# Validate
if not validate(aRules) {
    return redirect()->withErrors(getValidationErrors())
}
```

## Best Practices

### Security
1. Always validate user input
2. Use prepared statements for database queries
3. Hash passwords using secure algorithms
4. Implement CSRF protection
5. Use HTTPS in production

### Performance
1. Cache frequently accessed data
2. Optimize database queries
3. Minimize file operations
4. Use lazy loading for relationships
5. Implement proper indexing

### Code Organization
1. Follow PSR standards
2. Use meaningful names for variables and functions
3. Keep controllers thin, models fat
4. Document your code
5. Write unit tests

## API Reference

### Application Class
Core class that bootstraps the framework.

### Router Class
Handles URL routing and request dispatching.

### Model Class
Base class for all models with ORM functionality.

### Controller Class
Base class for all controllers.

### View Class
Handles view rendering and template compilation.

### Database Class
Provides database connection and query building.

### Session Class
Manages user sessions and flash messages.

### Cache Class
Handles application caching.

### Auth Class
Provides authentication functionality.

### Validator Class
Handles form and data validation.

For more detailed information about each component, please refer to the specific component documentation in the `docs/components/` directory.
