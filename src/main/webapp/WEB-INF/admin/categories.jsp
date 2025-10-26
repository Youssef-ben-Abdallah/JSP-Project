<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,org.example.model.Category" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Catégories</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
<div class="container py-4">
    <jsp:include page="/WEB-INF/admin/admin-header.jspf" />

    <div class="card mb-4">
        <div class="card-header">Ajouter une catégorie</div>
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/admin/categories">
                <input type="hidden" name="action" value="create" />
                <div class="row g-2">
                    <div class="col-md-4">
                        <input class="form-control" type="text" name="name" placeholder="Nom" required />
                    </div>
                    <div class="col-md-6">
                        <input class="form-control" type="text" name="description" placeholder="Description" />
                    </div>
                    <div class="col-md-2 d-grid">
                        <button class="btn btn-dark" type="submit">Ajouter</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="card">
        <div class="card-header">Liste des catégories</div>
        <div class="card-body table-responsive">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nom</th>
                        <th>Description</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                <%
                    List<Category> cats = (List<Category>) request.getAttribute("categories");
                    if (cats != null) {
                        for (Category c : cats) {
                %>
                    <tr>
                        <td><%= c.getId() %></td>
                        <td><%= c.getName() %></td>
                        <td><%= c.getDescription() %></td>
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/admin/categories" class="d-inline">
                                <input type="hidden" name="action" value="delete" />
                                <input type="hidden" name="id" value="<%= c.getId() %>" />
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
