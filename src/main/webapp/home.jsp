<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,org.example.model.Product" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Home - MyShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body>
<jsp:include page="/WEB-INF/fragments/navbar.jspf" />
<main class="page-wrapper">
    <div class="container py-5">
        <%
            String catalogError = (String) request.getAttribute("catalogError");
            if (catalogError != null) {
        %>
        <div class="alert alert-warning mb-4"><%= catalogError %></div>
        <%
            }
        %>

        <section class="hero-banner mb-5">
            <div class="row align-items-center g-4">
                <div class="col-lg-7">
                    <span class="hero-badge">MyShop Flagship • French concept stores</span>
                    <h1 class="display-5 fw-bold mt-3">A clear showcase for your collections</h1>
                    <p class="lead text-secondary">Use MyShop to quickly present new arrivals, track your promotions, and guide customers to the hero products.</p>
                    <div class="d-flex flex-wrap gap-2 mt-3">
                        <a class="btn btn-primary btn-lg" href="${pageContext.request.contextPath}/products">Browse catalog</a>
                        <a class="btn btn-outline-primary btn-lg" href="${pageContext.request.contextPath}/products?categoryId=1">See what's new</a>
                    </div>
                </div>
                <div class="col-lg-5">
                    <div class="placeholder-tile">Immersive journey • 12 cities • 48h delivery</div>
                </div>
            </div>
        </section>

        <section class="mb-5">
            <div class="section-heading mb-4">
                <h2 class="h4">Popular products</h2>
                <p class="mb-0">A look at bestsellers ready to highlight in your displays.</p>
            </div>
            <div class="row g-4">
                <%
                    String[] placeholderLocations = {"Paris", "Lyon", "Marseille", "Bordeaux", "Nice", "Toulouse", "Nantes", "Strasbourg"};
                    int locationIndex = 0;
                    List<Product> prods = (List<Product>) request.getAttribute("products");
                    if (prods != null && !prods.isEmpty()) {
                        for (Product p : prods) {
                            String location = placeholderLocations[locationIndex % placeholderLocations.length];
                            locationIndex++;
                %>
                <div class="col-md-6 col-lg-4 col-xl-3">
                    <div class="card h-100 lifted">
                        <div class="image-placeholder" role="img" aria-label="Bright staging in <%= location %>">
                            <span class="placeholder-label"><%= location.toUpperCase() %></span>
                        </div>
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
                                <a class="btn btn-outline-primary btn-sm" href="${pageContext.request.contextPath}/product?id=<%= p.getId() %>">View product</a>
                            </div>
                        </div>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="col-12">
                    <div class="alert alert-info mb-0">Add your first products from the admin area to populate this section.</div>
                </div>
                <%
                    }
                %>
            </div>
        </section>

        <jsp:include page="/WEB-INF/fragments/active-promotions.jspf" />
    </div>
</main>
<jsp:include page="/WEB-INF/fragments/footer.jspf" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/assets/js/promotions.js"></script>
</body>
</html>
