<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.model.Promotion" %>
<%@ page import="org.example.model.Category" %>
<%@ page import="org.example.model.SubCategory" %>
<!DOCTYPE html>
<html>
<head>
    <title>Promotion management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap-lite.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body class="admin-shell">
<main class="page-wrapper">
    <div class="container py-5">
        <jsp:include page="/WEB-INF/admin/admin-header.jspf" />

        <%
            String promotionLoadError = (String) request.getAttribute("promotionLoadError");
            if (promotionLoadError != null) {
        %>
        <div class="alert-soft mb-4"><%= promotionLoadError %></div>
        <%
            }
        %>

        <div class="row g-4">
            <%
                List<Category> categories = (List<Category>) request.getAttribute("categories");
                List<SubCategory> subCategories = (List<SubCategory>) request.getAttribute("subCategories");
            %>
            <div class="col-lg-5">
                <div class="glass-card p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-2">
                        <div>
                            <h3 class="mb-1">Create a promotion</h3>
                            <p class="text-muted mb-0">Set up a limited offer. Every future edit happens inside a dedicated modal.</p>
                        </div>
                        <span class="badge-subcategory">Guided scheduling</span>
                    </div>
                    <form method="post" class="promo-form">
                        <input type="hidden" name="action" value="create" />
                        <table class="table table-borderless align-middle form-table mb-0">
                            <tbody>
                            <tr>
                                <th scope="row" class="text-muted">Title</th>
                                <td><input class="form-control" type="text" name="title" required /></td>
                            </tr>
                            <tr>
                                <th scope="row" class="text-muted">Description</th>
                                <td><textarea class="form-control" name="description" rows="3" required></textarea></td>
                            </tr>
                            <tr>
                                <th scope="row" class="text-muted">Category scope</th>
                                <td>
                                    <select class="form-select select-btn" name="categoryId">
                                        <option value="">All categories</option>
                                        <%
                                            if (categories != null) {
                                                for (Category category : categories) {
                                        %>
                                        <option value="<%= category.getId() %>"><%= category.getName() %></option>
                                        <%
                                                }
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="text-muted">Sub-category scope</th>
                                <td>
                                    <select class="form-select select-btn" name="subCategoryId">
                                        <option value="">All sub-categories</option>
                                        <%
                                            if (subCategories != null) {
                                                for (SubCategory subCategory : subCategories) {
                                        %>
                                        <option value="<%= subCategory.getId() %>"><%= subCategory.getName() %> (<%= subCategory.getCategoryName() %>)</option>
                                        <%
                                                }
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="text-muted">Discount type</th>
                                <td>
                                    <select class="form-select select-btn" name="discountType">
                                        <option value="PERCENTAGE">Percentage</option>
                                        <option value="FIXED_AMOUNT">Fixed amount</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="text-muted">Value</th>
                                <td><input class="form-control" type="number" step="0.01" min="0" name="discountValue" required /></td>
                            </tr>
                            <tr>
                                <th scope="row" class="text-muted">Start</th>
                                <td><input class="form-control" type="datetime-local" name="startTime" required /></td>
                            </tr>
                            <tr>
                                <th scope="row" class="text-muted">End</th>
                                <td><input class="form-control" type="datetime-local" name="endTime" required /></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td class="text-end"><button class="btn-soft" type="submit">Publish promotion</button></td>
                            </tr>
                            </tbody>
                        </table>
                    </form>
                    <%
                        String error = (String) session.getAttribute("promotionError");
                        if (error != null) {
                    %>
                    <div class="alert alert-danger mt-3" role="alert">
                        <%= error %>
                    </div>
                    <%
                            session.removeAttribute("promotionError");
                        }
                    %>
                </div>
            </div>
            <div class="col-lg-7">
                <div class="glass-card p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
                        <div>
                            <h3 class="mb-1">Scheduled promotions</h3>
                            <p class="text-muted mb-0">Modal edits keep the context while you adjust the time windows.</p>
                        </div>
                        <div class="admin-toolbar">
                            <div class="placeholder-banner mb-0" role="img" aria-label="Promotion planning">
                                Instant adjustments
                            </div>
                            <span class="badge-subcategory">Calendar view</span>
                        </div>
                    </div>
                    <div class="table-responsive">
                            <table class="table align-middle text-white promo-table">
                                <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Window</th>
                                    <th>Discount</th>
                                    <th>Scope</th>
                                    <th></th>
                                </tr>
                                </thead>
                            <tbody>
                            <%
                                List<Promotion> promos = (List<Promotion>) request.getAttribute("promotions");
                                java.util.Map<Integer, String> categoryNames = new java.util.HashMap<>();
                                java.util.Map<Integer, String> subCategoryNames = new java.util.HashMap<>();
                                if (categories != null) {
                                    for (Category category : categories) {
                                        categoryNames.put(category.getId(), category.getName());
                                    }
                                }
                                if (subCategories != null) {
                                    for (SubCategory subCategory : subCategories) {
                                        subCategoryNames.put(subCategory.getId(), subCategory.getName());
                                    }
                                }
                                if (promos != null && !promos.isEmpty()) {
                                    java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm");
                                    java.time.format.DateTimeFormatter isoFormatter = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                                    java.text.DecimalFormat decimalFormat = new java.text.DecimalFormat("#.##");
                                    for (Promotion promo : promos) {
                                        java.time.LocalDateTime startTime = promo.getStartTime();
                                        java.time.LocalDateTime endTime = promo.getEndTime();
                                        String startDisplay = startTime != null ? startTime.format(formatter) : "Not scheduled";
                                        String endDisplay = endTime != null ? endTime.format(formatter) : "Not defined";
                                        String startIso = startTime != null ? startTime.format(isoFormatter) : "";
                                        String endIso = endTime != null ? endTime.format(isoFormatter) : "";
                                        String scopeLabel = "All catalog";
                                        if (promo.getSubCategoryId() != null) {
                                            String name = subCategoryNames.getOrDefault(promo.getSubCategoryId(), "Sub-category #" + promo.getSubCategoryId());
                                            scopeLabel = "Sub-category: " + name;
                                        } else if (promo.getCategoryId() != null) {
                                            String name = categoryNames.getOrDefault(promo.getCategoryId(), "Category #" + promo.getCategoryId());
                                            scopeLabel = "Category: " + name;
                                        }
                            %>
                            <tr>
                                <td>
                                    <strong><%= promo.getTitle() %></strong>
                                    <div class="text-muted small"><%= promo.getDescription() %></div>
                                </td>
                                <td>
                                    <div><%= startDisplay %></div>
                                    <div class="text-muted small">→ <%= endDisplay %></div>
                                </td>
                                <td>
                                    <span class="badge <%= promo.isPercentage() ? "bg-primary" : "bg-warning text-dark" %>">
                                        <%= promo.isPercentage() ? decimalFormat.format(promo.getDiscountValue()) + "%" : "-" + decimalFormat.format(promo.getDiscountValue()) + " EUR" %>
                                    </span>
                                </td>
                                <td>
                                    <span class="badge bg-secondary-subtle text-white-50"><%= scopeLabel %></span>
                                </td>
                                <td class="text-end">
                                    <div class="d-flex justify-content-end gap-2">
                                        <button class="btn btn-sm btn-outline-light" type="button"
                                                data-bs-toggle="modal" data-bs-target="#editPromotionModal"
                                                data-promo-id="<%= promo.getId() %>"
                                                data-promo-title="<%= promo.getTitle() %>"
                                                data-promo-description="<%= promo.getDescription() %>"
                                                data-promo-discount-type="<%= promo.isPercentage() ? "PERCENTAGE" : "FIXED_AMOUNT" %>"
                                                data-promo-discount-value="<%= decimalFormat.format(promo.getDiscountValue()) %>"
                                                data-promo-start="<%= startIso %>"
                                                data-promo-end="<%= endIso %>"
                                                data-promo-category-id="<%= promo.getCategoryId() != null ? promo.getCategoryId() : "" %>"
                                                data-promo-subcategory-id="<%= promo.getSubCategoryId() != null ? promo.getSubCategoryId() : "" %>">
                                            Edit
                                        </button>
                                        <form method="post" onsubmit="return confirm('Delete this promotion?');">
                                            <input type="hidden" name="action" value="delete" />
                                            <input type="hidden" name="id" value="<%= promo.getId() %>" />
                                            <button class="btn btn-sm btn-outline-danger" type="submit">Delete</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="5" class="text-center text-muted py-4">No promotions at the moment.</td>
                            </tr>
                            <%
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<div class="modal fade" id="editPromotionModal" tabindex="-1"
     aria-labelledby="editPromotionLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content glass-card">
            <div class="modal-header border-0 d-flex align-items-center justify-content-between">
                <h5 class="modal-title ms-auto" id="editProductLabel">
                    Edit promotion
                </h5>
                <button
                        type="button"
                        class="btn btn-sm btn-outline-light modal-close-btn rounded-circle"
                        data-bs-dismiss="modal"
                        aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <form id="editPromotionForm" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update" />
                    <input type="hidden" name="id" id="editPromotionId" />
                    <table class="table table-borderless align-middle form-table mb-0">
                        <tbody>
                        <tr>
                            <th scope="row" class="text-muted">Title</th>
                            <td><input class="form-control" type="text" name="title" id="editPromotionTitle" required /></td>
                        </tr>
                        <tr>
                            <th scope="row" class="text-muted">Category scope</th>
                            <td>
                                <select class="form-select select-btn" name="categoryId" id="editPromotionCategory">
                                    <option value="">All categories</option>
                                    <%
                                        if (categories != null) {
                                            for (Category category : categories) {
                                    %>
                                    <option value="<%= category.getId() %>"><%= category.getName() %></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row" class="text-muted">Sub-category scope</th>
                            <td>
                                <select class="form-select select-btn" name="subCategoryId" id="editPromotionSubCategory">
                                    <option value="">All sub-categories</option>
                                    <%
                                        if (subCategories != null) {
                                            for (SubCategory subCategory : subCategories) {
                                    %>
                                    <option value="<%= subCategory.getId() %>"><%= subCategory.getName() %> (<%= subCategory.getCategoryName() %>)</option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row" class="text-muted">Discount type</th>
                            <td>
                                <select class="form-select select-btn" name="discountType" id="editPromotionDiscountType">
                                    <option value="PERCENTAGE">Percentage</option>
                                    <option value="FIXED_AMOUNT">Fixed amount</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row" class="text-muted">Description</th>
                            <td><textarea class="form-control" name="description" id="editPromotionDescription" rows="3" required></textarea></td>
                        </tr>
                        <tr>
                            <th scope="row" class="text-muted">Value</th>
                            <td><input class="form-control" type="number" step="0.01" min="0" name="discountValue" id="editPromotionValue" required /></td>
                        </tr>
                        <tr>
                            <th scope="row" class="text-muted">Start</th>
                            <td><input class="form-control" type="datetime-local" name="startTime" id="editPromotionStart" required /></td>
                        </tr>
                        <tr>
                            <th scope="row" class="text-muted">End</th>
                            <td><input class="form-control" type="datetime-local" name="endTime" id="editPromotionEnd" required /></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-soft">Update</button>
                </div>
            </form>
        </div>
    </div>
</div>
<script>
    const editPromotionModal = document.getElementById('editPromotionModal');
    if (editPromotionModal) {
        editPromotionModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            if (!button) return;

            document.getElementById('editPromotionId').value = button.getAttribute('data-promo-id');
            document.getElementById('editPromotionTitle').value = button.getAttribute('data-promo-title') || '';
            document.getElementById('editPromotionDescription').value = button.getAttribute('data-promo-description') || '';
            document.getElementById('editPromotionDiscountType').value = button.getAttribute('data-promo-discount-type') || 'PERCENTAGE';
            document.getElementById('editPromotionValue').value = button.getAttribute('data-promo-discount-value') || '';
            document.getElementById('editPromotionStart').value = button.getAttribute('data-promo-start') || '';
            document.getElementById('editPromotionEnd').value = button.getAttribute('data-promo-end') || '';
            document.getElementById('editPromotionCategory').value = button.getAttribute('data-promo-category-id') || '';
            document.getElementById('editPromotionSubCategory').value = button.getAttribute('data-promo-subcategory-id') || '';
        });
    }
</script>
<jsp:include page="/WEB-INF/fragments/footer.jspf" />
<script src="${pageContext.request.contextPath}/assets/js/bootstrap-lite.js"></script>
</body>
</html>
