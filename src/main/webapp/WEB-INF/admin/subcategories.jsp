<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,org.example.model.SubCategory,org.example.model.Category" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Sous-catégories</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body>
<main class="page-wrapper">
    <div class="container py-5">
        <jsp:include page="/WEB-INF/admin/admin-header.jspf" />

        <div class="glass-card p-4 mb-4">
            <h5 class="mb-3">Créer une sous-catégorie</h5>
            <form method="post" action="${pageContext.request.contextPath}/admin/subcategories" class="row g-3 align-items-end">
                <input type="hidden" name="action" value="create" />
                <div class="col-md-3">
                    <label class="form-label">Nom</label>
                    <input class="form-control" type="text" name="name" placeholder="Nom" required />
                </div>
                <div class="col-md-4">
                    <label class="form-label">Description</label>
                    <input class="form-control" type="text" name="description" placeholder="Description" />
                </div>
                <div class="col-md-3">
                    <label class="form-label">Catégorie parente</label>
                    <select class="form-select" name="categoryId" required>
                        <option value="">-- Catégorie --</option>
                        <%
                            List<Category> cats = (List<Category>) request.getAttribute("categories");
                            if (cats != null) {
                                for (Category c : cats) {
                        %>
                        <option value="<%= c.getId() %>"><%= c.getName() %></option>
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
                    <h5 class="mb-1">Sous-catégories configurées</h5>
                    <p class="mb-0 text-muted">Organisez vos gammes par univers précis pour simplifier la navigation côté client.</p>
                </div>
                <div class="placeholder-banner mb-0" role="img" aria-label="Palette matières - Metz, Pau, Ajaccio">
                    Palette matières : Metz, Pau &amp; Ajaccio
                </div>
            </div>
            <div class="table-responsive">
                <table class="table align-middle glass-table mb-0">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nom</th>
                        <th>Description</th>
                        <th>Catégorie</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        List<SubCategory> subs = (List<SubCategory>) request.getAttribute("subcategories");
                        if (subs != null && !subs.isEmpty()) {
                            for (SubCategory sc : subs) {
                    %>
                    <tr>
                        <td><%= sc.getId() %></td>
                        <td><%= sc.getName() %></td>
                        <td><%= sc.getDescription() != null ? sc.getDescription() : "—" %></td>
                        <td><span class="badge rounded-pill text-bg-light"><%= sc.getCategoryName() %></span></td>
                        <td class="text-end">
                            <button class="btn btn-sm btn-outline-secondary me-2" type="button"
                                    data-bs-toggle="modal" data-bs-target="#editSubCategoryModal<%= sc.getId() %>">
                                Modifier
                            </button>
                            <form method="post" action="${pageContext.request.contextPath}/admin/subcategories" class="d-inline">
                                <input type="hidden" name="action" value="delete" />
                                <input type="hidden" name="id" value="<%= sc.getId() %>" />
                                <button class="btn btn-sm btn-outline-danger" type="submit">Supprimer</button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="5" class="text-center py-4 text-muted">Créez vos premières sous-catégories pour enrichir le méga-menu.</td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
        <%
            if (subs != null && !subs.isEmpty()) {
                for (SubCategory sc : subs) {
        %>
        <div class="modal fade" id="editSubCategoryModal<%= sc.getId() %>" tabindex="-1"
             aria-labelledby="editSubCategoryLabel<%= sc.getId() %>" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content glass-card">
                    <div class="modal-header border-0">
                        <h5 class="modal-title" id="editSubCategoryLabel<%= sc.getId() %>">Modifier la sous-catégorie</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/admin/subcategories">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="update" />
                            <input type="hidden" name="id" value="<%= sc.getId() %>" />
                            <div class="mb-3">
                                <label class="form-label">Nom</label>
                                <input class="form-control" type="text" name="name" value="<%= sc.getName() %>" required />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Description</label>
                                <input class="form-control" type="text" name="description" value="<%= sc.getDescription() != null ? sc.getDescription() : "" %>" />
                            </div>
                            <div class="mb-0">
                                <label class="form-label">Catégorie parente</label>
                                <select class="form-select" name="categoryId" required>
                                    <option value="">-- Catégorie --</option>
                                    <%
                                        if (cats != null) {
                                            for (Category category : cats) {
                                                boolean selected = category.getId() == sc.getCategoryId();
                                    %>
                                    <option value="<%= category.getId() %>" <%= selected ? "selected" : "" %>><%= category.getName() %></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
