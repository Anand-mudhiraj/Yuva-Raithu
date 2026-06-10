package com.yuvaraithu.backend.controllers;

import com.yuvaraithu.backend.payload.request.ReviewRequest;
import com.yuvaraithu.backend.payload.response.ReviewDTO;
import com.yuvaraithu.backend.services.ReviewService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/reviews")
public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    @PostMapping
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<ReviewDTO> addReview(@Valid @RequestBody ReviewRequest reviewRequest, Authentication authentication) {
        ReviewDTO createdReview = reviewService.addReview(reviewRequest, authentication.getName());
        return ResponseEntity.ok(createdReview);
    }

    @GetMapping("/product/{productId}")
    public ResponseEntity<List<ReviewDTO>> getProductReviews(@PathVariable Long productId) {
        return ResponseEntity.ok(reviewService.getReviewsByProduct(productId));
    }
}
