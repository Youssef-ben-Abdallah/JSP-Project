package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.model.SubCategory;
import org.example.service.CategoryService;
import org.example.service.ProductService;
import org.example.service.SubCategoryService;

import java.io.IOException;

@WebServlet(name = "ProductController", urlPatterns = {"/products", "/product", "/admin/products"})
public class ProductController extends HttpServlet {
    private final ProductService productService = new ProductService();
    private final CategoryService categoryService = new CategoryService();
    private final SubCategoryService subCategoryService = new SubCategoryService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/products".equals(path)) {
            Integer categoryId = parseInteger(req.getParameter("categoryId"));
            Integer subCategoryId = parseInteger(req.getParameter("subCategoryId"));
            if (subCategoryId != null) {
                req.setAttribute("products", productService.getBySubCategory(subCategoryId));
                SubCategory selected = subCategoryService.getById(subCategoryId);
                req.setAttribute("selectedSubCategory", selected);
                if (selected != null) {
                    req.setAttribute("selectedCategory", categoryService.getById(selected.getCategoryId()));
                }
            } else if (categoryId != null) {
                req.setAttribute("products", productService.getByCategory(categoryId));
                req.setAttribute("selectedCategory", categoryService.getById(categoryId));
            } else {
                req.setAttribute("products", productService.getAll());
            }
            req.getRequestDispatcher("/products.jsp").forward(req, resp);
            return;
        }
        if ("/product".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));
            req.setAttribute("product", productService.getById(id));
            req.getRequestDispatcher("/product-details.jsp").forward(req, resp);
            return;
        }
        req.setAttribute("products", productService.getAll());
        req.setAttribute("categories", categoryService.getAllCategories());
        req.setAttribute("subCategories", subCategoryService.getAll());
        req.getRequestDispatcher("/WEB-INF/admin/products.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/admin/products".equals(path)) {
            String action = req.getParameter("action");
            if ("create".equals(action)) {
                Integer subCategoryId = parseInteger(req.getParameter("subCategoryId"));
                productService.addProduct(
                        req.getParameter("name"),
                        req.getParameter("description"),
                        Double.parseDouble(req.getParameter("price")),
                        req.getParameter("imageUrl"),
                        Integer.parseInt(req.getParameter("categoryId")),
                        subCategoryId
                );
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                productService.deleteProduct(id);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/products");
        }
    }

    private Integer parseInteger(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
