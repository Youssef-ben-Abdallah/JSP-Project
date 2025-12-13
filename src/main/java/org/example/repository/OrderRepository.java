package org.example.repository;

import org.example.model.Order;
import org.example.model.OrderItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class OrderRepository {
    public int createOrder(int userId, double totalAmount, List<OrderItem> items) throws Exception {
        String orderSql = "INSERT INTO orders (user_id, total_amount, created_at) VALUES (?, ?, NOW())";
        String itemSql = "INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            int orderId;
            try (PreparedStatement orderStmt = con.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                orderStmt.setInt(1, userId);
                orderStmt.setDouble(2, totalAmount);
                orderStmt.executeUpdate();
                try (ResultSet rs = orderStmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                    } else {
                        con.rollback();
                        throw new IllegalStateException("Unable to retrieve order id");
                    }
                }
            }
            try (PreparedStatement itemStmt = con.prepareStatement(itemSql)) {
                for (OrderItem item : items) {
                    itemStmt.setInt(1, orderId);
                    itemStmt.setInt(2, item.getProductId());
                    itemStmt.setInt(3, item.getQuantity());
                    itemStmt.setDouble(4, item.getUnitPrice());
                    itemStmt.addBatch();
                }
                itemStmt.executeBatch();
            }
            con.commit();
            return orderId;
        }
    }

    public List<Order> findByUserId(int userId) throws Exception {
        String sql = "SELECT o.id, o.user_id, o.total_amount, o.created_at, u.username, " +
                "oi.product_id, oi.quantity, oi.unit_price, p.name AS product_name " +
                "FROM orders o " +
                "JOIN users u ON o.user_id = u.id " +
                "LEFT JOIN order_items oi ON o.id = oi.order_id " +
                "LEFT JOIN products p ON oi.product_id = p.id " +
                "WHERE o.user_id = ? " +
                "ORDER BY o.created_at DESC, o.id DESC";
        Map<Integer, Order> orders = new LinkedHashMap<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int orderId = rs.getInt("id");
                    Order order = orders.computeIfAbsent(orderId, id -> {
                        Order o = new Order();
                        o.setId(id);
                        o.setUserId(rsGetIntSafe(rs, "user_id"));
                        o.setUsername(rsGetStringSafe(rs, "username"));
                        o.setTotalAmount(rsGetDoubleSafe(rs, "total_amount"));
                        Timestamp ts = rsGetTimestampSafe(rs, "created_at");
                        if (ts != null) {
                            o.setCreatedAt(ts.toLocalDateTime());
                        } else {
                            o.setCreatedAt(LocalDateTime.now());
                        }
                        return o;
                    });
                    int productId = rs.getInt("product_id");
                    if (productId > 0) {
                        OrderItem item = new OrderItem();
                        item.setOrderId(orderId);
                        item.setProductId(productId);
                        item.setQuantity(rsGetIntSafe(rs, "quantity"));
                        item.setUnitPrice(rsGetDoubleSafe(rs, "unit_price"));
                        item.setProductName(rsGetStringSafe(rs, "product_name"));
                        order.getItems().add(item);
                    }
                }
            }
        }
        return new ArrayList<>(orders.values());
    }

    private Integer rsGetIntSafe(ResultSet rs, String column) {
        try {
            return rs.getInt(column);
        } catch (Exception e) {
            return null;
        }
    }

    private String rsGetStringSafe(ResultSet rs, String column) {
        try {
            return rs.getString(column);
        } catch (Exception e) {
            return null;
        }
    }

    private Double rsGetDoubleSafe(ResultSet rs, String column) {
        try {
            return rs.getDouble(column);
        } catch (Exception e) {
            return null;
        }
    }

    private Timestamp rsGetTimestampSafe(ResultSet rs, String column) {
        try {
            return rs.getTimestamp(column);
        } catch (Exception e) {
            return null;
        }
    }
}
