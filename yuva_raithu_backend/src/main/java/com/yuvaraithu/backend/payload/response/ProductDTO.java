package com.yuvaraithu.backend.payload.response;

import com.yuvaraithu.backend.models.Category;
import com.yuvaraithu.backend.models.Product;
import lombok.Data;

import java.util.List;

@Data
public class ProductDTO {
    private Long id;
    private String name;
    private String brand;
    private Double price;
    private Category category;
    private String description;
    private String usageInstructions;
    private String benefits;
    private Integer availableStock;
    private String dealerName;
    private Long dealerId;
    private List<String> imageUrls;
    private Double averageRating;
    private Integer totalReviews;

    public static ProductDTO fromEntity(Product product) {
        ProductDTO dto = new ProductDTO();
        dto.setId(product.getId());
        dto.setName(product.getName());
        dto.setBrand(product.getBrand());
        dto.setPrice(product.getPrice());
        dto.setCategory(product.getCategory());
        dto.setDescription(product.getDescription());
        dto.setUsageInstructions(product.getUsageInstructions());
        dto.setBenefits(product.getBenefits());
        dto.setAvailableStock(product.getAvailableStock());
        if (product.getDealer() != null) {
            dto.setDealerId(product.getDealer().getId());
            dto.setDealerName(product.getDealer().getFullName());
        }
        dto.setImageUrls(product.getImageUrls());
        dto.setAverageRating(product.getAverageRating());
        dto.setTotalReviews(product.getTotalReviews());
        return dto;
    }
}
