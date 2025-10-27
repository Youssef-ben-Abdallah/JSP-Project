package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.service.PromotionService;

import java.io.IOException;

@WebServlet(name = "PromotionController", urlPatterns = {"/admin/promotions"})
public class PromotionController extends HttpServlet {
    private final PromotionService promotionService = new PromotionService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("promotions", promotionService.getAll());
        req.getRequestDispatcher("/WEB-INF/admin/promotions.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("create".equals(action)) {
                promotionService.create(
                        req.getParameter("title"),
                        req.getParameter("description"),
                        req.getParameter("discountType"),
                        req.getParameter("discountValue"),
                        req.getParameter("startTime"),
                        req.getParameter("endTime")
                );
            } else if ("update".equals(action)) {
                promotionService.update(
                        Integer.parseInt(req.getParameter("id")),
                        req.getParameter("title"),
                        req.getParameter("description"),
                        req.getParameter("discountType"),
                        req.getParameter("discountValue"),
                        req.getParameter("startTime"),
                        req.getParameter("endTime")
                );
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                promotionService.delete(id);
            }
        } catch (IllegalArgumentException e) {
            req.getSession().setAttribute("promotionError", e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/promotions");
    }
}
