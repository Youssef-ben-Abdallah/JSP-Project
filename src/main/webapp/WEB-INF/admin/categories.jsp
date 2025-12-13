<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,org.example.model.Category,org.example.model.SubCategory" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Catégories</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap-lite.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body class="admin-shell">
<main class="page-wrapper">
    <div class="container py-5">
        <jsp:include page="/WEB-INF/admin/admin-header.jspf" />

        <%
            String categoryLoadError = (String) request.getAttribute("categoryLoadError");
            if (categoryLoadError != null) {
        %>
        <div class="alert-soft mb-4"><%= categoryLoadError %></div>
        <%
            }
        %>

        <div class="row g-4 mb-4">
            <div class="col-lg-8">
                <div class="glass-card p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-2">
                        <div>
                            <h5 class="mb-1">Ajouter une catégorie</h5>
                            <p class="text-muted mb-0">Créez un univers en quelques clics avant de le décliner en sous-collections.</p>
                        </div>
                        <span class="badge-subcategory">Flux en temps réel</span>
                    </div>
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
            </div>
            <div class="col-lg-4">
                <div class="glass-card p-4 h-100">
                    <h6 class="mb-2">Conseils rapides</h6>
                    <ul class="mb-0 text-muted small ps-3">
                        <li>Utilisez des descriptions évocatrices pour guider la navigation.</li>
                        <li>Le bouton "Modifier" ouvre désormais une fenêtre dédiée pour limiter les erreurs.</li>
                        <li>Gardez moins de 8 catégories pour une expérience fluide.</li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="glass-card p-0">
            <div class="p-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div>
                    <h5 class="mb-1">Liste des catégories</h5>
                    <p class="mb-0 text-muted">Un résumé clair avec modification en modal pour rester concentré sur le catalogue.</p>
                </div>
                <div class="admin-toolbar">
                    <div class="placeholder-banner mb-0" role="img" aria-label="Cartographie créative - Metz, Pau, Ajaccio">
                        Modifications en un clic
                    </div>
                    <span class="badge-subcategory">Sauvegarde instantanée</span>
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
                                <button class="btn btn-sm btn-outline-secondary me-2" type="button"
                                        data-bs-toggle="modal" data-bs-target="#editCategoryModal<%= c.getId() %>">
                                    Modifier
                                </button>
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
        <%
            if (cats != null && !cats.isEmpty()) {
                for (Category c : cats) {
        %>
        <div class="modal fade" id="editCategoryModal<%= c.getId() %>" tabindex="-1"
             aria-labelledby="editCategoryLabel<%= c.getId() %>" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content glass-card">
                    <div class="modal-header border-0">
                        <h5 class="modal-title" id="editCategoryLabel<%= c.getId() %>">Modifier la catégorie</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/admin/categories">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="update" />
                            <input type="hidden" name="id" value="<%= c.getId() %>" />
                            <div class="mb-3">
                                <label class="form-label">Nom</label>
                                <input class="form-control" type="text" name="name" value="<%= c.getName() %>" required />
                            </div>
                            <div class="mb-0">
                                <label class="form-label">Description</label>
                                <input class="form-control" type="text" name="description" value="<%= c.getDescription() != null ? c.getDescription() : "" %>" />
                            </div>
                        </div>
                        <div class="modal-footer border-0">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Annuler</button>
                            <button type="submit" class="btn-soft">Enregistrer</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <%
                }
            }
        %>
    </div>
</main>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap-lite.js"></script>
</body>
</html>
