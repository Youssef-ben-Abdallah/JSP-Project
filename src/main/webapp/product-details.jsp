<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.example.model.Product" %>
<!DOCTYPE html>
<html>
<head>
    <title>Détails Produit</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
<jsp:include page="/WEB-INF/fragments/navbar.jspf" />
<div class="container" style="max-width:900px;">
    <%
        Product p = (Product) request.getAttribute("product");
        if (p == null) {
    %>
        <div class="alert alert-danger mt-4">Produit introuvable.</div>
    <%
        } else {
    %>
    <div class="row mt-4">
        <div class="col-md-5">
            <img src="<%= p.getImageUrl() %>" class="img-fluid rounded border" />
        </div>
        <div class="col-md-7">
            <h2><%= p.getName() %></h2>
            <p class="text-muted">Catégorie : <%= p.getCategoryName() %></p>
            <p><%= p.getDescription() %></p>
            <p class="fs-4 fw-bold">$<%= p.getPrice() %></p>
            <button class="btn btn-success">Ajouter au panier</button>
        </div>
    </div>
    <%
        }
    %>
</div>
<jsp:include page="/WEB-INF/fragments/footer.jspf" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
