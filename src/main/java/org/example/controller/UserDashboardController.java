package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.model.Order;
import org.example.model.User;
import org.example.service.OrderService;
import org.example.service.UserService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "UserDashboardController", urlPatterns = {"/dashboard"})
public class UserDashboardController extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (userService.isAdmin(user)) {
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
            return;
        }

        List<Order> orders = orderService.getOrdersForUser(user.getId());
        req.setAttribute("orders", orders);
        req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
    }
}
