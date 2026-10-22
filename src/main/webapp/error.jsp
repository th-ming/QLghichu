<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lá»—i - Sá»• Ghi ChÃº</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3">
</head>
<body>
    <div class="container error-container">
        <div class="error-card">
            <h1>âš ï¸ ÄÃ£ xáº£y ra lá»—i</h1>
            <p class="error-code">MÃ£ lá»—i: ${pageContext.errorData.statusCode}</p>
            <p class="error-message">${pageContext.errorData.throwable != null ? pageContext.errorData.throwable.message : "Lá»—i khÃ´ng xÃ¡c Ä‘á»‹nh"}</p>
            <a href="${pageContext.request.contextPath}/notes/" class="btn btn-primary">â† Vá» trang chá»§</a>
        </div>
    </div>
</body>
</html>