<!DOCTYPE html>
<html>
<head>
    <title>Error {{ code }} - {{ aErrorTypes[code] }}</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 40px;
            color: #333;
        }
        .error-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #e74c3c;
            margin: 0 0 20px;
        }
        .error-code {
            font-size: 24px;
            color: #7f8c8d;
            margin-bottom: 10px;
        }
        .error-message {
            font-size: 18px;
            margin-bottom: 20px;
        }
        .debug-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 4px;
            margin-top: 20px;
        }
        .debug-info pre {
            margin: 0;
            white-space: pre-wrap;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">Error {{ code }}</div>
        <h1>{{ aErrorTypes[code] }}</h1>
        <div class="error-message">{{ message }}</div>
        
        if debug {
            <div class="debug-info">
                <h3>Debug Information</h3>
                <pre>
                    File: {{ file }}
                    Line: {{ line }}
                    Stack Trace:
                    {{ stackTrace }}
                </pre>
            </div>
        }
    </div>
</body>
</html>
