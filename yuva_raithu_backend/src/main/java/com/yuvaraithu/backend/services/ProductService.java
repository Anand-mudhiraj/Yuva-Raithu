package com.yuvaraithu.backend.services;

import com.yuvaraithu.backend.models.Category;
import com.yuvaraithu.backend.models.Product;
import com.yuvaraithu.backend.models.User;
import com.yuvaraithu.backend.payload.request.ProductRequest;
import com.yuvaraithu.backend.payload.response.ProductDTO;
import com.yuvaraithu.backend.repository.ProductRepository;
import com.yuvaraithu.backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ProductService {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private UserRepository userRepository;

    public List<ProductDTO> getAllProducts() {
        return productRepository.findAll().stream()
                .map(ProductDTO::fromEntity)
                .collect(Collectors.toList());
    }

    public List<ProductDTO> getProductsByCategory(Category category) {
        return productRepository.findByCategory(category).stream()
                .map(ProductDTO::fromEntity)
                .collect(Collectors.toList());
    }

    public List<ProductDTO> searchProducts(String name) {
        return productRepository.findByNameContainingIgnoreCase(name).stream()
                .map(ProductDTO::fromEntity)
                .collect(Collectors.toList());
    }

    public ProductDTO getProductById(Long id) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));
        return ProductDTO.fromEntity(product);
    }

    public ProductDTO createProduct(ProductRequest request, String dealerUsername) {
        User dealer = userRepository.findByPhoneNumber(dealerUsername)
                .orElseThrow(() -> new RuntimeException("Dealer not found"));

        Product product = new Product();
        product.setName(request.getName());
        product.setBrand(request.getBrand());
        product.setPrice(request.getPrice());
        product.setCategory(request.getCategory());
        product.setDescription(request.getDescription());
        product.setUsageInstructions(request.getUsageInstructions());
        product.setBenefits(request.getBenefits());
        product.setAvailableStock(request.getAvailableStock());
        product.setImageUrls(request.getImageUrls());
        product.setDealer(dealer);

        Product savedProduct = productRepository.save(product);
        return ProductDTO.fromEntity(savedProduct);
    }
}
