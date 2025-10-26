<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,org.example.model.Product" %>
<!DOCTYPE html>
<html>
<head>
    <title>Accueil - MyShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="assets/css/style.css" />
</head>
<body class="bg-light">
<jsp:include page="/WEB-INF/fragments/navbar.jspf" />
<div class="container">
    <h1 class="mb-4">Promotions du moment 🔥</h1>
    <p>(Ici tu pourras afficher les promotions actives: titre, % réduction, durée)</p>

    <hr/>

    <h2 class="mt-4">Produits populaires</h2>
    <div class="row">
        <%
            List<Product> prods = (List<Product>) request.getAttribute("products");
            if (prods != null) {
                for (Product p : prods) {
        %>
        <div class="col-md-3 mb-4">
            <div class="card h-100">
                <img src="<%= p.getImageUrl() %>" class="card-img-top" alt="img"/>
                <div class="card-body">
                    <h5 class="card-title"><%= p.getName() %></h5>
                    <p class="card-text text-truncate"><%= p.getDescription() %></p>
                    <p class="fw-bold">$<%= p.getPrice() %></p>
                    <a class="btn btn-primary btn-sm" href="product?id=<%= p.getId() %>">Voir</a>
                </div>
            </div>
        </div>
        <%
                }
            }
        %>
    </div>
</div>
<jsp:include page="/WEB-INF/fragments/footer.jspf" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
