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
        return orderRepository.createOrder(userId, total, items);
    }

    public List<Order> getOrdersForUser(int userId) {
        try {
            return orderRepository.findByUserId(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }
}
