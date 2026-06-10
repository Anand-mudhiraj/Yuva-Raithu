package com.yuvaraithu.backend.controllers;

import com.yuvaraithu.backend.models.OrderStatus;
import com.yuvaraithu.backend.payload.request.OrderRequest;
import com.yuvaraithu.backend.payload.response.OrderDTO;
import com.yuvaraithu.backend.services.OrderService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/orders")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @PostMapping
    @PreAuthorize("hasAuthority('FARMER')")
    public ResponseEntity<OrderDTO> createOrder(@Valid @RequestBody OrderRequest orderRequest, Authentication authentication) {
        OrderDTO createdOrder = orderService.createOrder(orderRequest, authentication.getName());
        return ResponseEntity.ok(createdOrder);
    }

    @GetMapping("/my-orders")
    @PreAuthorize("hasAuthority('FARMER')")
    public ResponseEntity<List<OrderDTO>> getMyOrders(Authentication authentication) {
        return ResponseEntity.ok(orderService.getOrdersForFarmer(authentication.getName()));
    }

    @PutMapping("/{id}/status")
    @PreAuthorize("hasAuthority('DEALER') or hasAuthority('ADMIN')")
    public ResponseEntity<OrderDTO> updateOrderStatus(@PathVariable Long id, @RequestParam OrderStatus status) {
        return ResponseEntity.ok(orderService.updateOrderStatus(id, status));
    }
}
