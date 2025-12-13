<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,org.example.model.Category,org.example.model.SubCategory" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Categories</title>
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
                            <h5 class="mb-1">Add a category</h5>
                            <p class="text-muted mb-0">Create a new universe in a few clicks before expanding it with sub-collections.</p>
                        </div>
                        <span class="badge-subcategory">Real-time flow</span>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/admin/categories">
                        <input type="hidden" name="action" value="create" />
                        <table class="table table-borderless align-middle form-table mb-0">
                            <tbody>
                            <tr>
                                <th scope="row" class="text-muted">Name</th>
                                <td><input class="form-control" type="text" name="name" placeholder="Name" required /></td>
                                <td class="text-end" rowspan="2" style="width: 1%;"><button class="btn-soft" type="submit">Add</button></td>
                            </tr>
                            <tr>
                                <th scope="row" class="text-muted">Description</th>
                                <td><input class="form-control" type="text" name="description" placeholder="Description" /></td>
                            </tr>
                            </tbody>
                        </table>
                    </form>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="glass-card p-4 h-100">
                    <h6 class="mb-2">Quick tips</h6>
                    <ul class="mb-0 text-muted small ps-3">
                        <li>Use evocative descriptions to guide navigation.</li>
                        <li>The "Edit" button opens a dedicated window to reduce mistakes.</li>
                        <li>Keep fewer than eight categories for a smooth experience.</li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="glass-card p-0">
            <div class="p-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div>
                    <h5 class="mb-1">Category list</h5>
                    <p class="mb-0 text-muted">A clear summary with modal edits so you stay focused on the catalog.</p>
                </div>
                <div class="admin-toolbar">
                    <div class="placeholder-banner mb-0" role="img" aria-label="Creative mapping - Brooklyn, Austin, Seattle">
                        One-click edits
                    </div>
                    <span class="badge-subcategory">Instant save</span>
                </div>
            </div>
            <div class="table-responsive">
                <table class="table align-middle glass-table mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Associated mood</th>
                            <th>Sub-categories</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        List<Category> cats = (List<Category>) request.getAttribute("categories");
                        String[] placeholderLocations = {"New York", "Chicago", "Seattle", "Austin", "Denver", "Portland", "Los Angeles", "Atlanta"};
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
                                <div class="image-placeholder is-compact" role="img" aria-label="Thematic destination <%= location %>">
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
                                    <span class="text-muted small">No sub-categories</span>
                                <%
                                    }
                                %>
                                </div>
                            </td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-outline-secondary me-2" type="button"
                                        data-bs-toggle="modal" data-bs-target="#editCategoryModal"
                                        data-category-id="<%= c.getId() %>"
                                        data-category-name="<%= c.getName() %>"
                                        data-category-description="<%= c.getDescription() != null ? c.getDescription() : "" %>">
                                    Edit
                                </button>
                                <form method="post" action="${pageContext.request.contextPath}/admin/categories" class="d-inline">
                                    <input type="hidden" name="action" value="delete" />
                                    <input type="hidden" name="id" value="<%= c.getId() %>" />
                                    <button class="btn btn-sm btn-outline-danger" type="submit">Delete</button>
                                </form>
                            </td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="6" class="text-center py-4 text-muted">Add your first category to kickstart the layout.</td>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="modal fade" id="editCategoryModal" tabindex="-1"
             aria-labelledby="editCategoryLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content glass-card">
                    <div class="modal-header border-0 d-flex align-items-center justify-content-between">
                        <h5 class="modal-title ms-auto" id="editProductLabel">
                            Edit category
                        </h5>
                        <button
                                type="button"
                                class="btn btn-sm btn-outline-light modal-close-btn rounded-circle"
                                data-bs-dismiss="modal"
                                aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <form id="editCategoryForm" method="post" action="${pageContext.request.contextPath}/admin/categories">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="update" />
                            <input type="hidden" name="id" id="editCategoryId" />
                            <table class="table table-borderless align-middle form-table mb-0">
                                <tbody>
                                <tr>
                                    <th scope="row" class="text-muted">Name</th>
                                    <td><input class="form-control" type="text" name="name" id="editCategoryName" required /></td>
                                </tr>
                                <tr>
                                    <th scope="row" class="text-muted">Description</th>
                                    <td><input class="form-control" type="text" name="description" id="editCategoryDescription" /></td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="modal-footer border-0">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn-soft">Save</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>
<script>
    const editCategoryModal = document.getElementById('editCategoryModal');
    if (editCategoryModal) {
        editCategoryModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            if (!button) return;

            const id = button.getAttribute('data-category-id');
            const name = button.getAttribute('data-category-name');
            const description = button.getAttribute('data-category-description') || '';

            document.getElementById('editCategoryId').value = id;
            document.getElementById('editCategoryName').value = name;
            document.getElementById('editCategoryDescription').value = description;
        });
    }
</script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap-lite.js"></script>
</body>
</html>
