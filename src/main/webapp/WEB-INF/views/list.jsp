<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sổ Ghi Chú - Danh Sách</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=7">
</head>
<body>
    <div class="container">
        <header class="header">
            <div class="title-group">
                <h1>📝 Sổ Ghi Chú</h1>
                <p class="subtitle">${fn:length(notes)} ghi chú</p>
            </div>
            <a href="${pageContext.request.contextPath}/notes/new" class="btn btn-primary">+ Tạo Ghi Chú Mới</a>
        </header>

        <c:if test="${param.success != null}">
            <div class="alert alert-success">
                <c:choose>
                    <c:when test="${param.success == 'created'}">✅ Tạo ghi chú thành công!</c:when>
                    <c:when test="${param.success == 'updated'}">✅ Cập nhật ghi chú thành công!</c:when>
                    <c:when test="${param.success == 'deleted'}">✅ Xóa ghi chú thành công!</c:when>
                </c:choose>
            </div>
        </c:if>

        <c:if test="${param.error != null}">
            <div class="alert alert-error">
                <c:choose>
                    <c:when test="${param.error == 'delete_failed'}">❌ Không thể xóa ghi chú!</c:when>
                    <c:otherwise>❌ Đã có lỗi xảy ra!</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <form method="get" action="${pageContext.request.contextPath}/notes/" class="search-form">
            <input type="hidden" name="action" value="search">
            <div class="search-box">
                <input type="text" name="keyword" placeholder="🔍 Tìm kiếm ghi chú..." value="<c:out value='${keyword}'/>">
                <button type="submit" class="btn btn-search">Tìm kiếm</button>
                <c:if test="${keyword != null && keyword != ''}">
                    <a href="${pageContext.request.contextPath}/notes/" class="btn btn-secondary">Xóa bộ lọc</a>
                </c:if>
            </div>
        </form>

        <c:choose>
            <c:when test="${empty notes}">
                <div class="empty-state">
                    <p>📭 Chưa có ghi chú nào</p>
                    <a href="${pageContext.request.contextPath}/notes/new" class="btn btn-primary">Tạo ghi chú đầu tiên</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="notes-grid">
                    <c:forEach items="${notes}" var="note">
                        <article class="note-card">
                            <div class="note-header">
                                <h3 class="note-title"><c:out value="${note.title}"/></h3>
                                <div class="note-actions">
                                    <a href="${pageContext.request.contextPath}/notes/view?id=${note.id}" class="action">👁 Xem</a>
                                    <a href="${pageContext.request.contextPath}/notes/edit?id=${note.id}" class="action">✏️ Sửa</a>
                                    <a href="${pageContext.request.contextPath}/notes/delete?id=${note.id}" class="action action-danger" onclick="return confirm('Bạn có chắc muốn xóa ghi chú này?')">🗑 Xóa</a>
                                </div>
                            </div>
                            <div class="note-meta">
                                <span class="note-date">📅 Tạo: <fmt:formatDate value="${note.createdAt}" pattern="dd/MM/yyyy HH:mm" /></span>
                                <c:if test="${note.updatedAt != null && note.updatedAt != note.createdAt}">
                                    <span class="note-date">🔄 Sửa: <fmt:formatDate value="${note.updatedAt}" pattern="dd/MM/yyyy HH:mm" /></span>
                                </c:if>
                            </div>
                            <div class="note-preview"><c:out value="${note.content}"/></div>
                        </article>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js?v=2"></script>
</body>
</html>