<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.example.model.Product" %>
<!DOCTYPE html>
<html>
<head>
    <title>Détails Produit</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body>
<jsp:include page="/WEB-INF/fragments/navbar.jspf" />
<main class="page-wrapper">
    <div class="container py-5" style="max-width: 960px;">
        <%
            Product p = (Product) request.getAttribute("product");
            if (p == null) {
        %>
        <div class="glass-card p-4 alert-soft">Produit introuvable.</div>
        <%
            } else {
                String[] placeholderLocations = {"Paris", "Aix-en-Provence", "Lyon", "Bordeaux", "Deauville", "Cannes", "Colmar", "Avignon"};
                int placeholderIndex = Math.abs((p.getName() != null ? p.getName() : "Nom").hashCode());
                String location = placeholderLocations[placeholderIndex % placeholderLocations.length];
        %>
        <div class="detail-card">
            <div class="row g-4 align-items-center">
                <div class="col-md-5">
                    <div class="image-placeholder" role="img" aria-label="Ambiance immersive de <%= location %>">
                        <span class="placeholder-label"><%= location.toUpperCase() %></span>
                    </div>
                </div>
                <div class="col-md-7">
                    <span class="badge-category"><%= p.getCategoryName() != null ? p.getCategoryName() : "Collection" %></span>
                    <h2><%= p.getName() %></h2>
                    <p><%= p.getDescription() %></p>
                    <div class="d-flex align-items-center gap-3 mt-3">
                        <span class="price-tag">$<%= p.getPrice() %></span>
                        <button class="btn-soft" type="button">Ajouter au panier</button>
                    </div>
                    <p class="mt-4 text-muted">Ce décor conceptuel est inspiré des ruelles de <%= location %>, idéal pour valoriser l’esprit de votre collection.</p>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </div>
</main>
<jsp:include page="/WEB-INF/fragments/footer.jspf" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
