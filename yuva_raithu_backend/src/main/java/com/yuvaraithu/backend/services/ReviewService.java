package com.yuvaraithu.backend.services;

import com.yuvaraithu.backend.models.Product;
import com.yuvaraithu.backend.models.Review;
import com.yuvaraithu.backend.models.User;
import com.yuvaraithu.backend.payload.request.ReviewRequest;
import com.yuvaraithu.backend.payload.response.ReviewDTO;
import com.yuvaraithu.backend.repository.ProductRepository;
import com.yuvaraithu.backend.repository.ReviewRepository;
import com.yuvaraithu.backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ReviewService {

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private UserRepository userRepository;

    @Transactional
    public ReviewDTO addReview(ReviewRequest request, String username) {
        User user = userRepository.findByPhoneNumber(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Product product = productRepository.findById(request.getProductId())
                .orElseThrow(() -> new RuntimeException("Product not found"));

        Review review = new Review();
        review.setProduct(product);
        review.setUser(user);
        review.setRating(request.getRating());
        review.setComment(request.getComment());

        Review savedReview = reviewRepository.save(review);

        // Update Product average rating
        List<Review> productReviews = reviewRepository.findByProductIdOrderByCreatedAtDesc(product.getId());
        double averageRating = productReviews.stream()
                .mapToInt(Review::getRating)
                .average()
                .orElse(0.0);

        product.setAverageRating(Math.round(averageRating * 10.0) / 10.0);
        product.setTotalReviews(productReviews.size());
        productRepository.save(product);

        return ReviewDTO.fromEntity(savedReview);
    }

    public List<ReviewDTO> getReviewsByProduct(Long productId) {
        return reviewRepository.findByProductIdOrderByCreatedAtDesc(productId).stream()
                .map(ReviewDTO::fromEntity)
                .collect(Collectors.toList());
    }
}
