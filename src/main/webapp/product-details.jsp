<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.example.model.Product" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Product Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body>
<jsp:include page="/WEB-INF/fragments/navbar.jspf" />
<main class="page-wrapper">
    <div class="container py-5" style="max-width: 960px;">
        <%
            String productError = (String) request.getAttribute("productError");
            if (productError != null) {
        %>
        <div class="alert alert-warning mb-4"><%= productError %></div>
        <%
            }
        %>
        <%
            Product p = (Product) request.getAttribute("product");
            if (p == null) {
        %>
        <div class="alert alert-info">Product not found.</div>
        <%
            } else {
                String[] placeholderLocations = {"New York", "Chicago", "Seattle", "Austin", "Denver", "Portland", "Los Angeles", "Atlanta"};
                int placeholderIndex = Math.abs((p.getName() != null ? p.getName() : "Nom").hashCode());
                String location = placeholderLocations[placeholderIndex % placeholderLocations.length];
        %>
        <div class="card detail-card p-4">
            <div class="row g-4 align-items-center">
                <div class="col-md-5">
                    <%
                        String imagePath = p.getImageUrl();
                        if (imagePath != null && !imagePath.isBlank()) {
                    %>
                    <img src="<%= request.getContextPath() + "/" + imagePath %>" alt="Visuel <%= p.getName() %>" class="img-fluid rounded" style="max-height: 280px; object-fit: cover;" />
                    <%
                        } else {
                    %>
                    <div class="image-placeholder" role="img" aria-label="Immersive atmosphere inspired by <%= location %>">
                        <span class="placeholder-label"><%= location.toUpperCase() %></span>
                    </div>
                    <%
                        }
                    %>
                </div>
                <div class="col-md-7">
                    <div class="d-flex flex-wrap gap-2 align-items-center mb-2">
                        <span class="badge text-bg-light"><%= p.getCategoryName() != null ? p.getCategoryName() : "Collection" %></span>
                        <%
                            if (p.getSubCategoryName() != null) {
                        %>
                        <span class="badge bg-primary-subtle text-primary fw-semibold"><%= p.getSubCategoryName() %></span>
                        <%
                            }
                        %>
                    </div>
                    <h2 class="h4"><%= p.getName() %></h2>
                    <p class="text-muted"><%= p.getDescription() %></p>
                    <div class="d-flex align-items-center gap-3 mt-3">
                        <span class="price-tag fs-4">$<%= p.getPrice() %></span>
                        <button class="btn btn-primary" type="button">Add to cart</button>
                    </div>
                    <p class="mt-4 text-secondary">Decor inspired by <%= location %>: warm textures, soft lighting, and a layout tailored for feature displays.</p>
                </div>
            </div>
        </div>
        <%
            }
        %>
        <jsp:include page="/WEB-INF/fragments/active-promotions.jspf" />
    </div>
</main>
<jsp:include page="/WEB-INF/fragments/footer.jspf" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/assets/js/promotions.js"></script>
</body>
</html>
