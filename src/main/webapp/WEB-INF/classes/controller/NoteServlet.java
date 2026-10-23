package controller;

// NoteServlet - Controller trung tâm: nhận MỌI request /notes/* rồi điều phối
// theo mẫu MVC: nhận request -> gọi DAO (không viết SQL ở đây) -> forward JSP
// hoặc redirect. Không vẽ HTML, không đụng database trực tiếp.

import dao.NoteDAO;
import model.Note;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class NoteServlet extends HttpServlet {

    // Chỉ có 1 đối tượng DAO dùng chung cho mọi request (tạo 1 lần trong init)
    private NoteDAO noteDAO;

    // init() chạy ĐÚNG 1 LẦN khi Tomcat khởi động servlet (không phải mỗi request)
    @Override
    public void init() throws ServletException {
        noteDAO = new NoteDAO();
    }

    // doGet: xử lý request kiểu GET = user gõ URL hoặc bấm link
    // Mỗi URL /notes/<đường-dẫn> hoặc /notes/?action=... tương ứng 1 việc
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // pathInfo: phần sau "/notes" trên URL, ví dụ "/new", "/edit?id=3" -> "/edit"
        String pathInfo = req.getPathInfo();
        // action: giá trị tham số ?action=..., ví dụ ?action=search
        String action = req.getParameter("action");

        if ("search".equals(action)) {
            searchNotes(req, resp);                      // /notes/?action=search&keyword=...
        } else if (pathInfo == null || pathInfo.equals("/")) {
            listNotes(req, resp);                        // /notes/ -> trang danh sách
        } else if (pathInfo.equals("/new")) {
            showForm(req, resp);                         // /notes/new -> form tạo mới
        } else if (pathInfo.equals("/edit")) {
            showEditForm(req, resp);                     // /notes/edit?id=3 -> form sửa
        } else if (pathInfo.equals("/view")) {
            viewNote(req, resp);                         // /notes/view?id=3 -> xem chi tiết
        } else if (pathInfo.equals("/delete")) {
            deleteNote(req, resp);                       // /notes/delete?id=3 -> xóa
        } else {
            listNotes(req, resp);                        // đường lạ -> về danh sách (fallback, không 404)
        }
    }

    // doPost: xử lý request kiểu POST = trình duyệt submit form
    // (dữ liệu nằm trong thân request, không hiện trên URL)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Bắt buộc đọc thân request theo UTF-8, nếu không tiếng Việt submit lên thành ký tự rác
        req.setCharacterEncoding("UTF-8");
        // Form thêm và sửa dùng chung 1 file form.jsp, phân biệt bằng hidden field:
        // <input type="hidden" name="action" value="save"> hoặc "update"
        String action = req.getParameter("action");

        if ("save".equals(action)) {
            saveNote(req, resp);                         // POST action=save -> tạo mới
        } else if ("update".equals(action)) {
            updateNote(req, resp);                       // POST action=update -> cập nhật
        } else {
            resp.sendRedirect(req.getContextPath() + "/notes/");  // POST lạ -> về danh sách
        }
    }

    // Chuyển chuỗi id trên URL thành số một cách an toàn.
    // Không có hàm này thì gõ ?id=abc là Integer.parseInt ném exception -> app nổ lỗi 500.
    // Trả về -1 = "id không hợp lệ", nơi gọi chỉ cần check id <= 0.
    private int parseId(String raw) {
        if (raw == null || raw.trim().isEmpty()) {
            return -1;                                   // không có id trên URL
        }
        try {
            return Integer.parseInt(raw.trim());
        } catch (NumberFormatException e) {
            return -1;                                   // id không phải số ("abc", "3.5"...)
        }
    }

    // Trang danh sách: lấy hết ghi chú từ DB rồi render list.jsp
    private void listNotes(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Note> notes = noteDAO.getAllNotes();        // hỏi DAO lấy danh sách từ MySQL
        req.setAttribute("notes", notes);                // bỏ vào request để JSP đọc qua EL: ${notes}
        // forward = chuyển quyền render sang list.jsp, URL trên trình duyệt KHÔNG đổi.
        // JSP nằm trong WEB-INF nên user không bấm thẳng vào được, phải đi qua servlet.
        req.getRequestDispatcher("/WEB-INF/views/list.jsp").forward(req, resp);
    }

    // Form tạo mới: chỉ forward tới form.jsp, KHÔNG set attribute "note"
    // -> trong JSP ${note} rỗng -> form trắng, tiêu đề "Tạo Ghi Chú Mới"
    private void showForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/form.jsp").forward(req, resp);
    }

    // Form sửa: lấy ghi chú theo id rồi điền sẵn dữ liệu cũ vào form
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = parseId(req.getParameter("id"));
        if (id <= 0) {
            // id thiếu/không hợp lệ -> đá về danh sách; "return" để dừng, không chạy tiếp
            resp.sendRedirect(req.getContextPath() + "/notes/");
            return;
        }

        Note note = noteDAO.getNoteById(id);             // hỏi DB ghi chú này có tồn tại không
        if (note != null) {
            req.setAttribute("note", note);              // có -> form.jsp sẽ điền sẵn ${note.title}, ${note.content}
            req.getRequestDispatcher("/WEB-INF/views/form.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/notes/");  // id không tồn tại trong DB -> về danh sách
        }
    }

    // Trang xem chi tiết 1 ghi chú: logic giống showEditForm nhưng render view.jsp
    private void viewNote(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = parseId(req.getParameter("id"));
        if (id <= 0) {
            resp.sendRedirect(req.getContextPath() + "/notes/");
            return;
        }

        Note note = noteDAO.getNoteById(id);
        if (note != null) {
            req.setAttribute("note", note);              // view.jsp đọc ${note} để hiển thị nội dung đầy đủ
            req.getRequestDispatcher("/WEB-INF/views/view.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/notes/");
        }
    }

    // Nhận form TẠO MỚI (POST, hidden action=save)
    private void saveNote(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        // Lấy dữ liệu người dùng gõ từ các ô input name="title" và name="content"
        String title = req.getParameter("title");
        String content = req.getParameter("content");

        // Gói thành đối tượng Model rồi đưa xuống DAO chạy INSERT
        Note note = new Note(title, content);
        if (noteDAO.addNote(note)) {
            // Thành công: redirect về danh sách kèm thông báo.
            // Đây là mẫu Post/Redirect/Get - sau POST redirect về GET
            // nên bấm F5 không bị tạo trùng ghi chú.
            // getContextPath() = tên app ("/QLghichu") lấy động, đổi tên app không phải sửa code.
            resp.sendRedirect(req.getContextPath() + "/notes/?success=created");
        } else {
            // Thất bại (vd DB lỗi): quay lại form
            req.setAttribute("error", "Không thể tạo ghi chú");  // list.jsp hiện dòng thông báo đỏ
            req.setAttribute("note", note);                      // trả lại dữ liệu user vừa gõ - không phải gõ lại
            req.getRequestDispatcher("/WEB-INF/views/form.jsp").forward(req, resp);
        }
    }

    // Nhận form SỬA (POST, hidden action=update)
    private void updateNote(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        // id lấy từ hidden field <input type="hidden" name="id"> trong form
        int id = parseId(req.getParameter("id"));
        if (id <= 0) {
            resp.sendRedirect(req.getContextPath() + "/notes/");
            return;
        }

        String title = req.getParameter("title");
        String content = req.getParameter("content");

        // Tạo note mới với dữ liệu vừa sửa, rồi gắn id vào
        // -> DAO biết phải UPDATE đúng dòng nào trong bảng
        Note note = new Note(title, content);
        note.setId(id);

        if (noteDAO.updateNote(note)) {
            resp.sendRedirect(req.getContextPath() + "/notes/?success=updated");
        } else {
            req.setAttribute("error", "Không thể cập nhật ghi chú");
            req.setAttribute("note", note);              // giữ lại dữ liệu đã sửa cho user
            req.getRequestDispatcher("/WEB-INF/views/form.jsp").forward(req, resp);
        }
    }

    // Xóa ghi chú (GET /notes/delete?id=n) - nút xóa trên card gọi link này
    private void deleteNote(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = parseId(req.getParameter("id"));
        if (id <= 0) {
            // Xóa luôn redirect kể cả khi lỗi, vì xóa là hành động đổi dữ liệu
            // -> sau đó phải chuyển trang (mẫu Post/Redirect/Get)
            resp.sendRedirect(req.getContextPath() + "/notes/?error=delete_failed");
            return;
        }

        if (noteDAO.deleteNote(id)) {
            resp.sendRedirect(req.getContextPath() + "/notes/?success=deleted");   // list.jsp hiện "Đã xóa"
        } else {
            resp.sendRedirect(req.getContextPath() + "/notes/?error=delete_failed");
        }
    }

    // Tìm kiếm: /notes/?action=search&keyword=...
    // Kết quả vẫn render bằng chính trang list.jsp
    private void searchNotes(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");    // từ khóa gõ vào ô tìm kiếm
        List<Note> notes;

        if (keyword != null && !keyword.trim().isEmpty()) {
            notes = noteDAO.searchNotes(keyword.trim()); // có từ khóa -> tìm trong DB (title + content)
            req.setAttribute("keyword", keyword);        // giữ từ khóa trong ô input của trang kết quả
        } else {
            notes = noteDAO.getAllNotes();               // ô tìm rỗng -> hiện tất cả
        }

        req.setAttribute("notes", notes);
        req.getRequestDispatcher("/WEB-INF/views/list.jsp").forward(req, resp);
    }
}
