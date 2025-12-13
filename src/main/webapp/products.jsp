<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,org.example.model.Product,org.example.model.Category,org.example.model.SubCategory" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Product Catalog</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body>
<jsp:include page="/WEB-INF/fragments/navbar.jspf" />
<main class="page-wrapper">
    <div class="container py-5">
        <div class="section-heading mb-4">
            <h1 class="h3">Immersive catalog</h1>
            <p class="mb-0">Browse curated selections ready to showcase: furniture, lighting, and accessories designed for your spaces.</p>
        </div>

        <%
            String catalogError = (String) request.getAttribute("catalogError");
            if (catalogError != null) {
        %>
        <div class="alert alert-warning mb-4"><%= catalogError %></div>
        <%
            }
        %>

        <%
            Category selectedCategory = (Category) request.getAttribute("selectedCategory");
            SubCategory selectedSubCategory = (SubCategory) request.getAttribute("selectedSubCategory");
            if (selectedCategory != null || selectedSubCategory != null) {
        %>
        <div class="alert alert-primary d-flex flex-wrap align-items-center justify-content-between gap-2" role="status">
            <div class="d-flex flex-wrap align-items-center gap-2">
                <span class="fw-semibold">Active filter</span>
                <%
                    if (selectedCategory != null) {
                %>
                <span class="badge text-bg-light"><%= selectedCategory.getName() %></span>
                <%
                    }
                    if (selectedSubCategory != null) {
                %>
                <span class="badge bg-primary-subtle text-primary fw-semibold"><%= selectedSubCategory.getName() %></span>
                <%
                    }
                %>
            </div>
            <a class="btn btn-outline-primary btn-sm" href="${pageContext.request.contextPath}/products">Reset</a>
        </div>
        <%
            }
        %>

        <div class="card lifted p-4 mb-4">
            <div class="d-flex flex-column flex-md-row align-items-start align-items-md-center justify-content-between gap-2">
                <div>
                    <strong>Inspiration path</strong>
                    <p class="mb-0 text-secondary">A clear direction for your showrooms: soft lighting, natural materials, and focused hero products.</p>
                </div>
                <span class="badge bg-secondary-subtle text-secondary">New York • Chicago • Seattle</span>
            </div>
        </div>

        <div class="row g-4">
            <%
                String[] placeholderLocations = {"New York", "Chicago", "Seattle", "Austin", "Denver", "Portland", "Los Angeles", "Atlanta", "San Diego", "Phoenix"};
                int locationIndex = 0;
                List<Product> prods = (List<Product>) request.getAttribute("products");
                if (prods != null && !prods.isEmpty()) {
                    for (Product p : prods) {
                        String location = placeholderLocations[locationIndex % placeholderLocations.length];
                        locationIndex++;
            %>
            <div class="col-md-6 col-lg-4 col-xl-3">
                <div class="card h-100 lifted">
                    <%
                        String imagePath = p.getImageUrl();
                        if (imagePath != null && !imagePath.isBlank()) {
                    %>
                    <img src="<%= request.getContextPath() + "/" + imagePath %>" alt="Visuel <%= p.getName() %>" class="card-img-top" style="height: 180px; object-fit: cover;" />
                    <%
                        } else {
                    %>
                    <div class="image-placeholder" role="img" aria-label="Concept decor inspired by <%= location %>">
                        <span class="placeholder-label"><%= location.toUpperCase() %></span>
                    </div>
                    <%
                        }
                    %>
                    <div class="card-body">
                        <div class="d-flex flex-wrap gap-2 mb-2">
                            <span class="badge text-bg-light"><%= p.getCategoryName() != null ? p.getCategoryName() : "Collection" %></span>
                            <%
                                if (p.getSubCategoryName() != null) {
                            %>
                            <span class="badge bg-primary-subtle text-primary fw-semibold"><%= p.getSubCategoryName() %></span>
                            <%
                                }
                            %>
                        </div>
                        <h5 class="card-title mb-1"><%= p.getName() %></h5>
                        <p class="card-text text-muted"><%= p.getDescription() %></p>
                        <div class="d-flex justify-content-between align-items-center mt-3">
                            <span class="price-tag">$<%= p.getPrice() %></span>
                            <a class="btn btn-outline-primary btn-sm" href="${pageContext.request.contextPath}/product?id=<%= p.getId() %>">Details</a>
                        </div>
                    </div>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div class="col-12">
                <div class="alert alert-info">Catalog in progress. Add products to reveal new decorative destinations.</div>
            </div>
            <%
                }
            %>
        </div>

        <jsp:include page="/WEB-INF/fragments/active-promotions.jspf" />
    </div>
</main>
<jsp:include page="/WEB-INF/fragments/footer.jspf" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/assets/js/promotions.js"></script>
</body>
</html>
