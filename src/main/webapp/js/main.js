// NoteManager - Client-side JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Character counter for textarea
    const contentTextarea = document.getElementById('content');
    const charCount = document.getElementById('charCount');

    if (contentTextarea && charCount) {
        function updateCharCount() {
            const length = contentTextarea.value.length;
            charCount.textContent = length;

            if (length > 9000) {
                charCount.style.color = '#e74c3c';
            } else if (length > 7000) {
                charCount.style.color = '#f39c12';
            } else {
                charCount.style.color = '#95a5a6';
            }
        }

        contentTextarea.addEventListener('input', updateCharCount);
        updateCharCount();
    }

    // Auto-dismiss alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-10px)';
            alert.style.transition = 'opacity 0.5s, transform 0.5s';
            setTimeout(() => alert.remove(), 500);
        }, 5000);
    });

    // Confirm delete with sweet confirmation
    const deleteLinks = document.querySelectorAll('.btn-delete, .btn-danger');
    deleteLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            if (!confirm('Bạn có chắc chắn muốn xóa ghi chú này? Hành động này không thể hoàn tác.')) {
                e.preventDefault();
            }
        });
    });

    // Form validation
    const noteForm = document.getElementById('noteForm');
    if (noteForm) {
        noteForm.addEventListener('submit', function(e) {
            const title = document.getElementById('title').value.trim();
            const content = document.getElementById('content').value.trim();

            if (!title) {
                e.preventDefault();
                alert('Vui lòng nhập tiêu đề ghi chú');
                document.getElementById('title').focus();
                return;
            }

            if (!content) {
                e.preventDefault();
                alert('Vui lòng nhập nội dung ghi chú');
                document.getElementById('content').focus();
                return;
            }

            if (title.length > 200) {
                e.preventDefault();
                alert('Tiêu đề không được quá 200 ký tự');
                return;
            }

            if (content.length > 10000) {
                e.preventDefault();
                alert('Nội dung không được quá 10.000 ký tự');
                return;
            }
        });
    }

    // Keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        // Ctrl/Cmd + Enter to submit form
        if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
            const form = document.getElementById('noteForm');
            if (form) {
                form.submit();
            }
        }

        // Escape to go back
        if (e.key === 'Escape') {
            const backLink = document.querySelector('.btn-secondary');
            if (backLink) {
                window.location.href = backLink.href;
            }
        }
    });

    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({ behavior: 'smooth' });
            }
        });
    });
});

// Utility functions
const NoteManager = {
    // Format date for display
    formatDate: function(date) {
        return new Intl.DateTimeFormat('vi-VN', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        }).format(date);
    },

    // Truncate text
    truncate: function(text, length) {
        if (text.length <= length) return text;
        return text.substring(0, length) + '...';
    },

    // Show toast notification
    showToast: function(message, type = 'info') {
        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        toast.textContent = message;
        toast.style.cssText = `
            position: fixed;
            bottom: 20px;
            right: 20px;
            padding: 15px 25px;
            border-radius: 6px;
            color: white;
            font-weight: 500;
            z-index: 1000;
            animation: slideIn 0.3s ease;
        `;

        const colors = {
            success: '#27ae60',
            error: '#e74c3c',
            info: '#3498db',
            warning: '#f39c12'
        };
        toast.style.backgroundColor = colors[type] || colors.info;

        document.body.appendChild(toast);

        setTimeout(() => {
            toast.style.animation = 'slideOut 0.3s ease';
            setTimeout(() => toast.remove(), 300);
        }, 3000);
    }
};

// Add toast animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    @keyframes slideOut {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(100%); opacity: 0; }
    }
`;
document.head.appendChild(style);