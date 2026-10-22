<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:choose><c:when test="${note != null && note.id > 0}">✏️ Sửa Ghi Chú</c:when><c:otherwise>➕ Tạo Ghi Chú Mới</c:otherwise></c:choose></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container form-container">
        <header class="header">
            <h1><c:choose><c:when test="${note != null && note.id > 0}">✏️ Sửa Ghi Chú</c:when><c:otherwise>➕ Tạo Ghi Chú Mới</c:otherwise></c:choose></h1>
            <a href="${pageContext.request.contextPath}/notes/" class="btn btn-secondary">← Quay lại</a>
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
                <label for="title">Tiêu đề <span class="required">*</span></label>
                <input type="text" id="title" name="title" required maxlength="200"
                       value="<c:out value='${note.title}'/>"
                       placeholder="Nhập tiêu đề ghi chú...">
            </div>

            <div class="form-group">
                <label for="content">Nội dung <span class="required">*</span></label>
                <textarea id="content" name="content" required rows="15"
                          placeholder="Nhập nội dung ghi chú..."><c:out value="${note.content}"/></textarea>
                <div class="char-count"><span id="charCount">0</span>/10000 ký tự</div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    <c:choose>
                        <c:when test="${note != null && note.id > 0}">💾 Cập Nhật</c:when>
                        <c:otherwise>💾 Lưu Ghi Chú</c:otherwise>
                    </c:choose>
                </button>
                <a href="${pageContext.request.contextPath}/notes/" class="btn btn-secondary">Hủy</a>
            </div>
        </form>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>