<!DOCTYPE html>
<html>
<head>
    <title>500 - Internal Server Error</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 40px;
            color: #333;
            text-align: center;
        }
        .error-container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            font-size: 72px;
            color: #e74c3c;
            margin: 0;
        }
        .error-message {
            font-size: 24px;
            margin: 20px 0;
        }
        .debug-info {
            text-align: left;
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
        <h1>500</h1>
        <div class="error-message">Internal Server Error</div>
        <p>Sorry, something went wrong on our servers.</p>
        
        if debug {
            <div class="debug-info">
                <h3>Debug Information</h3>
                <pre>
                    Error: {{ message }}
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
