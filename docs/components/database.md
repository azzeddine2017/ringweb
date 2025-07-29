# Database Component Documentation

## Overview
The Database component provides a fluent query builder and ORM functionality for database operations.

## Features
- Query Builder
- ORM (Object-Relational Mapping)
- Migrations
- Model Relationships
- Database Transactions
- Connection Management
- Query Logging

## Basic Usage

### Query Builder

#### Select Queries
```ring
# Basic select
aUsers = DB.table("users").get()

# Select specific columns
aUsers = DB.table("users")
          .select("id", "name", "email")
          .get()

# With conditions
aActiveUsers = DB.table("users")
                .where("status", "=", "active")
                .get()

# Complex conditions
aResults = DB.table("users")
            .where("age", ">", 18)
            .where("status", "=", "active")
            .orWhere("role", "=", "admin")
            .get()
```

#### Insert Operations
```ring
# Single insert
DB.table("users").insert([
    "name" = "John Doe",
    "email" = "john@example.com"
])

# Multiple insert
DB.table("users").insert([
    ["name" = "John", "email" = "john@example.com"],
    ["name" = "Jane", "email" = "jane@example.com"]
])
```

#### Update Operations
```ring
# Basic update
DB.table("users")
  .where("id", 1)
  .update(["status" = "inactive"])

# Mass update
DB.table("users")
  .where("status", "pending")
  .update(["status" = "active"])
```

#### Delete Operations
```ring
# Delete by ID
DB.table("users").where("id", 1).delete()

# Mass delete
DB.table("users")
  .where("status", "inactive")
  .delete()
```

### ORM Usage

#### Model Definition
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
    
    func profile
        return hasOne("Profile")
```

#### CRUD Operations
```ring
# Create
oUser = new User([
    "name" = "John Doe",
    "email" = "john@example.com"
])
oUser.save()

# Read
oUser = User.find(1)
aUsers = User.all()

# Update
oUser.name = "Jane Doe"
oUser.save()

# Delete
oUser.delete()
```

## Advanced Usage

### Relationships

#### One to One
```ring
Class User from Model
    func profile
        return hasOne("Profile")

Class Profile from Model
    func user
        return belongsTo("User")
```

#### One to Many
```ring
Class User from Model
    func posts
        return hasMany("Post")

Class Post from Model
    func user
        return belongsTo("User")
```

#### Many to Many
```ring
Class User from Model
    func roles
        return belongsToMany("Role", "role_user")

Class Role from Model
    func users
        return belongsToMany("User", "role_user")
```

### Transactions
```ring
# Basic transaction
DB.transaction(func() {
    User.create(userData)
    Profile.create(profileData)
})

# Manual transaction control
DB.beginTransaction()
try {
    User.create(userData)
    Profile.create(profileData)
    DB.commit()
catch e
    DB.rollback()
    throw e
}
```

### Query Scopes
```ring
Class User from Model
    # Global scope
    func boot
        addGlobalScope("active", func(oQuery) {
            return oQuery.where("status", "=", "active")
        })
    
    # Local scope
    func scopePopular oQuery
        return oQuery.where("followers", ">", 1000)
```

## Best Practices

### Security
1. Use prepared statements
2. Validate input data
3. Implement proper access control
4. Use transactions for critical operations
5. Sanitize output data

### Performance
1. Use eager loading for relationships
2. Index frequently queried columns
3. Optimize complex queries
4. Use query caching
5. Monitor query performance

## Examples

### Repository Pattern
```ring
Class UserRepository
    # Find user by email
    func findByEmail cEmail
        return User.where("email", "=", cEmail).first()
    
    # Get active users
    func getActive
        return User.where("status", "=", "active")
                  .orderBy("name")
                  .get()
    
    # Create user with profile
    func createWithProfile aUserData, aProfileData
        DB.transaction(func() {
            oUser = User.create(aUserData)
            oUser.profile().create(aProfileData)
            return oUser
        })
```

### Query Builder Examples
```ring
# Complex query
aUsers = DB.table("users as u")
          .select("u.*", "p.phone", "c.name as country")
          .join("profiles as p", "u.id", "=", "p.user_id")
          .leftJoin("countries as c", "u.country_id", "=", "c.id")
          .where("u.status", "=", "active")
          .where(func(oQuery) {
              oQuery.where("u.age", ">", 18)
                    .orWhere("u.role", "=", "admin")
          })
          .orderBy("u.name")
          .paginate(20)
```

### Model Events
```ring
Class User from Model
    func beforeSave
        if isNew() {
            self.created_at = now()
        }
        self.updated_at = now()
    
    func afterCreate
        # Send welcome email
        Mail.send("welcome", self.email, [
            "name" = self.name
        ])
```

## Error Handling

### Query Exceptions
```ring
try {
    DB.table("invalid_table").get()
catch e
    log("Database error: " + e.message)
}
```

### Transaction Handling
```ring
try {
    DB.transaction(func() {
        # Complex operations
    })
catch e
    log("Transaction failed: " + e.message)
    return false
}
```

## Debugging

### Query Logging
```ring
# Enable query logging
DB.enableQueryLog()

# Get executed queries
aQueries = DB.getQueryLog()

# Log specific query
DB.logQuery(cQuery, aBindings)
```
