package com.yuvaraithu.backend.controllers;

import com.yuvaraithu.backend.models.Category;
import com.yuvaraithu.backend.payload.request.ProductRequest;
import com.yuvaraithu.backend.payload.response.ProductDTO;
import com.yuvaraithu.backend.services.ProductService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/products")
public class ProductController {

    @Autowired
    private ProductService productService;

    @GetMapping
    public ResponseEntity<List<ProductDTO>> getAllProducts() {
        return ResponseEntity.ok(productService.getAllProducts());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProductDTO> getProductById(@PathVariable Long id) {
        return ResponseEntity.ok(productService.getProductById(id));
    }

    @GetMapping("/category/{category}")
    public ResponseEntity<List<ProductDTO>> getProductsByCategory(@PathVariable Category category) {
        return ResponseEntity.ok(productService.getProductsByCategory(category));
    }

    @GetMapping("/search")
    public ResponseEntity<List<ProductDTO>> searchProducts(@RequestParam String q) {
        return ResponseEntity.ok(productService.searchProducts(q));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('DEALER') or hasAuthority('ADMIN')")
    public ResponseEntity<ProductDTO> createProduct(@Valid @RequestBody ProductRequest productRequest, Authentication authentication) {
        // authentication.getName() returns the username (phoneNumber) of the logged-in user
        ProductDTO createdProduct = productService.createProduct(productRequest, authentication.getName());
        return ResponseEntity.ok(createdProduct);
    }
}
