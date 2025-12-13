<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List,org.example.model.Order,org.example.model.OrderItem,org.example.service.OrderService" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body>
<jsp:include page="/WEB-INF/fragments/navbar.jspf" />
<main class="page-wrapper">
    <div class="container py-5" style="max-width: 960px;">
        <h2 class="h4 mb-4">Your orders</h2>
        <%
            List<Order> orders = (List<Order>) request.getAttribute("orders");
            if (orders == null || orders.isEmpty()) {
        %>
        <div class="alert alert-info">No orders yet. Start by adding products to your cart.</div>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/products">Browse catalog</a>
        <%
            } else {
                for (Order order : orders) {
                    String status = order.getStatus();
                    if (status == null || status.isBlank()) {
                        status = OrderService.STATUS_PENDING;
                    }
                    String statusLabel = status.replace("_", " ").toLowerCase();
                    statusLabel = Character.toUpperCase(statusLabel.charAt(0)) + statusLabel.substring(1);

                    String badgeClass;
                    int progress;
                    if (OrderService.STATUS_PENDING.equals(status)) {
                        badgeClass = "bg-warning text-dark";
                        progress = 25;
                    } else if (OrderService.STATUS_DELIVERY.equals(status)) {
                        badgeClass = "bg-info text-dark";
                        progress = 65;
                    } else if (OrderService.STATUS_DELIVERED.equals(status)) {
                        badgeClass = "bg-success";
                        progress = 100;
                    } else {
                        badgeClass = "bg-secondary";
                        progress = 40;
                    }
        %>
        <div class="card shadow-sm mb-3">
            <div class="card-body d-flex justify-content-between align-items-center">
                <div>
                    <div class="fw-semibold">Order #<%= order.getId() %></div>
                    <div class="text-muted small">Placed on <%= order.getCreatedAt() != null ? order.getCreatedAt() : "" %></div>
                </div>
                <div class="text-end">
                    <div class="fw-semibold mb-1">Total: $<%= String.format("%.2f", order.getTotalAmount()) %></div>
                    <span class="badge <%= badgeClass %>">Status: <%= statusLabel %></span>
                </div>
            </div>
            <div class="px-3 pb-3">
                <div class="d-flex justify-content-between align-items-center mb-1 small text-muted">
                    <span>Order progress</span>
                    <span><%= progress %>%</span>
                </div>
                <div class="progress" role="progressbar" aria-valuenow="<%= progress %>" aria-valuemin="0" aria-valuemax="100">
                    <div class="progress-bar <%= badgeClass %>" style="width: <%= progress %>%"></div>
                </div>
            </div>
            <div class="list-group list-group-flush">
                <%
                    for (OrderItem item : order.getItems()) {
                %>
                <div class="list-group-item d-flex justify-content-between align-items-center">
                    <div>
                        <div class="fw-semibold"><%= item.getProductName() != null ? item.getProductName() : "Product " + item.getProductId() %></div>
                        <div class="text-muted small">Quantity: <%= item.getQuantity() %></div>
                    </div>
                    <div class="text-end">
                        <div class="text-muted">Unit: $<%= String.format("%.2f", item.getUnitPrice()) %></div>
                        <div class="fw-semibold">Line: $<%= String.format("%.2f", item.getLineTotal()) %></div>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
        </div>
        <%
                }
            }
        %>
    </div>
</main>
<jsp:include page="/WEB-INF/fragments/footer.jspf" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>
