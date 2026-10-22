<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${note.title}"/> - Xem Ghi ChÃº</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3">
</head>
<body>
    <div class="container view-container">
        <header class="header">
            <h1><c:out value="${note.title}"/></h1>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/notes/edit?id=${note.id}" class="btn btn-primary">âœï¸ Chá»‰nh sá»­a</a>
                <a href="${pageContext.request.contextPath}/notes/" class="btn btn-secondary">â† Quay láº¡i danh sÃ¡ch</a>
            </div>
        </header>

        <article class="note-detail">
            <div class="note-meta">
                <span>ðŸ“… Táº¡o: <fmt:formatDate value="${note.createdAt}" pattern="dd/MM/yyyy HH:mm" /></span>
                <c:if test="${note.updatedAt != null && note.updatedAt != note.createdAt}">
                    <span>ðŸ”„ Sá»­a láº§n cuá»‘i: <fmt:formatDate value="${note.updatedAt}" pattern="dd/MM/yyyy HH:mm" /></span>
                </c:if>
            </div>

            <div class="note-content">
                <c:out value="${note.content}"/>
            </div>
        </article>

        <footer class="note-footer">
            <a href="${pageContext.request.contextPath}/notes/delete?id=${note.id}" class="btn btn-danger" onclick="return confirm('Báº¡n cÃ³ cháº¯c muá»‘n xÃ³a ghi chÃº nÃ y?')">ðŸ—‘ XÃ³a ghi chÃº nÃ y</a>
        </footer>
    </div>

    <footer class="site-footer">â€” Sá»• Ghi ChÃº Â· JSP/Servlet + MySQL â€”</footer>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>