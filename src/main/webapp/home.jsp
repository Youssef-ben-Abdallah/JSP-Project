<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,org.example.model.Product" %>
<!DOCTYPE html>
<html>
<head>
    <title>Accueil - MyShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body>
<jsp:include page="/WEB-INF/fragments/navbar.jspf" />
<main class="page-wrapper">
    <div class="container py-5">
        <%
            request.setAttribute("promotionDisplayMode", "hero");
        %>
        <jsp:include page="/WEB-INF/fragments/active-promotions.jspf" />
        <%
            request.removeAttribute("promotionDisplayMode");
        %>

        <section class="hero-section mb-5 text-white">
            <div class="tagline-chip">Expérience immersive</div>
            <h1 class="mt-3">Votre boutique moderne au coeur des plus belles villes</h1>
            <p class="mt-3">Découvrez des collections raffinées, une expérience fluide et des services pensés pour vous accompagner dans chacun de vos projets.</p>
            <div class="hero-actions">
                <a class="btn-soft" href="${pageContext.request.contextPath}/products">Découvrir le catalogue</a>
                <div class="placeholder-banner" role="img" aria-label="Réseau de showrooms - Paris, Lyon, Bordeaux">
                    3 showrooms éphémères : Paris, Lyon &amp; Bordeaux
                </div>
            </div>
        </section>

        <hr class="feature-divider" />

        <section>
            <div class="section-heading">
                <h2>Produits populaires</h2>
                <p>Un aperçu de vos meilleures ventes prêtes à illuminer nos vitrines conceptuelles. Chaque carte s’anime comme un décor miniature inspiré d’un quartier emblématique.</p>
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
                    <div class="card glass-card h-100 p-2">
                        <div class="image-placeholder" role="img" aria-label="Mise en scène lumineuse de <%= location %>">
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
                                <a class="btn btn-ghost btn-sm" href="product?id=<%= p.getId() %>">Voir la scénographie</a>
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
                        <h5>Le catalogue arrive bientôt ✨</h5>
                        <p class="mb-0 text-muted">Ajoutez vos premiers produits depuis l'espace administrateur pour révéler ici vos collections.</p>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
        </section>
    </div>
</main>
<jsp:include page="/WEB-INF/fragments/footer.jspf" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/promotions.js"></script>
</body>
</html>
