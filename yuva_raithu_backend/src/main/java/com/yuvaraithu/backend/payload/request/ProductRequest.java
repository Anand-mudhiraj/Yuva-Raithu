package com.yuvaraithu.backend.payload.request;

import com.yuvaraithu.backend.models.Category;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
public class ProductRequest {
    @NotBlank
    private String name;

    @NotBlank
    private String brand;

    @NotNull
    private Double price;

    @NotNull
    private Category category;

    private String description;
    private String usageInstructions;
    private String benefits;
    
    @NotNull
    private Integer availableStock;

    private List<String> imageUrls;
}
