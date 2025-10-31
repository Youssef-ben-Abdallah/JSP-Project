<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,org.example.model.Product,org.example.model.Category,org.example.model.SubCategory" %>
<!DOCTYPE html>
<html>
<head>
    <title>Catalogue Produits</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body>
<jsp:include page="/WEB-INF/fragments/navbar.jspf" />
<main class="page-wrapper">
    <div class="container py-5">
        <div class="section-heading">
            <h1>Catalogue immersif</h1>
            <p>Chaque fiche produit s’accompagne d’un décor lumineux inspiré d’une destination. Inspirez-vous de ces ambiances pour sublimer vos prochaines vitrines.</p>
        </div>

        <%
            String catalogError = (String) request.getAttribute("catalogError");
            if (catalogError != null) {
        %>
        <div class="alert-soft mb-4"><%= catalogError %></div>
        <%
            }
        %>

        <%
            Category selectedCategory = (Category) request.getAttribute("selectedCategory");
            SubCategory selectedSubCategory = (SubCategory) request.getAttribute("selectedSubCategory");
            if (selectedCategory != null || selectedSubCategory != null) {
        %>
        <div class="filter-banner glass-card p-4 mb-4 d-flex flex-wrap align-items-center justify-content-between gap-3">
            <div class="d-flex flex-wrap align-items-center gap-2">
                <span class="filter-label">Filtre actif</span>
                <%
                    if (selectedCategory != null) {
                %>
                <span class="filter-chip"><%= selectedCategory.getName() %></span>
                <%
                    }
                    if (selectedSubCategory != null) {
                %>
                <span class="filter-chip is-accent"><%= selectedSubCategory.getName() %></span>
                <%
                    }
                %>
            </div>
            <a class="btn btn-outline-light btn-sm" href="${pageContext.request.contextPath}/products">Réinitialiser</a>
        </div>
        <%
            }
        %>

        <div class="glass-card p-4 mb-5 placeholder-banner" role="img" aria-label="Itinéraire design - Nice, Lille, Montpellier">
            <strong class="d-block mb-1">Parcours inspiration</strong>
            Explorez virtuellement nos escales de Nice à Lille en passant par Montpellier : des univers pensés pour accueillir vos produits phares.
        </div>

        <div class="row g-4">
            <%
                String[] placeholderLocations = {"Paris", "Lille", "Nice", "Toulouse", "Biarritz", "Montpellier", "Dijon", "Annecy", "Reims", "Rennes"};
                int locationIndex = 0;
                List<Product> prods = (List<Product>) request.getAttribute("products");
                if (prods != null && !prods.isEmpty()) {
                    for (Product p : prods) {
                        String location = placeholderLocations[locationIndex % placeholderLocations.length];
                        locationIndex++;
            %>
            <div class="col-md-6 col-lg-4 col-xl-3">
                <div class="card glass-card h-100 p-2">
                    <div class="image-placeholder" role="img" aria-label="Décor conceptuel de <%= location %>">
                        <span class="placeholder-label"><%= location.toUpperCase() %></span>
                    </div>
                    <div class="card-body">
                        <div class="d-flex flex-wrap gap-2 align-items-center mb-2">
                            <span class="badge-category"><%= p.getCategoryName() != null ? p.getCategoryName() : "Collection" %></span>
                            <%
                                if (p.getSubCategoryName() != null) {
                            %>
                            <span class="badge-subcategory"><%= p.getSubCategoryName() %></span>
                            <%
                                }
                            %>
                        </div>
                        <h5 class="card-title"><%= p.getName() %></h5>
                        <p class="card-text"><%= p.getDescription() %></p>
                        <div class="d-flex justify-content-between align-items-center mt-3">
                            <span class="price-tag">$<%= p.getPrice() %></span>
                            <a class="btn btn-ghost btn-sm" href="product?id=<%= p.getId() %>">Détails immersifs</a>
                        </div>
                    </div>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div class="col-12">
                <div class="glass-card p-5 text-center">
                    <h5>Catalogue en préparation</h5>
                    <p class="mb-0 text-muted">Ajoutez vos produits pour révéler de nouvelles destinations décoratives.</p>
                </div>
            </div>
            <%
                }
            %>
        </div>
        <hr class="feature-divider mt-5" />
        <%
            request.setAttribute("promotionDisplayMode", "secondary");
        %>
        <jsp:include page="/WEB-INF/fragments/active-promotions.jspf" />
        <%
            request.removeAttribute("promotionDisplayMode");
        %>
    </div>
</main>
<jsp:include page="/WEB-INF/fragments/footer.jspf" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/promotions.js"></script>
</body>
</html>
