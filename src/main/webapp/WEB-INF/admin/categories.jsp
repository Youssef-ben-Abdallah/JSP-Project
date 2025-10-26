<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,org.example.model.Category,org.example.model.SubCategory" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Catégories</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body>
<main class="page-wrapper">
    <div class="container py-5">
        <jsp:include page="/WEB-INF/admin/admin-header.jspf" />

        <div class="glass-card p-4 mb-4">
            <h5 class="mb-3">Ajouter une catégorie</h5>
            <form method="post" action="${pageContext.request.contextPath}/admin/categories" class="row g-3 align-items-end">
                <input type="hidden" name="action" value="create" />
                <div class="col-md-4">
                    <label class="form-label">Nom</label>
                    <input class="form-control" type="text" name="name" placeholder="Nom" required />
                </div>
                <div class="col-md-6">
                    <label class="form-label">Description</label>
                    <input class="form-control" type="text" name="description" placeholder="Description" />
                </div>
                <div class="col-md-2">
                    <button class="btn-soft w-100 justify-content-center" type="submit">Ajouter</button>
                </div>
            </form>
        </div>

        <div class="glass-card p-0">
            <div class="p-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div>
                    <h5 class="mb-1">Liste des catégories</h5>
                    <p class="mb-0 text-muted">Structurez vos collections autour de décors emblématiques pour vos prochains pop-up stores.</p>
                </div>
                <div class="placeholder-banner mb-0" role="img" aria-label="Cartographie créative - Metz, Pau, Ajaccio">
                    Cartographie créative : Metz, Pau &amp; Ajaccio
                </div>
            </div>
            <div class="table-responsive">
                <table class="table align-middle glass-table mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nom</th>
                            <th>Description</th>
                            <th>Ambiance associée</th>
                            <th>Sous-catégories</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        List<Category> cats = (List<Category>) request.getAttribute("categories");
                        String[] placeholderLocations = {"Paris", "Lyon", "Bordeaux", "Toulon", "Nîmes", "Troyes", "Nancy", "Poitiers"};
                        int index = 0;
                        if (cats != null && !cats.isEmpty()) {
                            for (Category c : cats) {
                                String location = placeholderLocations[index % placeholderLocations.length];
                                index++;
                                List<SubCategory> subList = c.getSubCategories();
                    %>
                        <tr>
                            <td><%= c.getId() %></td>
                            <td><%= c.getName() %></td>
                            <td><%= c.getDescription() %></td>
                            <td style="width:140px;">
                                <div class="image-placeholder is-compact" role="img" aria-label="Destination thématique <%= location %>">
                                    <span class="placeholder-label"><%= location.toUpperCase() %></span>
                                </div>
                            </td>
                            <td style="min-width:180px;">
                                <div class="d-flex flex-wrap gap-2">
                                <%
                                    if (subList != null && !subList.isEmpty()) {
                                        for (SubCategory sub : subList) {
                                %>
                                    <span class="badge-subcategory"><%= sub.getName() %></span>
                                <%
                                        }
                                    } else {
                                %>
                                    <span class="text-muted small">Aucune sous-catégorie</span>
                                <%
                                    }
                                %>
                                </div>
                            </td>
                            <td class="text-end">
                                <form method="post" action="${pageContext.request.contextPath}/admin/categories" class="d-inline">
                                    <input type="hidden" name="action" value="delete" />
                                    <input type="hidden" name="id" value="<%= c.getId() %>" />
                                    <button class="btn btn-sm btn-outline-danger" type="submit">Supprimer</button>
                                </form>
                            </td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="6" class="text-center py-4 text-muted">Ajoutez votre première catégorie pour lancer la scénographie.</td>
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
