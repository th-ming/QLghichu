<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sá»• Ghi ChÃº - Danh SÃ¡ch</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3">
</head>
<body>
    <div class="container">
        <header class="header">
            <div class="title-group">
                <h1>ðŸ“ Sá»• Ghi ChÃº</h1>
                <p class="subtitle">${fn:length(notes)} ghi chÃº</p>
            </div>
            <a href="${pageContext.request.contextPath}/notes/new" class="btn btn-primary">+ Táº¡o Ghi ChÃº Má»›i</a>
        </header>

        <c:if test="${param.success != null}">
            <div class="alert alert-success">
                <c:choose>
                    <c:when test="${param.success == 'created'}">âœ… Táº¡o ghi chÃº thÃ nh cÃ´ng!</c:when>
                    <c:when test="${param.success == 'updated'}">âœ… Cáº­p nháº­t ghi chÃº thÃ nh cÃ´ng!</c:when>
                    <c:when test="${param.success == 'deleted'}">âœ… XÃ³a ghi chÃº thÃ nh cÃ´ng!</c:when>
                </c:choose>
            </div>
        </c:if>

        <c:if test="${param.error != null}">
            <div class="alert alert-error">
                <c:choose>
                    <c:when test="${param.error == 'delete_failed'}">âŒ KhÃ´ng thá»ƒ xÃ³a ghi chÃº!</c:when>
                    <c:otherwise>âŒ ÄÃ£ cÃ³ lá»—i xáº£y ra!</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <form method="get" action="${pageContext.request.contextPath}/notes/" class="search-form">
            <input type="hidden" name="action" value="search">
            <div class="search-box">
                <input type="text" name="keyword" placeholder="ðŸ” TÃ¬m kiáº¿m ghi chÃº..." value="<c:out value='${keyword}'/>">
                <button type="submit" class="btn btn-search">TÃ¬m kiáº¿m</button>
                <c:if test="${keyword != null && keyword != ''}">
                    <a href="${pageContext.request.contextPath}/notes/" class="btn btn-secondary">XÃ³a bá»™ lá»c</a>
                </c:if>
            </div>
        </form>

        <c:choose>
            <c:when test="${empty notes}">
                <div class="empty-state">
                    <p>ðŸ“­ ChÆ°a cÃ³ ghi chÃº nÃ o</p>
                    <a href="${pageContext.request.contextPath}/notes/new" class="btn btn-primary">Táº¡o ghi chÃº Ä‘áº§u tiÃªn</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="notes-grid">
                    <c:forEach items="${notes}" var="note">
                        <article class="note-card">
                            <div class="note-header">
                                <h3 class="note-title"><c:out value="${note.title}"/></h3>
                                <div class="note-actions">
                                    <a href="${pageContext.request.contextPath}/notes/view?id=${note.id}" class="action">ðŸ‘ Xem</a>
                                    <a href="${pageContext.request.contextPath}/notes/edit?id=${note.id}" class="action">âœï¸ Sá»­a</a>
                                    <a href="${pageContext.request.contextPath}/notes/delete?id=${note.id}" class="action action-danger" onclick="return confirm('Báº¡n cÃ³ cháº¯c muá»‘n xÃ³a ghi chÃº nÃ y?')">ðŸ—‘ XÃ³a</a>
                                </div>
                            </div>
                            <div class="note-meta">
                                <span class="note-date">ðŸ“… Táº¡o: <fmt:formatDate value="${note.createdAt}" pattern="dd/MM/yyyy HH:mm" /></span>
                                <c:if test="${note.updatedAt != null && note.updatedAt != note.createdAt}">
                                    <span class="note-date">ðŸ”„ Sá»­a: <fmt:formatDate value="${note.updatedAt}" pattern="dd/MM/yyyy HH:mm" /></span>
                                </c:if>
                            </div>
                            <div class="note-preview"><c:out value="${note.content}"/></div>
                        </article>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <footer class="site-footer">â€” Sá»• Ghi ChÃº Â· JSP/Servlet + MySQL â€”</footer>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>