# Mail Component Documentation

## Overview
The Mail component provides a clean, simple API for sending emails with support for multiple drivers and templates.

## Features
- Multiple mail drivers
- Email templates
- Attachments
- HTML and plain text emails
- Queue support
- Event handling
- Template variables
- SMTP configuration

## Basic Usage

### Sending Emails
```ring
# Basic email
Mail.to("user@example.com")
    .subject("Welcome")
    .send("emails.welcome")

# With data
Mail.to("user@example.com")
    .subject("Order Confirmation")
    .with([
        "order" = oOrder,
        "user" = oUser
    ])
    .send("emails.order")

# Multiple recipients
Mail.to(["user1@example.com", "user2@example.com"])
    .subject("Newsletter")
    .send("emails.newsletter")
```

### Email Templates
```ring
# emails/welcome.ring
<h1>Welcome, {{ oUser.name }}!</h1>
<p>Thank you for joining our platform.</p>

# emails/order.ring
<div class="order">
    <h2>Order #{{ oOrder.id }}</h2>
    <p>Total: ${{ oOrder.total }}</p>
    for oItem in oOrder.items {
        <div class="item">
            {{ oItem.name }} - ${{ oItem.price }}
        </div>
    }
</div>
```

## Advanced Usage

### Mail Configuration
```ring
# SMTP configuration
Mail.config([
    "driver" = "smtp",
    "host" = "smtp.mailtrap.io",
    "port" = 2525,
    "username" = "username",
    "password" = "password",
    "encryption" = "tls"
])

# Amazon SES configuration
Mail.config([
    "driver" = "ses",
    "key" = "aws-key",
    "secret" = "aws-secret",
    "region" = "us-west-2"
])
```

### Attachments
```ring
# Add file attachment
Mail.to("user@example.com")
    .subject("Documents")
    .attach("path/to/file.pdf")
    .send("emails.documents")

# Add multiple attachments
Mail.to("user@example.com")
    .subject("Photos")
    .attach([
        "photo1.jpg",
        "photo2.jpg"
    ])
    .send("emails.photos")

# Inline attachments
Mail.to("user@example.com")
    .subject("Profile")
    .embedImage("photo.jpg", "profile-image")
    .send("emails.profile")
```

## Best Practices

### Security
1. Validate email addresses
2. Use encryption (TLS/SSL)
3. Implement rate limiting
4. Secure credentials
5. Validate attachments

### Performance
1. Use queue for bulk emails
2. Optimize templates
3. Manage attachment sizes
4. Monitor sending rates
5. Use appropriate drivers

## Examples

### Welcome Email
```ring
Class WelcomeEmail
    func send oUser
        return Mail.to(oUser.email)
                  .subject("Welcome to " + app().name)
                  .with([
                      "user" = oUser,
                      "activationUrl" = this.getActivationUrl(oUser)
                  ])
                  .send("emails.welcome")
    
    func getActivationUrl oUser
        return url("/activate/" + oUser.activation_token)
```

### Order Confirmation
```ring
Class OrderMailer
    func sendConfirmation oOrder
        return Mail.to(oOrder.user.email)
                  .subject("Order #" + oOrder.id + " Confirmation")
                  .with([
                      "order" = oOrder,
                      "user" = oOrder.user,
                      "items" = oOrder.items
                  ])
                  .attach(this.generateInvoice(oOrder))
                  .send("emails.orders.confirmation")
    
    func generateInvoice oOrder
        # Generate PDF invoice
        return "invoices/" + oOrder.id + ".pdf"
```

### Newsletter System
```ring
Class NewsletterSystem
    func broadcast oNewsletter, aSubscribers
        for oSubscriber in aSubscribers {
            Mail.to(oSubscriber.email)
                .subject(oNewsletter.subject)
                .with([
                    "content" = oNewsletter.content,
                    "subscriber" = oSubscriber,
                    "unsubscribeUrl" = this.getUnsubscribeUrl(oSubscriber)
                ])
                .queue("emails.newsletter")
        }
```

### Password Reset
```ring
Class PasswordResetMailer
    func sendResetLink oUser, cToken
        return Mail.to(oUser.email)
                  .subject("Reset Your Password")
                  .with([
                      "user" = oUser,
                      "resetUrl" = url("/password/reset/" + cToken),
                      "expiresIn" = "60 minutes"
                  ])
                  .send("emails.auth.reset")
```

## Error Handling

### Mail Exceptions
```ring
try {
    Mail.send()
catch e
    log("Mail error: " + e.message)
    notify("Mail sending failed")
}
```

### Failed Recipients
```ring
Class FailedMailHandler
    func handle oMail, e
        # Log failure
        log("Failed to send email to: " + oMail.to)
        
        # Notify admin
        notify("Mail delivery failed", [
            "recipient" = oMail.to,
            "error" = e.message
        ])
        
        # Retry if appropriate
        if this.shouldRetry(e) {
            Queue.later("5m", func() {
                Mail.send(oMail)
            })
        }
```

## Debugging

### Mail Information
```ring
# Get mailer configuration
aConfig = Mail.getConfig()

# Test connection
if Mail.testConnection() {
    # Connection successful
}

# Get last sent message
oMessage = Mail.getLastMessage()
```

### Mail Events
```ring
Class MailEventHandler
    func sending oMail
        log("Sending mail to: " + oMail.to)
    
    func sent oMail
        log("Mail sent successfully")
    
    func failed oMail, e
        log("Mail sending failed: " + e.message)
```

### Template Testing
```ring
Class MailPreview
    func preview cTemplate, aData
        return Mail.template(cTemplate)
                  .with(aData)
                  .render()
    
    func previewInBrowser cTemplate, aData
        return response(this.preview(cTemplate, aData))
               .header("Content-Type", "text/html")
```
