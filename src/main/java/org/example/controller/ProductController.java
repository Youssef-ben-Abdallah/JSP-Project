package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.example.model.Category;
import org.example.model.DiscountedPrice;
import org.example.model.Product;
import org.example.model.Promotion;
import org.example.model.SubCategory;
import org.example.service.CategoryService;
import org.example.service.ImageStorageService;
import org.example.service.PromotionDiscountCalculator;
import org.example.service.PromotionService;
import org.example.service.ProductService;
import org.example.service.SubCategoryService;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Collections;
import java.util.List;

@WebServlet(name = "ProductController", urlPatterns = {"/products", "/product", "/admin/products"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024)
public class ProductController extends HttpServlet {
    private final ProductService productService = new ProductService();
    private final CategoryService categoryService = new CategoryService();
    private final SubCategoryService subCategoryService = new SubCategoryService();
    private final PromotionService promotionService = new PromotionService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/products".equals(path)) {
            Integer categoryId = parseInteger(req.getParameter("categoryId"));
            Integer subCategoryId = parseInteger(req.getParameter("subCategoryId"));
            List<Product> products = Collections.emptyList();
            Category selectedCategory = null;
            SubCategory selectedSubCategory = null;
            String error = null;
            try {
                if (subCategoryId != null) {
                    products = productService.getBySubCategory(subCategoryId);
                    selectedSubCategory = subCategoryService.getById(subCategoryId);
                    if (selectedSubCategory != null) {
                        selectedCategory = categoryService.getById(selectedSubCategory.getCategoryId());
                    }
                } else if (categoryId != null) {
                    products = productService.getByCategory(categoryId);
                    selectedCategory = categoryService.getById(categoryId);
                } else {
                    products = productService.getAll();
                }
            } catch (Exception e) {
                e.printStackTrace();
                error = "Impossible de charger le catalogue pour le moment.";
                products = Collections.emptyList();
                selectedCategory = null;
                selectedSubCategory = null;
            }
            req.setAttribute("products", products);
            req.setAttribute("selectedCategory", selectedCategory);
            req.setAttribute("selectedSubCategory", selectedSubCategory);
            if (error != null) {
                req.setAttribute("catalogError", error);
            }
            req.getRequestDispatcher("/products.jsp").forward(req, resp);
            return;
        }
        if ("/product".equals(path)) {
            Integer id = parseInteger(req.getParameter("id"));
            Product product = null;
            String error = null;
            if (id == null) {
                error = "Référence produit invalide.";
            } else {
                try {
                    product = productService.getById(id);
                    if (product == null) {
                        error = "Le produit demandé est introuvable.";
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    error = "Impossible de charger ce produit pour le moment.";
                }
            }
            if (product != null) {
                try {
                    List<Promotion> activePromotions = promotionService.getActive();
                    req.setAttribute("activePromotions", activePromotions);
                    java.util.Optional<DiscountedPrice> discount = PromotionDiscountCalculator.calculate(
                            product.getPrice(),
                            product.getCategoryId(),
                            product.getSubCategoryId(),
                            activePromotions
                    );
                    discount.ifPresent(value -> req.setAttribute("productDiscount", value));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            req.setAttribute("product", product);
            if (error != null) {
                req.setAttribute("productError", error);
            }
            req.getRequestDispatcher("/product-details.jsp").forward(req, resp);
            return;
        }
        List<Product> products = Collections.emptyList();
        List<Category> categories = Collections.emptyList();
        List<SubCategory> subCategories = Collections.emptyList();
        String productsError = null;
        String categoriesError = null;
        String subCategoriesError = null;
        try {
            products = productService.getAll();
        } catch (Exception e) {
            e.printStackTrace();
            productsError = "Impossible de charger les produits.";
        }
        try {
            categories = categoryService.getAllCategories();
        } catch (Exception e) {
            e.printStackTrace();
            categoriesError = "Impossible de charger les catégories.";
        }
        try {
            subCategories = subCategoryService.getAll();
        } catch (Exception e) {
            e.printStackTrace();
            subCategoriesError = "Impossible de charger les sous-catégories.";
        }
        req.setAttribute("products", products);
        req.setAttribute("categories", categories);
        req.setAttribute("subCategories", subCategories);
        if (productsError != null) {
            req.setAttribute("catalogError", productsError);
        }
        if (categoriesError != null) {
            req.setAttribute("categoryLoadError", categoriesError);
        }
        if (subCategoriesError != null) {
            req.setAttribute("subCategoryLoadError", subCategoriesError);
        }
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
                String imageUrl = handleImageUpload(req, null);
                productService.addProduct(
                        req.getParameter("name"),
                        req.getParameter("description"),
                        Double.parseDouble(req.getParameter("price")),
                        imageUrl,
                        Integer.parseInt(req.getParameter("categoryId")),
                        subCategoryId
                );
            } else if ("update".equals(action)) {
                Integer subCategoryId = parseInteger(req.getParameter("subCategoryId"));
                String existingImage = req.getParameter("existingImageUrl");
                String imageUrl = handleImageUpload(req, existingImage);
                productService.updateProduct(
                        Integer.parseInt(req.getParameter("id")),
                        req.getParameter("name"),
                        req.getParameter("description"),
                        Double.parseDouble(req.getParameter("price")),
                        imageUrl,
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

    private String handleImageUpload(HttpServletRequest req, String fallbackPath)
            throws IOException, ServletException {
        Part imagePart = req.getPart("image");
        if (imagePart != null && imagePart.getSize() > 0) {
            String submittedName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            if (!submittedName.isBlank()) {
                Path uploadPath = ImageStorageService.resolveProductUploadDir();
                String uniqueName = System.currentTimeMillis() + "_" + submittedName;
                Path destination = uploadPath.resolve(uniqueName);
                try (InputStream inputStream = imagePart.getInputStream()) {
                    Files.copy(inputStream, destination, StandardCopyOption.REPLACE_EXISTING);
                }
                return "product-images/" + uniqueName;
            }
        }
        return fallbackPath != null && !fallbackPath.isBlank() ? fallbackPath : null;
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
