<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,org.example.model.Product,org.example.model.Category,org.example.model.SubCategory" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Produits</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body>
<main class="page-wrapper">
    <div class="container py-5">
        <jsp:include page="/WEB-INF/admin/admin-header.jspf" />

        <div class="glass-card mb-4 p-4">
            <h5 class="mb-3">Ajouter un produit</h5>
            <form method="post" action="${pageContext.request.contextPath}/admin/products" class="row g-3 align-items-end">
                <input type="hidden" name="action" value="create" />
                <div class="col-md-3">
                    <label class="form-label">Nom</label>
                    <input class="form-control" type="text" name="name" placeholder="Nom" required />
                </div>
                <div class="col-md-4">
                    <label class="form-label">Description</label>
                    <input class="form-control" type="text" name="description" placeholder="Description" />
                </div>
                <div class="col-md-2">
                    <label class="form-label">Prix</label>
                    <input class="form-control" type="number" step="0.01" min="0" name="price" placeholder="0.00" required />
                </div>
                <div class="col-md-3">
                    <label class="form-label">Ambiance (optionnel)</label>
                    <input class="form-control" type="text" name="imageUrl" placeholder="Ex: Paris, Rivoli" />
                </div>
                <div class="col-md-4">
                    <label class="form-label">Catégorie</label>
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
                <div class="col-md-4">
                    <label class="form-label">Sous-catégorie</label>
                    <select class="form-select" name="subCategoryId">
                        <option value="">-- Sous-catégorie (optionnel) --</option>
                        <%
                            List<SubCategory> subs2 = (List<SubCategory>) request.getAttribute("subCategories");
                            if (subs2 != null) {
                                for (SubCategory sc2 : subs2) {
                        %>
                        <option value="<%= sc2.getId() %>"><%= sc2.getCategoryName() %> • <%= sc2.getName() %></option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>
                <div class="col-md-2">
                    <button class="btn-soft w-100 justify-content-center" type="submit">Ajouter</button>
                </div>
            </form>
        </div>

        <div class="glass-card p-0">
            <div class="p-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div>
                    <h5 class="mb-1">Liste des produits</h5>
                    <p class="mb-0 text-muted">Visualisez vos collections et leurs ambiances fictives inspirées de nos ateliers itinérants.</p>
                </div>
                <div class="placeholder-banner mb-0" role="img" aria-label="Réseau d'ateliers - Rouen, Nancy, Brest">
                    Inspirations ateliers : Rouen, Nancy &amp; Brest
                </div>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle glass-table mb-0">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nom</th>
                        <th>Prix</th>
                        <th>Catégorie</th>
                        <th>Sous-catégorie</th>
                        <th>Ambiance</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        List<Product> plist = (List<Product>) request.getAttribute("products");
                        String[] placeholderLocations = {"Paris", "Lyon", "Bordeaux", "Nantes", "Lille", "Nice", "Tours", "Grenoble"};
                        int adminIndex = 0;
                        if (plist != null && !plist.isEmpty()) {
                            for (Product p2 : plist) {
                                String location = placeholderLocations[adminIndex % placeholderLocations.length];
                                adminIndex++;
                    %>
                    <tr>
                        <td><%= p2.getId() %></td>
                        <td><%= p2.getName() %></td>
                        <td>$<%= p2.getPrice() %></td>
                        <td><%= p2.getCategoryName() %></td>
                        <td><%= p2.getSubCategoryName() != null ? p2.getSubCategoryName() : "—" %></td>
                        <td style="width:120px;">
                            <div class="image-placeholder is-compact" role="img" aria-label="Ambiance décorative de <%= location %>">
                                <span class="placeholder-label"><%= location.toUpperCase() %></span>
                            </div>
                        </td>
                        <td class="text-end">
                            <form method="post" action="${pageContext.request.contextPath}/admin/products" class="d-inline">
                                <input type="hidden" name="action" value="delete" />
                                <input type="hidden" name="id" value="<%= p2.getId() %>" />
                                <button class="btn btn-sm btn-outline-danger" type="submit">Supprimer</button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="7" class="text-center py-4 text-muted">Aucun produit enregistré pour le moment.</td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
