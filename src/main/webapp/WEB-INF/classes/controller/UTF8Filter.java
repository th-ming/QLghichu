package controller;

import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class UTF8Filter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        if (response instanceof HttpServletResponse) {
            ((HttpServletResponse) response).setHeader("X-Content-Type-Options", "nosniff");
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
