-- NoteManager Database Setup
-- Chạy script này trong MySQL để tạo database và bảng

CREATE DATABASE IF NOT EXISTS notemanager
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE notemanager;

CREATE TABLE IF NOT EXISTS notes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_created_at (created_at),
    INDEX idx_title (title)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dữ liệu mẫu (optional)
INSERT INTO notes (title, content) VALUES
('Chào mừng đến với Sổ Ghi Chú', 'Đây là ghi chú đầu tiên của bạn. Bạn có thể tạo, sửa, xóa và tìm kiếm ghi chú dễ dàng.'),
('Hướng dẫn sử dụng', '- Nhấn "Tạo Ghi Chú Mới" để bắt đầu\n- Sử dụng ô tìm kiếm để lọc ghi chú\n- Nhấn "Xem" để xem chi tiết\n- Nhấn "Sửa" để chỉnh sửa\n- Nhấn "Xóa" để xóa ghi chú'),
('Mẹo hay', 'Bạn có thể dùng phím tắt:\n- Ctrl+Enter: Lưu ghi chú\n- Escape: Quay lại danh sách');

-- Kiểm tra dữ liệu
SELECT * FROM notes;