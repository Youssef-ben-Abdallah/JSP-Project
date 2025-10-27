package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.service.CategoryService;

import java.io.IOException;

@WebServlet(name = "CategoryController", urlPatterns = {"/admin/categories"})
public class CategoryController extends HttpServlet {
    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("categories", categoryService.getCategoriesWithSubCategories());
        req.getRequestDispatcher("/WEB-INF/admin/categories.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("create".equals(action)) {
            categoryService.addCategory(
                    req.getParameter("name"),
                    req.getParameter("description")
            );
        } else if ("update".equals(action)) {
            categoryService.updateCategory(
                    Integer.parseInt(req.getParameter("id")),
                    req.getParameter("name"),
                    req.getParameter("description")
            );
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            categoryService.deleteCategory(id);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }
}
