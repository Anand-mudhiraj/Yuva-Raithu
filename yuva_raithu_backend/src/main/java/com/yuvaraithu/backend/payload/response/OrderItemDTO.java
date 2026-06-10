package com.yuvaraithu.backend.payload.response;

import com.yuvaraithu.backend.models.OrderItem;
import lombok.Data;

@Data
public class OrderItemDTO {
    private Long id;
    private Long productId;
    private String productName;
    private String productBrand;
    private Integer quantity;
    private Double priceAtPurchase;
    private Long dealerId;

    public static OrderItemDTO fromEntity(OrderItem item) {
        OrderItemDTO dto = new OrderItemDTO();
        dto.setId(item.getId());
        dto.setProductId(item.getProduct().getId());
        dto.setProductName(item.getProduct().getName());
        dto.setProductBrand(item.getProduct().getBrand());
        dto.setQuantity(item.getQuantity());
        dto.setPriceAtPurchase(item.getPriceAtPurchase());
        dto.setDealerId(item.getProduct().getDealer().getId());
        return dto;
    }
}
