package org.example.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.example.model.Category;
import org.example.model.CartItem;
import org.example.model.Promotion;
import org.example.model.User;
import org.example.service.CategoryService;
import org.example.service.PromotionService;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@WebFilter("/*")
public class NavigationDataFilter implements Filter {
    private final CategoryService categoryService = new CategoryService();
    private final PromotionService promotionService = new PromotionService();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        if (uri.startsWith(contextPath + "/assets/") || uri.equals(contextPath + "/favicon.ico")) {
            chain.doFilter(request, response);
            return;
        }
        HttpSession session = httpRequest.getSession(false);
        List<Category> categories = Collections.emptyList();
        try {
            categories = categoryService.getCategoriesWithSubCategories();
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("navigationDataError",
                    "Le menu des catégories est momentanément indisponible.");
        }
        request.setAttribute("navCategories", categories);

        List<Promotion> promotions = Collections.emptyList();
        try {
            promotions = promotionService.getActive();
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("promotionLoadError",
                    "Les promotions n'ont pas pu être chargées pour le moment.");
        }
        request.setAttribute("activePromotions", promotions);

        if (session != null) {
            Object cartObj = session.getAttribute("cart");
            if (cartObj instanceof java.util.Map<?, ?> cartMap) {
                int count = ((Map<?, ?>) cartMap).values().stream()
                        .filter(CartItem.class::isInstance)
                        .map(CartItem.class::cast)
                        .mapToInt(CartItem::getQuantity)
                        .sum();
                request.setAttribute("cartCount", count);
            }
            User user = (User) session.getAttribute("user");
            if (user != null) {
                request.setAttribute("currentUser", user);
            }
        }
        chain.doFilter(request, response);
    }
}
