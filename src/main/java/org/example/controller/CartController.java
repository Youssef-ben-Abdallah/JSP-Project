package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.model.CartItem;
import org.example.model.Product;
import org.example.model.User;
import org.example.service.OrderService;
import org.example.service.ProductService;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "CartController", urlPatterns = {"/cart"})
public class CartController extends HttpServlet {
    private final ProductService productService = new ProductService();
    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            action = "add";
        }
        HttpSession session = req.getSession();
        Map<Integer, CartItem> cart = getCart(session);

        switch (action) {
            case "add" -> handleAdd(req, cart);
            case "remove" -> handleRemove(req, cart);
            case "update" -> handleUpdate(req, cart);
            case "checkout" -> {
                handleCheckout(req, resp, cart);
                return;
            }
            default -> {
            }
        }
        session.setAttribute("cart", cart);
        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    private void handleAdd(HttpServletRequest req, Map<Integer, CartItem> cart) {
        Integer productId = parseInteger(req.getParameter("productId"));
        int quantity = Math.max(1, parseInteger(req.getParameter("quantity")) != null ? parseInteger(req.getParameter("quantity")) : 1);
        if (productId == null) {
            req.setAttribute("cartError", "Produit invalide.");
            return;
        }
        try {
            Product product = productService.getById(productId);
            if (product == null) {
                req.setAttribute("cartError", "Produit introuvable.");
                return;
            }
            CartItem existing = cart.get(productId);
            if (existing == null) {
                cart.put(productId, new CartItem(product, quantity));
            } else {
                existing.setQuantity(existing.getQuantity() + quantity);
            }
            req.getSession().setAttribute("cartSuccess", "Ajouté au panier.");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("cartError", "Impossible d'ajouter au panier.");
        }
    }

    private void handleRemove(HttpServletRequest req, Map<Integer, CartItem> cart) {
        Integer productId = parseInteger(req.getParameter("productId"));
        if (productId != null) {
            cart.remove(productId);
            req.getSession().setAttribute("cartSuccess", "Article supprimé du panier.");
        }
    }

    private void handleUpdate(HttpServletRequest req, Map<Integer, CartItem> cart) {
        Integer productId = parseInteger(req.getParameter("productId"));
        Integer quantity = parseInteger(req.getParameter("quantity"));
        if (productId != null && quantity != null && quantity > 0) {
            CartItem item = cart.get(productId);
            if (item != null) {
                item.setQuantity(quantity);
                req.getSession().setAttribute("cartSuccess", "Quantité mise à jour.");
            }
        }
    }

    private void handleCheckout(HttpServletRequest req, HttpServletResponse resp, Map<Integer, CartItem> cart) throws IOException {
        if (cart.isEmpty()) {
            req.getSession().setAttribute("cartError", "Votre panier est vide.");
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            req.getSession().setAttribute("cartError", "Connectez-vous pour passer commande.");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        try {
            orderService.placeOrder(user.getId(), cart);
            req.getSession().setAttribute("cartSuccess", "Commande enregistrée !");
            req.getSession().setAttribute("cart", new HashMap<Integer, CartItem>());
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("cartError", "Impossible d'enregistrer la commande.");
            resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }

    @SuppressWarnings("unchecked")
    private Map<Integer, CartItem> getCart(HttpSession session) {
        Object existing = session.getAttribute("cart");
        if (existing instanceof Map) {
            return (Map<Integer, CartItem>) existing;
        }
        Map<Integer, CartItem> cart = new HashMap<>();
        session.setAttribute("cart", cart);
        return cart;
    }

    private Integer parseInteger(String value) {
        try {
            return value == null ? null : Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
