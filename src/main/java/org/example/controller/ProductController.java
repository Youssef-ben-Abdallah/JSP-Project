package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.service.CategoryService;
import org.example.service.ProductService;

import java.io.IOException;

@WebServlet(name = "ProductController", urlPatterns = {"/products", "/product", "/admin/products"})
public class ProductController extends HttpServlet {
    private final ProductService productService = new ProductService();
    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/products".equals(path)) {
            req.setAttribute("products", productService.getAll());
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
        req.getRequestDispatcher("/WEB-INF/admin/products.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/admin/products".equals(path)) {
            String action = req.getParameter("action");
            if ("create".equals(action)) {
                productService.addProduct(
                        req.getParameter("name"),
                        req.getParameter("description"),
                        Double.parseDouble(req.getParameter("price")),
                        req.getParameter("imageUrl"),
                        Integer.parseInt(req.getParameter("categoryId"))
                );
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                productService.deleteProduct(id);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/products");
        }
    }
}
