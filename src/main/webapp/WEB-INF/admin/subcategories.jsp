<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,org.example.model.SubCategory,org.example.model.Category" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Sub-categories</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap-lite.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body class="admin-shell">
<main class="page-wrapper">
    <div class="container py-5">
        <jsp:include page="/WEB-INF/admin/admin-header.jspf" />

        <%
            String categoryLoadError = (String) request.getAttribute("categoryLoadError");
            String subCategoryLoadError = (String) request.getAttribute("subCategoryLoadError");
            if (categoryLoadError != null) {
        %>
        <div class="alert-soft mb-4"><%= categoryLoadError %></div>
        <%
            }
            if (subCategoryLoadError != null) {
        %>
        <div class="alert-soft mb-4"><%= subCategoryLoadError %></div>
        <%
            }
        %>

        <div class="row g-4 mb-4">
            <div class="col-lg-8">
                <div class="glass-card p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-2">
                        <div>
                            <h5 class="mb-1">Create a sub-category</h5>
                            <p class="text-muted mb-0">Refine your hierarchy: every adjustment stays inside a dedicated modal.</p>
                        </div>
                        <span class="badge-subcategory">Smooth navigation</span>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/admin/subcategories" class="row g-3 align-items-end">
                        <input type="hidden" name="action" value="create" />
                        <div class="col-md-3">
                            <label class="form-label">Name</label>
                            <input class="form-control" type="text" name="name" placeholder="Name" required />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Description</label>
                            <input class="form-control" type="text" name="description" placeholder="Description" />
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Parent category</label>
                            <select class="form-select" name="categoryId" required>
                                <option value="">-- Category --</option>
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
                            <button class="btn-soft w-100 justify-content-center" type="submit">Add</button>
                        </div>
                    </form>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="glass-card p-4 h-100">
                    <h6 class="mb-2">Micro-optimizations</h6>
                    <ul class="text-muted small ps-3 mb-0">
                        <li>Fields are pre-filled in the edit modal.</li>
                        <li>Keep labels short for a better badge layout.</li>
                        <li>Deletion stays separate to avoid mistakes.</li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="glass-card p-0">
            <div class="p-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div>
                    <h5 class="mb-1">Configured sub-categories</h5>
                    <p class="mb-0 text-muted">Organize your ranges by specific worlds and edit them without leaving the dashboard.</p>
                </div>
                <div class="admin-toolbar">
                    <div class="placeholder-banner mb-0" role="img" aria-label="Material palette - Brooklyn, Austin, Seattle">
                        Ready-to-use modals
                    </div>
                    <span class="badge-subcategory">Secure editing</span>
                </div>
            </div>
            <div class="table-responsive">
                <table class="table align-middle glass-table mb-0">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Category</th>
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
                                    data-bs-toggle="modal" data-bs-target="#editSubCategoryModal"
                                    data-subcategory-id="<%= sc.getId() %>"
                                    data-subcategory-name="<%= sc.getName() %>"
                                    data-subcategory-description="<%= sc.getDescription() != null ? sc.getDescription() : "" %>"
                                    data-subcategory-category-id="<%= sc.getCategoryId() %>">
                                Edit
                            </button>
                            <form method="post" action="${pageContext.request.contextPath}/admin/subcategories" class="d-inline">
                                <input type="hidden" name="action" value="delete" />
                                <input type="hidden" name="id" value="<%= sc.getId() %>" />
                                <button class="btn btn-sm btn-outline-danger" type="submit">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="5" class="text-center py-4 text-muted">Create your first sub-categories to enrich the mega-menu.</td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="modal fade" id="editSubCategoryModal" tabindex="-1"
             aria-labelledby="editSubCategoryLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content glass-card">
                    <div class="modal-header border-0">
                        <h5 class="modal-title" id="editSubCategoryLabel">Edit sub-category</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form id="editSubCategoryForm" method="post" action="${pageContext.request.contextPath}/admin/subcategories">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="update" />
                            <input type="hidden" name="id" id="editSubCategoryId" />
                            <div class="mb-3">
                                <label class="form-label">Name</label>
                                <input class="form-control" type="text" name="name" id="editSubCategoryName" required />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Description</label>
                                <input class="form-control" type="text" name="description" id="editSubCategoryDescription" />
                            </div>
                            <div class="mb-0">
                                <label class="form-label">Parent category</label>
                                <select class="form-select" name="categoryId" id="editSubCategoryCategory" required>
                                    <option value="">-- Category --</option>
                                    <%
                                        if (cats != null) {
                                            for (Category category : cats) {
                                    %>
                                    <option value="<%= category.getId() %>"><%= category.getName() %></option>
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
    </div>
</main>
<script>
    const editSubCategoryModal = document.getElementById('editSubCategoryModal');
    if (editSubCategoryModal) {
        editSubCategoryModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            if (!button) return;

            document.getElementById('editSubCategoryId').value = button.getAttribute('data-subcategory-id');
            document.getElementById('editSubCategoryName').value = button.getAttribute('data-subcategory-name');
            document.getElementById('editSubCategoryDescription').value = button.getAttribute('data-subcategory-description') || '';
            document.getElementById('editSubCategoryCategory').value = button.getAttribute('data-subcategory-category-id') || '';
        });
    }
</script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap-lite.js"></script>
</body>
</html>
