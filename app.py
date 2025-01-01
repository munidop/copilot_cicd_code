from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return """
    <html>
        <head>
            <style>
                @keyframes fadeIn {
                    from { opacity: 0; }
                    to { opacity: 1; }
                }
                .welcome-text {
                    animation: fadeIn 2s ease-in-out;
                    font-size: 24px;
                    color: #333;
                    text-align: center;
                    margin-top: 20%;
                }
                .additional-text {
                    animation: fadeIn 2s ease-in-out;
                    font-size: 18px;
                    color: #666;
                    text-align: center;
                    margin-top: 10px;
                }
            </style>
        </head>
        <body>
            <div class="welcome-text">
                Welcome to GitHub Copilot Training! Offered by LTT Team.
            </div>
            <div class="additional-text">
                - Designed by Jaya Narayana.
            </div>
            
        </body>
    </html>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
