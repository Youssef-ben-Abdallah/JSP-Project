package org.example.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import org.example.model.Category;
import org.example.service.CategoryService;

import java.io.IOException;
import java.util.List;

@WebFilter("/*")
public class NavigationDataFilter implements Filter {
    private final CategoryService categoryService = new CategoryService();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        if (uri.startsWith(contextPath + "/assets/")) {
            chain.doFilter(request, response);
            return;
        }
        List<Category> categories = categoryService.getCategoriesWithSubCategories();
        request.setAttribute("navCategories", categories);
        chain.doFilter(request, response);
    }
}
