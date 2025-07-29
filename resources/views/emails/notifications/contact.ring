<!DOCTYPE html>
<html dir="{{ direction }}" lang="{{ lang }}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Contact Form Message</title>
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
            background: #17a2b8;
            color: #fff;
            padding: 20px;
            text-align: center;
            border-radius: 5px 5px 0 0;
        }
        .content {
            padding: 20px;
        }
        .message-details {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
        .message-content {
            background: #fff;
            padding: 15px;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            margin: 20px 0;
        }
        .button {
            display: inline-block;
            padding: 12px 24px;
            background: #17a2b8;
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
            <h1>New Contact Form Message</h1>
        </div>
        <div class="content">
            <div class="message-details">
                <h3>Sender Details:</h3>
                <p>Name: {{ sender_name }}</p>
                <p>Email: {{ sender_email }}</p>
                <p>Date: {{ sent_date }}</p>
                <p>Subject: {{ subject }}</p>
            </div>
            
            <div class="message-content">
                <h3>Message:</h3>
                <p>{{ message }}</p>
            </div>
            
            <center>
                <a href="{{ reply_url }}" class="button">Reply to Message</a>
            </center>
        </div>
        <div class="footer">
            <p>This message was sent from the contact form at {{ app_name }}</p>
            <p> {{ current_year }} {{ app_name }}. All rights reserved</p>
        </div>
    </div>
</body>
</html>
