package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebServlet("/page/*")
public class PageRouterS extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final List<String> allowedPages = Arrays.asList(
        "index", "admin-dashboard", "adminLogin", "agent-dashboard", "agentLogin",
        "create-agent", "donation-form", "donor-form","editAgent", "editDonation", "editDonor","MakePDF"
    );

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo(); // /index or /admin-dashboard

        if (path == null || path.equals("/")) {
            request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);
            return;
        }

        String page = path.substring(1); // remove leading slash

        if (allowedPages.contains(page)) {
            request.getRequestDispatcher("/WEB-INF/views/" + page + ".jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page not found");
        }
    }
}

