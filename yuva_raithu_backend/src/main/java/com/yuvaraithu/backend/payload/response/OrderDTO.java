package com.yuvaraithu.backend.payload.response;

import com.yuvaraithu.backend.models.Order;
import com.yuvaraithu.backend.models.OrderStatus;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Data
public class OrderDTO {
    private Long id;
    private Long farmerId;
    private String farmerName;
    private OrderStatus status;
    private Double totalAmount;
    private String deliveryAddress;
    private String paymentMethod;
    private String paymentTransactionId;
    private LocalDateTime createdAt;
    private List<OrderItemDTO> items;

    public static OrderDTO fromEntity(Order order) {
        OrderDTO dto = new OrderDTO();
        dto.setId(order.getId());
        dto.setFarmerId(order.getFarmer().getId());
        dto.setFarmerName(order.getFarmer().getFullName());
        dto.setStatus(order.getStatus());
        dto.setTotalAmount(order.getTotalAmount());
        dto.setDeliveryAddress(order.getDeliveryAddress());
        dto.setPaymentMethod(order.getPaymentMethod());
        dto.setPaymentTransactionId(order.getPaymentTransactionId());
        dto.setCreatedAt(order.getCreatedAt());
        dto.setItems(order.getItems().stream()
                .map(OrderItemDTO::fromEntity)
                .collect(Collectors.toList()));
        return dto;
    }
}
