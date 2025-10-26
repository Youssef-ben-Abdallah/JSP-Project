<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,org.example.model.Product" %>
<!DOCTYPE html>
<html>
<head>
    <title>Catalogue Produits</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
<jsp:include page="/WEB-INF/fragments/navbar.jspf" />
<div class="container">
    <h1 class="mb-4">Tous les produits</h1>
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
                    <a class="btn btn-outline-primary btn-sm" href="product?id=<%= p.getId() %>">Détails</a>
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
