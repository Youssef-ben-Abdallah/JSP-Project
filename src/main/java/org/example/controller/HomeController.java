package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.model.Product;
import org.example.service.ProductService;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet(name = "HomeController", urlPatterns = {"/", "/home"})
public class HomeController extends HttpServlet {
    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Product> products = Collections.emptyList();
        try {
            products = productService.getAll();
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("catalogError", "Impossible de charger les produits pour le moment.");
        }
        req.setAttribute("products", products);
        req.getRequestDispatcher("/home.jsp").forward(req, resp);
    }
}
