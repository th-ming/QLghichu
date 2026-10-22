<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi - Sổ Ghi Chú</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=4">
</head>
<body>
    <div class="container error-container">
        <div class="error-card">
            <h1>⚠️ Đã xảy ra lỗi</h1>
            <p class="error-code">Mã lỗi: ${pageContext.errorData.statusCode}</p>
            <p class="error-message">${pageContext.errorData.throwable != null ? pageContext.errorData.throwable.message : "Lỗi không xác định"}</p>
            <a href="${pageContext.request.contextPath}/notes/" class="btn btn-primary">← Về trang chủ</a>
        </div>
    </div>
</body>
</html>