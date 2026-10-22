package controller;

import dao.NoteDAO;
import model.Note;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class NoteServlet extends HttpServlet {
    private NoteDAO noteDAO;

    @Override
    public void init() throws ServletException {
        noteDAO = new NoteDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = req.getParameter("action");

        if ("search".equals(action)) {
            searchNotes(req, resp);
        } else if (pathInfo == null || pathInfo.equals("/")) {
            listNotes(req, resp);
        } else if (pathInfo.equals("/new")) {
            showForm(req, resp);
        } else if (pathInfo.equals("/edit")) {
            showEditForm(req, resp);
        } else if (pathInfo.equals("/view")) {
            viewNote(req, resp);
        } else if (pathInfo.equals("/delete")) {
            deleteNote(req, resp);
        } else {
            listNotes(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("save".equals(action)) {
            saveNote(req, resp);
        } else if ("update".equals(action)) {
            updateNote(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/notes/");
        }
    }

    private int parseId(String raw) {
        if (raw == null || raw.trim().isEmpty()) {
            return -1;
        }
        try {
            return Integer.parseInt(raw.trim());
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    private void listNotes(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Note> notes = noteDAO.getAllNotes();
        req.setAttribute("notes", notes);
        req.getRequestDispatcher("/WEB-INF/views/list.jsp").forward(req, resp);
    }

    private void showForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/form.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = parseId(req.getParameter("id"));
        if (id <= 0) {
            resp.sendRedirect(req.getContextPath() + "/notes/");
            return;
        }

        Note note = noteDAO.getNoteById(id);
        if (note != null) {
            req.setAttribute("note", note);
            req.getRequestDispatcher("/WEB-INF/views/form.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/notes/");
        }
    }

    private void viewNote(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = parseId(req.getParameter("id"));
        if (id <= 0) {
            resp.sendRedirect(req.getContextPath() + "/notes/");
            return;
        }

        Note note = noteDAO.getNoteById(id);
        if (note != null) {
            req.setAttribute("note", note);
            req.getRequestDispatcher("/WEB-INF/views/view.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/notes/");
        }
    }

    private void saveNote(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String title = req.getParameter("title");
        String content = req.getParameter("content");

        Note note = new Note(title, content);
        if (noteDAO.addNote(note)) {
            resp.sendRedirect(req.getContextPath() + "/notes/?success=created");
        } else {
            req.setAttribute("error", "Không thể tạo ghi chú");
            req.setAttribute("note", note);
            req.getRequestDispatcher("/WEB-INF/views/form.jsp").forward(req, resp);
        }
    }

    private void updateNote(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        int id = parseId(req.getParameter("id"));
        if (id <= 0) {
            resp.sendRedirect(req.getContextPath() + "/notes/");
            return;
        }

        String title = req.getParameter("title");
        String content = req.getParameter("content");

        Note note = new Note(title, content);
        note.setId(id);

        if (noteDAO.updateNote(note)) {
            resp.sendRedirect(req.getContextPath() + "/notes/?success=updated");
        } else {
            req.setAttribute("error", "Không thể cập nhật ghi chú");
            req.setAttribute("note", note);
            req.getRequestDispatcher("/WEB-INF/views/form.jsp").forward(req, resp);
        }
    }

    private void deleteNote(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = parseId(req.getParameter("id"));
        if (id <= 0) {
            resp.sendRedirect(req.getContextPath() + "/notes/?error=delete_failed");
            return;
        }

        if (noteDAO.deleteNote(id)) {
            resp.sendRedirect(req.getContextPath() + "/notes/?success=deleted");
        } else {
            resp.sendRedirect(req.getContextPath() + "/notes/?error=delete_failed");
        }
    }

    private void searchNotes(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        List<Note> notes;

        if (keyword != null && !keyword.trim().isEmpty()) {
            notes = noteDAO.searchNotes(keyword.trim());
            req.setAttribute("keyword", keyword);
        } else {
            notes = noteDAO.getAllNotes();
        }

        req.setAttribute("notes", notes);
        req.getRequestDispatcher("/WEB-INF/views/list.jsp").forward(req, resp);
    }
}
