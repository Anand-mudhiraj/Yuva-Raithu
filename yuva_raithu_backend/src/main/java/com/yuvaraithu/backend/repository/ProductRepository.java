package com.yuvaraithu.backend.repository;

import com.yuvaraithu.backend.models.Category;
import com.yuvaraithu.backend.models.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    List<Product> findByCategory(Category category);
    List<Product> findByNameContainingIgnoreCase(String name);
    List<Product> findByDealerId(Long dealerId);
}
