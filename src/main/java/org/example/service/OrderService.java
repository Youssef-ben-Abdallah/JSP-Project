package org.example.service;

import org.example.model.CartItem;
import org.example.model.Order;
import org.example.model.OrderItem;
import org.example.repository.OrderRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class OrderService {
    private final OrderRepository orderRepository = new OrderRepository();
    public static final String STATUS_PENDING = "PENDING_CONFIRMATION";
    public static final String STATUS_DELIVERY = "IN_DELIVERY";
    public static final String STATUS_DELIVERED = "DELIVERED";

    public int placeOrder(int userId, Map<Integer, CartItem> cartItems) throws Exception {
        List<OrderItem> items = new ArrayList<>();
        double total = 0;
        for (CartItem cartItem : cartItems.values()) {
            OrderItem orderItem = new OrderItem();
            orderItem.setProductId(cartItem.getProduct().getId());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setUnitPrice(cartItem.getProduct().getPrice());
            total += cartItem.getQuantity() * cartItem.getProduct().getPrice();
            items.add(orderItem);
        }
        return orderRepository.createOrder(userId, total, items, STATUS_PENDING);
    }

    public List<Order> getOrdersForUser(int userId) {
        try {
            return orderRepository.findByUserId(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    public List<Order> getAllOrders() {
        try {
            return orderRepository.findAll();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    public void updateOrderStatus(int orderId, String status) {
        if (status == null || status.isBlank()) {
            throw new IllegalArgumentException("Status must be provided");
        }
        if (!(STATUS_PENDING.equals(status) || STATUS_DELIVERY.equals(status) || STATUS_DELIVERED.equals(status))) {
            throw new IllegalArgumentException("Unsupported status value");
        }
        try {
            orderRepository.updateStatus(orderId, status);
        } catch (Exception e) {
            throw new RuntimeException("Unable to update order status", e);
        }
    }
}
