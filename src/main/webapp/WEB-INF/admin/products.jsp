<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,org.example.model.Product,org.example.model.Category,org.example.model.SubCategory" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Products</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap-lite.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body class="admin-shell">
<main class="page-wrapper">
    <div class="container py-5">
        <jsp:include page="/WEB-INF/admin/admin-header.jspf" />

        <%
            String catalogError = (String) request.getAttribute("catalogError");
            String categoryLoadError = (String) request.getAttribute("categoryLoadError");
            String subCategoryLoadError = (String) request.getAttribute("subCategoryLoadError");
            if (catalogError != null) {
        %>
        <div class="alert-soft mb-4"><%= catalogError %></div>
        <%
            }
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
                <div class="glass-card mb-0 p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-2">
                        <div>
                            <h5 class="mb-1">Add a product</h5>
                            <p class="text-muted mb-0">Capture the essentials—fields remain editable later through a dedicated modal.</p>
                        </div>
                        <span class="badge-subcategory">Guided workflow</span>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/admin/products" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="create" />
                        <table class="table table-borderless align-middle form-table mb-0">
                            <tbody>
                            <tr>
                                <th scope="row" class="text-muted">Name</th>
                                <td><input class="form-control" type="text" name="name" placeholder="Name" required /></td>
                                <td class="text-end" rowspan="6" style="width: 1%;"><button class="btn-soft" type="submit">Add</button></td>
                            </tr>
                            <tr>
                                <th scope="row" class="text-muted">Description</th>
                                <td><input class="form-control" type="text" name="description" placeholder="Description" /></td>
                            </tr>
                            <tr>
                                <th scope="row" class="text-muted">Price</th>
                                <td><input class="form-control" type="number" step="0.01" min="0" name="price" placeholder="0.00" required /></td>
                            </tr>
                            <tr>
                                <th scope="row" class="text-muted">Product image</th>
                                <td>
                                    <input class="form-control" type="file" name="image" accept="image/*" />
                                    <small class="text-muted">PNG ou JPG, 5 Mo max.</small>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="text-muted">Category</th>
                                <td>
                                    <select class="form-select select-btn" name="categoryId" required>
                                        <option value="">-- Category --</option>
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
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="text-muted">Sub-category</th>
                                <td>
                                    <select class="form-select select-btn" name="subCategoryId">
                                        <option value="">-- Sub-category (optional) --</option>
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
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </form>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="glass-card p-4 h-100">
                    <h6 class="mb-2">Edit safety</h6>
                    <p class="text-muted small mb-2">Each click on "Edit" opens a contextual modal: no lost navigation, with prefilled data.</p>
                    <ul class="text-muted small ps-3 mb-0">
                        <li>Preview the existing image before replacing it.</li>
                        <li>Use categories to keep your collections cohesive.</li>
                        <li>Set prices with the guided decimal format.</li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="glass-card p-0">
            <div class="p-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div>
                    <h5 class="mb-1">Product list</h5>
                    <p class="mb-0 text-muted">View your collections, adjust details through smooth modals, and stay focused on the overview.</p>
                </div>
                <div class="admin-toolbar">
                    <div class="placeholder-banner mb-0" role="img" aria-label="Workshop network - Brooklyn, Austin, Seattle">
                        Reload-free interface
                    </div>
                    <span class="badge-subcategory">Contextual editing</span>
                </div>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle glass-table mb-0">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Price</th>
                        <th>Category</th>
                        <th>Sub-category</th>
                        <th>Mood</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        List<Product> plist = (List<Product>) request.getAttribute("products");
                        String[] placeholderLocations = {"New York", "Chicago", "Seattle", "Austin", "Denver", "Portland", "Los Angeles", "Atlanta"};
                        java.util.Locale locale = java.util.Locale.US;
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
                        <td style="width:140px;">
                            <%
                                String imagePath = p2.getImageUrl();
                                if (imagePath != null && !imagePath.isBlank()) {
                            %>
                            <img src="<%= request.getContextPath() + "/" + imagePath %>" alt="Visuel <%= p2.getName() %>" class="img-fluid rounded" style="max-height: 80px; object-fit: cover;" />
                            <%
                                } else {
                            %>
                            <div class="image-placeholder is-compact" role="img" aria-label="Decor mood inspired by <%= location %>">
                                <span class="placeholder-label"><%= location.toUpperCase() %></span>
                            </div>
                            <%
                                }
                            %>
                        </td>
                        <td class="text-end">
                            <button class="btn btn-sm btn-outline-secondary me-2" type="button"
                                    data-bs-toggle="modal" data-bs-target="#editProductModal"
                                    data-product-id="<%= p2.getId() %>"
                                    data-product-name="<%= p2.getName() %>"
                                    data-product-description="<%= p2.getDescription() != null ? p2.getDescription() : "" %>"
                                    data-product-price="<%= String.format(locale, "%.2f", p2.getPrice()) %>"
                                    data-product-category="<%= p2.getCategoryId() %>"
                                    data-product-subcategory="<%= p2.getSubCategoryId() != null ? p2.getSubCategoryId() : "" %>"
                                    data-product-image="<%= p2.getImageUrl() != null ? p2.getImageUrl() : "" %>">
                                Edit
                            </button>
                            <form method="post" action="${pageContext.request.contextPath}/admin/products" class="d-inline">
                                <input type="hidden" name="action" value="delete" />
                                <input type="hidden" name="id" value="<%= p2.getId() %>" />
                                <button class="btn btn-sm btn-outline-danger" type="submit">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="7" class="text-center py-4 text-muted">No products have been recorded yet.</td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="modal fade" id="editProductModal" tabindex="-1"
             aria-labelledby="editProductLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content glass-card">
                    <div class="modal-header border-0">
                        <h5 class="modal-title" id="editProductLabel">Edit product</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form id="editProductForm" method="post" action="${pageContext.request.contextPath}/admin/products" enctype="multipart/form-data">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="update" />
                            <input type="hidden" name="id" id="editProductId" />
                            <input type="hidden" name="existingImageUrl" id="editProductExistingImage" />
                            <table class="table table-borderless align-middle form-table mb-0">
                                <tbody>
                                <tr>
                                    <th scope="row" class="text-muted">Name</th>
                                    <td><input class="form-control" type="text" name="name" id="editProductName" required /></td>
                                </tr>
                                <tr>
                                    <th scope="row" class="text-muted">Product image</th>
                                    <td>
                                        <input class="form-control" type="file" name="image" accept="image/*" />
                                        <small class="text-muted">Leave empty to keep the current image.</small>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row" class="text-muted">Description</th>
                                    <td><textarea class="form-control" name="description" id="editProductDescription" rows="2"></textarea></td>
                                </tr>
                                <tr>
                                    <th scope="row" class="text-muted">Price</th>
                                    <td><input class="form-control" type="number" step="0.01" min="0" name="price" id="editProductPrice" required /></td>
                                </tr>
                                <tr>
                                    <th scope="row" class="text-muted">Category</th>
                                    <td>
                                        <select class="form-select select-btn" name="categoryId" id="editProductCategory" required>
                                            <option value="">-- Category --</option>
                                            <%
                                                if (cats2 != null) {
                                                    for (Category c2 : cats2) {
                                            %>
                                            <option value="<%= c2.getId() %>"><%= c2.getName() %></option>
                                            <%
                                                    }
                                                }
                                            %>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row" class="text-muted">Sub-category</th>
                                    <td>
                                        <select class="form-select select-btn" name="subCategoryId" id="editProductSubCategory">
                                            <option value="">-- None --</option>
                                            <%
                                                if (subs2 != null) {
                                                    for (SubCategory sc2 : subs2) {
                                            %>
                                            <option value="<%= sc2.getId() %>"><%= sc2.getCategoryName() %> • <%= sc2.getName() %></option>
                                            <%
                                                    }
                                                }
                                            %>
                                        </select>
                                    </td>
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
    const editProductModal = document.getElementById('editProductModal');
    if (editProductModal) {
        editProductModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            if (!button) return;

            document.getElementById('editProductId').value = button.getAttribute('data-product-id');
            document.getElementById('editProductExistingImage').value = button.getAttribute('data-product-image') || '';
            document.getElementById('editProductName').value = button.getAttribute('data-product-name') || '';
            document.getElementById('editProductDescription').value = button.getAttribute('data-product-description') || '';
            document.getElementById('editProductPrice').value = button.getAttribute('data-product-price') || '';
            document.getElementById('editProductCategory').value = button.getAttribute('data-product-category') || '';
            document.getElementById('editProductSubCategory').value = button.getAttribute('data-product-subcategory') || '';
        });
    }
</script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap-lite.js"></script>
</body>
</html>
