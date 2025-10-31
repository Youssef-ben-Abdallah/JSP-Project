package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.model.Category;
import org.example.model.SubCategory;
import org.example.service.CategoryService;
import org.example.service.SubCategoryService;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet(name = "SubCategoryController", urlPatterns = {"/admin/subcategories"})
public class SubCategoryController extends HttpServlet {
    private final SubCategoryService subCategoryService = new SubCategoryService();
    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Category> categories = Collections.emptyList();
        List<SubCategory> subcategories = Collections.emptyList();
        String categoryError = null;
        String subCategoryError = null;
        try {
            categories = categoryService.getAllCategories();
        } catch (Exception e) {
            e.printStackTrace();
            categoryError = "Impossible de charger les catégories.";
        }
        try {
            subcategories = subCategoryService.getAll();
        } catch (Exception e) {
            e.printStackTrace();
            subCategoryError = "Impossible de charger les sous-catégories.";
        }
        req.setAttribute("categories", categories);
        req.setAttribute("subcategories", subcategories);
        if (categoryError != null) {
            req.setAttribute("categoryLoadError", categoryError);
        }
        if (subCategoryError != null) {
            req.setAttribute("subCategoryLoadError", subCategoryError);
        }
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
