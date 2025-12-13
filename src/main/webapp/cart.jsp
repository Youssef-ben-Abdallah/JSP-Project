<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.Map,org.example.model.CartItem" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Cart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body>
<jsp:include page="/WEB-INF/fragments/navbar.jspf" />
<main class="page-wrapper">
    <div class="container py-5" style="max-width: 960px;">
        <h2 class="h4 mb-4">Your cart</h2>
        <%
            String cartError = (String) session.getAttribute("cartError");
            String cartSuccess = (String) session.getAttribute("cartSuccess");
            session.removeAttribute("cartError");
            session.removeAttribute("cartSuccess");
            if (cartError != null) {
        %>
        <div class="alert alert-danger"><%= cartError %></div>
        <%
            }
            if (cartSuccess != null) {
        %>
        <div class="alert alert-success"><%= cartSuccess %></div>
        <%
            }
            Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
            if (cart == null || cart.isEmpty()) {
        %>
        <div class="alert alert-info">Your cart is empty.</div>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/products">Browse products</a>
        <%
            } else {
                double total = 0;
        %>
        <div class="card shadow-sm">
            <div class="table-responsive">
                <table class="table mb-0 align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>Product</th>
                        <th class="text-center">Quantity</th>
                        <th class="text-end">Price</th>
                        <th class="text-end">Total</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        for (CartItem item : cart.values()) {
                            double lineTotal = item.getLineTotal();
                            total += lineTotal;
                    %>
                    <tr>
                        <td>
                            <div class="fw-semibold"><%= item.getProduct().getName() %></div>
                            <div class="text-muted small">Ref: <%= item.getProduct().getId() %></div>
                        </td>
                        <td class="text-center" style="max-width: 120px;">
                            <form method="post" action="${pageContext.request.contextPath}/cart" class="d-flex justify-content-center gap-1">
                                <input type="hidden" name="action" value="update" />
                                <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>" />
                                <input class="form-control form-control-sm" type="number" name="quantity" value="<%= item.getQuantity() %>" min="1" />
                                <button class="btn btn-outline-primary btn-sm" type="submit">Update</button>
                            </form>
                        </td>
                        <td class="text-end">$<%= String.format("%.2f", item.getProduct().getPrice()) %></td>
                        <td class="text-end">$<%= String.format("%.2f", lineTotal) %></td>
                        <td class="text-end">
                            <form method="post" action="${pageContext.request.contextPath}/cart" class="d-inline">
                                <input type="hidden" name="action" value="remove" />
                                <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>" />
                                <button class="btn btn-link text-danger p-0">Remove</button>
                            </form>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
            <div class="card-body d-flex justify-content-between align-items-center">
                <div class="fw-semibold">Total: $<%= String.format("%.2f", total) %></div>
                <form method="post" action="${pageContext.request.contextPath}/cart">
                    <input type="hidden" name="action" value="checkout" />
                    <button class="btn btn-success" type="submit">Place order</button>
                </form>
            </div>
        </div>
        <%
            }
        %>
    </div>
</main>
<jsp:include page="/WEB-INF/fragments/footer.jspf" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>
