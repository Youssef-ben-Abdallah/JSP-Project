<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,org.example.model.Product,org.example.model.Category" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Produits</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
<div class="container py-4">
    <jsp:include page="/WEB-INF/admin/admin-header.jspf" />

    <div class="card mb-4">
        <div class="card-header">Ajouter un produit</div>
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/admin/products">
                <input type="hidden" name="action" value="create" />
                <div class="row g-2 mb-2">
                    <div class="col-md-3">
                        <input class="form-control" type="text" name="name" placeholder="Nom" required />
                    </div>
                    <div class="col-md-5">
                        <input class="form-control" type="text" name="description" placeholder="Description" />
                    </div>
                    <div class="col-md-2">
                        <input class="form-control" type="number" step="0.01" min="0" name="price" placeholder="Prix" required />
                    </div>
                    <div class="col-md-2">
                        <input class="form-control" type="text" name="imageUrl" placeholder="Image URL" />
                    </div>
                </div>
                <div class="row g-2">
                    <div class="col-md-4">
                        <select class="form-select" name="categoryId" required>
                            <option value="">-- Catégorie --</option>
                            <%
                                List<Category> cats2 = (List<Category>) request.getAttribute("categories");
                                if (cats2 != null) {
                                    for (Category c2 : cats2) {
                            %>
                                <option value="<%= c2.getId() %>"><%= c2.getName() %></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>
                    <div class="col-md-2 d-grid">
                        <button class="btn btn-dark" type="submit">Ajouter</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="card">
        <div class="card-header">Liste des produits</div>
        <div class="card-body table-responsive">
            <table class="table table-hover">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Nom</th>
                    <th>Prix</th>
                    <th>Catégorie</th>
                    <th>Image</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<Product> plist = (List<Product>) request.getAttribute("products");
                    if (plist != null) {
                        for (Product p2 : plist) {
                %>
                <tr>
                    <td><%= p2.getId() %></td>
                    <td><%= p2.getName() %></td>
                    <td>$<%= p2.getPrice() %></td>
                    <td><%= p2.getCategoryName() %></td>
                    <td><img src="<%= p2.getImageUrl() %>" style="width:60px;height:60px;object-fit:cover;border-radius:4px;border:1px solid #ccc;"/></td>
                    <td>
                        <form method="post" action="${pageContext.request.contextPath}/admin/products" class="d-inline">
                            <input type="hidden" name="action" value="delete" />
                            <input type="hidden" name="id" value="<%= p2.getId() %>" />
                            <button class="btn btn-sm btn-outline-danger" type="submit">Supprimer</button>
                        </form>
                    </td>
                </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
