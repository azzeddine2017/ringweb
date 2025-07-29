<!DOCTYPE html>
<html dir="{{ direction }}" lang="{{ lang }}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation #{{ order_number }}</title>
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
            background: #28a745;
            color: #fff;
            padding: 20px;
            text-align: center;
            border-radius: 5px 5px 0 0;
        }
        .content {
            padding: 20px;
        }
        .order-details {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
        .order-items {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        .order-items th,
        .order-items td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }
        .order-items th {
            background: #f8f9fa;
        }
        .total {
            font-size: 18px;
            font-weight: bold;
            text-align: right;
            margin-top: 20px;
        }
        .button {
            display: inline-block;
            padding: 12px 24px;
            background: #28a745;
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
            <h1>Order Confirmation #{{ order_number }}</h1>
        </div>
        <div class="content">
            <h2>Hello {{ user_name }},</h2>
            <p>Thank you for your order from {{ app_name }}. Your order has been received and is being processed.</p>
            
            <div class="order-details">
                <h3>Order Details:</h3>
                <p>Order Number: #{{ order_number }}</p>
                <p>Order Date: {{ order_date }}</p>
                <p>Order Status: {{ order_status }}</p>
            </div>
            
            <table class="order-items">
                <thead>
                    <tr>
                        <th>Product</th>
                        <th>Quantity</th>
                        <th>Price</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    {{ order_items }}
                </tbody>
            </table>
            
            <div class="total">
                <p>Subtotal: {{ subtotal }}</p>
                <p>Tax: {{ tax }}</p>
                <p>Shipping: {{ shipping }}</p>
                <p>Total: {{ total }}</p>
            </div>
            
            <center>
                <a href="{{ order_url }}" class="button">Track Your Order</a>
            </center>
            
            <p>If you have any questions about your order, please don't hesitate to contact us.</p>
        </div>
        <div class="footer">
            <p>Best regards,<br>The {{ app_name }} Team</p>
            <p> {{ current_year }} {{ app_name }}. All rights reserved</p>
        </div>
    </div>
</body>
</html>
