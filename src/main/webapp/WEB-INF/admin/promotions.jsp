<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.model.Promotion" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gestion des promotions</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body>
<jsp:include page="/WEB-INF/fragments/navbar.jspf" />
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
            <div class="col-lg-5">
                <div class="glass-card p-4 h-100">
                    <h3 class="mb-3">Créer une promotion</h3>
                    <p class="text-muted">Proposez une offre limitée dans le temps. Elle s'affichera automatiquement sur le site pendant sa période de validité.</p>
                    <form method="post" class="promo-form">
                        <input type="hidden" name="action" value="create" />
                        <div class="mb-3">
                            <label class="form-label">Titre</label>
                            <input class="form-control" type="text" name="title" required />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea class="form-control" name="description" rows="3" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Type de remise</label>
                            <select class="form-select" name="discountType">
                                <option value="PERCENTAGE">Pourcentage</option>
                                <option value="FIXED_AMOUNT">Montant fixe</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Valeur</label>
                            <input class="form-control" type="number" step="0.01" min="0" name="discountValue" required />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Début</label>
                            <input class="form-control" type="datetime-local" name="startTime" required />
                        </div>
                        <div class="mb-4">
                            <label class="form-label">Fin</label>
                            <input class="form-control" type="datetime-local" name="endTime" required />
                        </div>
                        <button class="btn-soft w-100" type="submit">Publier la promotion</button>
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
                    <h3 class="mb-4">Promotions programmées</h3>
                    <div class="table-responsive">
                        <table class="table align-middle text-white promo-table">
                            <thead>
                            <tr>
                                <th>Titre</th>
                                <th>Période</th>
                                <th>Remise</th>
                                <th></th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                List<Promotion> promos = (List<Promotion>) request.getAttribute("promotions");
                                if (promos != null && !promos.isEmpty()) {
                                    java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm");
                                    java.time.format.DateTimeFormatter isoFormatter = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                                    java.text.DecimalFormat decimalFormat = new java.text.DecimalFormat("#.##");
                                    for (Promotion promo : promos) {
                                        java.time.LocalDateTime startTime = promo.getStartTime();
                                        java.time.LocalDateTime endTime = promo.getEndTime();
                                        String startDisplay = startTime != null ? startTime.format(formatter) : "Non planifiée";
                                        String endDisplay = endTime != null ? endTime.format(formatter) : "Non définie";
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
                                        <%= promo.isPercentage() ? decimalFormat.format(promo.getDiscountValue()) + "%" : "-" + decimalFormat.format(promo.getDiscountValue()) + "€" %>
                                    </span>
                                </td>
                                <td class="text-end">
                                    <div class="d-flex justify-content-end gap-2">
                                        <button class="btn btn-sm btn-outline-light" type="button"
                                                data-bs-toggle="modal" data-bs-target="#editPromotionModal<%= promo.getId() %>">
                                            Modifier
                                        </button>
                                        <form method="post" onsubmit="return confirm('Supprimer cette promotion ?');">
                                            <input type="hidden" name="action" value="delete" />
                                            <input type="hidden" name="id" value="<%= promo.getId() %>" />
                                            <button class="btn btn-sm btn-outline-danger" type="submit">Supprimer</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="4" class="text-center text-muted py-4">Aucune promotion pour le moment.</td>
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
<%
    if (promos != null && !promos.isEmpty()) {
        java.time.format.DateTimeFormatter isoFormatter = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
        for (Promotion promo : promos) {
%>
<div class="modal fade" id="editPromotionModal<%= promo.getId() %>" tabindex="-1"
     aria-labelledby="editPromotionLabel<%= promo.getId() %>" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content glass-card">
            <div class="modal-header border-0">
                <h5 class="modal-title" id="editPromotionLabel<%= promo.getId() %>">Modifier la promotion</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update" />
                    <input type="hidden" name="id" value="<%= promo.getId() %>" />
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Titre</label>
                            <input class="form-control" type="text" name="title" value="<%= promo.getTitle() %>" required />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Type de remise</label>
                            <select class="form-select" name="discountType">
                                <option value="PERCENTAGE" <%= promo.isPercentage() ? "selected" : "" %>>Pourcentage</option>
                                <option value="FIXED_AMOUNT" <%= promo.isPercentage() ? "" : "selected" %>>Montant fixe</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Description</label>
                            <textarea class="form-control" name="description" rows="3" required><%= promo.getDescription() %></textarea>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Valeur</label>
                            <input class="form-control" type="number" step="0.01" min="0" name="discountValue" value="<%= promo.getDiscountValue() %>" required />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Début</label>
                            <input class="form-control" type="datetime-local" name="startTime" value="<%= promo.getStartTime() != null ? promo.getStartTime().format(isoFormatter) : "" %>" required />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Fin</label>
                            <input class="form-control" type="datetime-local" name="endTime" value="<%= promo.getEndTime() != null ? promo.getEndTime().format(isoFormatter) : "" %>" required />
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn-soft">Mettre à jour</button>
                </div>
            </form>
        </div>
    </div>
</div>
<%
        }
    }
%>
<jsp:include page="/WEB-INF/fragments/footer.jspf" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
