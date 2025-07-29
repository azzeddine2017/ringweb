<!DOCTYPE html>
<html dir="{{ direction }}" lang="{{ lang }}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Email Verification</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
            background: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .header {
            background: #007bff;
            color: #fff;
            padding: 20px;
            text-align: center;
            border-radius: 5px 5px 0 0;
        }
        .content {
            padding: 20px;
        }
        .button {
            display: inline-block;
            padding: 12px 24px;
            background: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            margin: 20px 0;
        }
        .footer {
            text-align: center;
            padding: 20px;
            color: #666;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Email Verification</h1>
        </div>
        <div class="content">
            <h2>Hello {{ user_name }},</h2>
            <p>Thank you for registering at {{ app_name }}. To activate your account, please click the button below:</p>
            
            <center>
                <a href="{{ verification_url }}" class="button">Verify Email Address</a>
            </center>
            
            <p>Or copy and paste this URL into your browser:</p>
            <p>{{ verification_url }}</p>
            
            <p>This link will expire in {{ expiration_hours }} hours.</p>
            
            <p>If you did not create this account, you can safely ignore this email.</p>
        </div>
        <div class="footer">
            <p>Best regards,<br>The {{ app_name }} Team</p>
            <p> {{ current_year }} {{ app_name }}. All rights reserved</p>
        </div>
    </div>
</body>
</html>
