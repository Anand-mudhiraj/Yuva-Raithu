package com.yuvaraithu.backend.services;

import com.yuvaraithu.backend.models.*;
import com.yuvaraithu.backend.payload.request.OrderRequest;
import com.yuvaraithu.backend.payload.request.OrderItemRequest;
import com.yuvaraithu.backend.payload.response.OrderDTO;
import com.yuvaraithu.backend.repository.OrderRepository;
import com.yuvaraithu.backend.repository.ProductRepository;
import com.yuvaraithu.backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private UserRepository userRepository;

    @Transactional
    public OrderDTO createOrder(OrderRequest request, String farmerUsername) {
        User farmer = userRepository.findByPhoneNumber(farmerUsername)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Order order = new Order();
        order.setFarmer(farmer);
        order.setDeliveryAddress(request.getDeliveryAddress());
        order.setPaymentMethod(request.getPaymentMethod());

        List<OrderItem> orderItems = new ArrayList<>();
        double totalAmount = 0.0;

        for (OrderItemRequest itemReq : request.getItems()) {
            Product product = productRepository.findById(itemReq.getProductId())
                    .orElseThrow(() -> new RuntimeException("Product not found"));

            if (product.getAvailableStock() < itemReq.getQuantity()) {
                throw new RuntimeException("Insufficient stock for product: " + product.getName());
            }

            // Deduct stock
            product.setAvailableStock(product.getAvailableStock() - itemReq.getQuantity());
            productRepository.save(product);

            OrderItem orderItem = new OrderItem();
            orderItem.setOrder(order);
            orderItem.setProduct(product);
            orderItem.setQuantity(itemReq.getQuantity());
            orderItem.setPriceAtPurchase(product.getPrice());

            totalAmount += (product.getPrice() * itemReq.getQuantity());
            orderItems.add(orderItem);
        }

        order.setItems(orderItems);
        order.setTotalAmount(totalAmount);
        
        // Mocking Razorpay ID for now if payment method is Razorpay
        if ("RAZORPAY".equalsIgnoreCase(request.getPaymentMethod())) {
            order.setPaymentTransactionId("pay_" + System.currentTimeMillis());
        }

        Order savedOrder = orderRepository.save(order);
        return OrderDTO.fromEntity(savedOrder);
    }

    public List<OrderDTO> getOrdersForFarmer(String farmerUsername) {
        User farmer = userRepository.findByPhoneNumber(farmerUsername)
                .orElseThrow(() -> new RuntimeException("User not found"));

        return orderRepository.findByFarmerIdOrderByCreatedAtDesc(farmer.getId()).stream()
                .map(OrderDTO::fromEntity)
                .collect(Collectors.toList());
    }

    public OrderDTO updateOrderStatus(Long orderId, OrderStatus newStatus) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));
        
        order.setStatus(newStatus);
        Order savedOrder = orderRepository.save(order);
        return OrderDTO.fromEntity(savedOrder);
    }
}
