<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:choose><c:when test="${note != null && note.id > 0}">âœï¸ Sá»­a Ghi ChÃº</c:when><c:otherwise>âž• Táº¡o Ghi ChÃº Má»›i</c:otherwise></c:choose></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3">
</head>
<body>
    <div class="container form-container">
        <header class="header">
            <h1><c:choose><c:when test="${note != null && note.id > 0}">âœï¸ Sá»­a Ghi ChÃº</c:when><c:otherwise>âž• Táº¡o Ghi ChÃº Má»›i</c:otherwise></c:choose></h1>
            <a href="${pageContext.request.contextPath}/notes/" class="btn btn-secondary">â† Quay láº¡i</a>
        </header>

        <c:if test="${error != null}">
            <div class="alert alert-error"><c:out value="${error}"/></div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/notes/" class="note-form" id="noteForm">
            <input type="hidden" name="action" value="${note != null && note.id > 0 ? 'update' : 'save'}">
            <c:if test="${note != null && note.id > 0}">
                <input type="hidden" name="id" value="${note.id}">
            </c:if>

            <div class="form-group">
                <label for="title">TiÃªu Ä‘á» <span class="required">*</span></label>
                <input type="text" id="title" name="title" required maxlength="200"
                       value="<c:out value='${note.title}'/>"
                       placeholder="Nháº­p tiÃªu Ä‘á» ghi chÃº...">
            </div>

            <div class="form-group">
                <label for="content">Ná»™i dung <span class="required">*</span></label>
                <textarea id="content" name="content" required rows="15"
                          placeholder="Nháº­p ná»™i dung ghi chÃº..."><c:out value="${note.content}"/></textarea>
                <div class="char-count"><span id="charCount">0</span>/10000 kÃ½ tá»±</div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    <c:choose>
                        <c:when test="${note != null && note.id > 0}">ðŸ’¾ Cáº­p Nháº­t</c:when>
                        <c:otherwise>ðŸ’¾ LÆ°u Ghi ChÃº</c:otherwise>
                    </c:choose>
                </button>
                <a href="${pageContext.request.contextPath}/notes/" class="btn btn-secondary">Há»§y</a>
            </div>
        </form>
    </div>

    <footer class="site-footer">â€” Sá»• Ghi ChÃº Â· JSP/Servlet + MySQL â€”</footer>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>