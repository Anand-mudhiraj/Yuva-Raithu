package com.yuvaraithu.backend.payload.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
public class OrderRequest {
    @NotNull
    private List<OrderItemRequest> items;

    @NotBlank
    private String deliveryAddress;

    @NotBlank
    private String paymentMethod;
}
