package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.service.CategoryService;
import org.example.service.SubCategoryService;

import java.io.IOException;

@WebServlet(name = "SubCategoryController", urlPatterns = {"/admin/subcategories"})
public class SubCategoryController extends HttpServlet {
    private final SubCategoryService subCategoryService = new SubCategoryService();
    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("categories", categoryService.getAllCategories());
        req.setAttribute("subcategories", subCategoryService.getAll());
        req.getRequestDispatcher("/WEB-INF/admin/subcategories.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("create".equals(action)) {
            subCategoryService.addSubCategory(
                    req.getParameter("name"),
                    req.getParameter("description"),
                    Integer.parseInt(req.getParameter("categoryId"))
            );
        } else if ("update".equals(action)) {
            subCategoryService.updateSubCategory(
                    Integer.parseInt(req.getParameter("id")),
                    req.getParameter("name"),
                    req.getParameter("description"),
                    Integer.parseInt(req.getParameter("categoryId"))
            );
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            subCategoryService.deleteSubCategory(id);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/subcategories");
    }
}
