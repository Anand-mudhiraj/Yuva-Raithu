package com.yuvaraithu.backend.repository;

import com.yuvaraithu.backend.models.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByFarmerIdOrderByCreatedAtDesc(Long farmerId);
}
