<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List,org.example.model.Order,org.example.model.OrderItem,org.example.service.OrderService" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Orders | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body class="admin-shell">
<div class="container py-4">
    <jsp:include page="/WEB-INF/admin/admin-header.jspf" />

    <div class="card shadow-sm">
        <div class="card-body">
            <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-2 mb-3">
                <div>
                    <div class="eyebrow mb-1">
                        <span class="dot" aria-hidden="true"></span>
                        Orders overview
                    </div>
                    <h2 class="h5 mb-0">Manage all customer orders</h2>
                    <p class="text-muted small mb-0">Review every purchase, see who placed it, and adjust the status in real time.</p>
                </div>
            </div>
            <%
                List<Order> orders = (List<Order>) request.getAttribute("orders");
                if (orders == null || orders.isEmpty()) {
            %>
            <div class="alert alert-info mb-0">No orders have been placed yet.</div>
            <%
                } else {
                    for (Order order : orders) {
                        String status = order.getStatus();
                        if (status == null || status.isBlank()) {
                            status = OrderService.STATUS_PENDING;
                        }
                        String statusClass;
                        if (OrderService.STATUS_PENDING.equals(status)) {
                            statusClass = "text-warning fw-semibold";
                        } else if (OrderService.STATUS_DELIVERY.equals(status)) {
                            statusClass = "text-success fw-semibold";
                        } else if (OrderService.STATUS_DELIVERED.equals(status)) {
                            statusClass = "text-secondary text-decoration-line-through fw-semibold";
                        } else {
                            statusClass = "text-muted fw-semibold";
                        }
                        String statusLabel = status.replace("_", " ").toLowerCase();
                        statusLabel = Character.toUpperCase(statusLabel.charAt(0)) + statusLabel.substring(1);
            %>
            <div class="border rounded-3 p-3 mb-3">
                <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-2 mb-2">
                    <div>
                        <div class="fw-semibold">Order #<%= order.getId() %></div>
                        <div class="text-muted small">Placed by <strong><%= order.getUsername() != null ? order.getUsername() : "User " + order.getUserId() %></strong></div>
                        <div class="text-muted small">Created at <%= order.getCreatedAt() != null ? order.getCreatedAt() : "" %></div>
                    </div>
                    <div class="text-end">
                        <div class="<%= statusClass %>"><%= statusLabel %></div>
                        <div class="fw-semibold">Total: $<%= String.format("%.2f", order.getTotalAmount()) %></div>
                    </div>
                </div>
                <div class="bg-light rounded-3 p-2 mb-2">
                    <div class="small text-uppercase text-muted mb-1">Items</div>
                    <div class="d-flex flex-column gap-2">
                        <%
                            for (OrderItem item : order.getItems()) {
                        %>
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="fw-semibold mb-0"><%= item.getProductName() != null ? item.getProductName() : "Product " + item.getProductId() %></div>
                                <div class="text-muted small">Qty: <%= item.getQuantity() %></div>
                            </div>
                            <div class="text-end">
                                <div class="text-muted small">Unit: $<%= String.format("%.2f", item.getUnitPrice()) %></div>
                                <div class="fw-semibold">Line: $<%= String.format("%.2f", item.getLineTotal()) %></div>
                            </div>
                        </div>
                        <%
                            }
                        %>
                    </div>
                </div>
                <form method="post" class="d-flex flex-column flex-md-row align-items-md-center gap-2">
                    <input type="hidden" name="orderId" value="<%= order.getId() %>" />
                    <label for="status-<%= order.getId() %>" class="form-label mb-0">Status</label>
                    <select class="form-select w-auto" name="status" id="status-<%= order.getId() %>">
                        <option value="<%= OrderService.STATUS_PENDING %>" <%= OrderService.STATUS_PENDING.equals(status) ? "selected" : "" %>>Pending confirmation</option>
                        <option value="<%= OrderService.STATUS_DELIVERY %>" <%= OrderService.STATUS_DELIVERY.equals(status) ? "selected" : "" %>>In delivery</option>
                        <option value="<%= OrderService.STATUS_DELIVERED %>" <%= OrderService.STATUS_DELIVERED.equals(status) ? "selected" : "" %>>Delivered</option>
                    </select>
                    <button type="submit" class="btn btn-primary">Update status</button>
                </form>
            </div>
            <%
                    }
                }
            %>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>
