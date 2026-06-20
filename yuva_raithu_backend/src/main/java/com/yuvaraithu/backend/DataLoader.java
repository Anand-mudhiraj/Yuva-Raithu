package com.yuvaraithu.backend;

import com.yuvaraithu.backend.models.Product;
import com.yuvaraithu.backend.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import com.yuvaraithu.backend.models.Category;
import com.yuvaraithu.backend.models.User;
import com.yuvaraithu.backend.models.Role;
import com.yuvaraithu.backend.repository.UserRepository;
import java.util.List;

@Component
public class DataLoader implements CommandLineRunner {

    @Autowired
    private ProductRepository productRepository;
    
    @Autowired
    private UserRepository userRepository;

    @Override
    public void run(String... args) throws Exception {
        if (productRepository.count() < 12) {
            System.out.println("Clearing old data and seeding database with demo products...");
            productRepository.deleteAll();
            
            // Create a dummy dealer if it doesn't exist
            User dealer = userRepository.findByPhoneNumber("9999999999").orElseGet(() -> {
                User u = new User();
                u.setEmail("dealer@dummy.com");
                u.setFullName("Dummy Dealer");
                u.setPhoneNumber("9999999999");
                u.setPassword("password");
                return userRepository.save(u);
            });

            // SEEDS
            Product s1 = new Product();
            s1.setName("Cotton Seeds (Premium Bt)");
            s1.setCategory(Category.SEEDS);
            s1.setBrand("Nuziveedu");
            s1.setPrice(850.00);
            s1.setAvailableStock(150);
            s1.setImageUrls(List.of("https://5.imimg.com/data5/SELLER/Default/2021/3/EM/QJ/PP/55127022/nuziveedu-cotton-seeds-500x500.jpg"));
            s1.setDescription("High yield Bt cotton seeds, resistant to bollworm.");
            s1.setAverageRating(4.8);
            s1.setDealer(dealer);

            Product s2 = new Product();
            s2.setName("Paddy Seeds (IR64)");
            s2.setCategory(Category.SEEDS);
            s2.setBrand("AgriGenetics");
            s2.setPrice(1200.00);
            s2.setAvailableStock(50);
            s2.setImageUrls(List.of("https://5.imimg.com/data5/SELLER/Default/2023/5/309320625/ON/SJ/KT/4828695/ir-64-paddy-seeds-500x500.png"));
            s2.setDescription("High yielding paddy seeds suitable for all seasons.");
            s2.setAverageRating(4.2);
            s2.setDealer(dealer);

            Product s3 = new Product();
            s3.setName("Maize Seeds (Hybrid)");
            s3.setCategory(Category.SEEDS);
            s3.setBrand("Pioneer");
            s3.setPrice(1500.00);
            s3.setAvailableStock(80);
            s3.setImageUrls(List.of("https://5.imimg.com/data5/SELLER/Default/2020/12/EM/QJ/PP/55127022/maize-seeds-500x500.jpg"));
            s3.setDescription("Drought tolerant hybrid maize seeds.");
            s3.setAverageRating(4.5);
            s3.setDealer(dealer);

            // FERTILIZERS
            Product f1 = new Product();
            f1.setName("Urea Fertilizer (Neem Coated)");
            f1.setCategory(Category.FERTILIZERS);
            f1.setBrand("Kisan");
            f1.setPrice(350.00);
            f1.setAvailableStock(500);
            f1.setImageUrls(List.of("https://5.imimg.com/data5/SELLER/Default/2020/10/EM/VK/DE/98428586/neem-coated-urea.jpg"));
            f1.setDescription("High quality neem coated urea for better crop yield.");
            f1.setAverageRating(4.7);
            f1.setDealer(dealer);

            Product f2 = new Product();
            f2.setName("DAP Fertilizer");
            f2.setCategory(Category.FERTILIZERS);
            f2.setBrand("IFFCO");
            f2.setPrice(1350.00);
            f2.setAvailableStock(300);
            f2.setImageUrls(List.of("https://5.imimg.com/data5/SELLER/Default/2021/8/EM/QJ/PP/55127022/iffco-dap-fertilizer-500x500.jpg"));
            f2.setDescription("Rich in Phosphorus and Nitrogen.");
            f2.setAverageRating(4.9);
            f2.setDealer(dealer);

            Product f3 = new Product();
            f3.setName("NPK Fertilizer (19:19:19)");
            f3.setCategory(Category.FERTILIZERS);
            f3.setBrand("Coromandel");
            f3.setPrice(450.00);
            f3.setAvailableStock(200);
            f3.setImageUrls(List.of("https://5.imimg.com/data5/SELLER/Default/2021/4/EM/QJ/PP/55127022/npk-fertilizer-500x500.jpg"));
            f3.setDescription("Water soluble NPK complex fertilizer.");
            f3.setAverageRating(4.1);
            f3.setDealer(dealer);

            Product f4 = new Product();
            f4.setName("MOP Fertilizer (Muriate of Potash)");
            f4.setCategory(Category.FERTILIZERS);
            f4.setBrand("IPL");
            f4.setPrice(1000.00);
            f4.setAvailableStock(150);
            f4.setImageUrls(List.of("https://5.imimg.com/data5/SELLER/Default/2022/1/EM/QJ/PP/55127022/mop-fertilizer-500x500.jpg"));
            f4.setDescription("Potassium rich fertilizer for fruit size and quality.");
            f4.setAverageRating(4.6);
            f4.setDealer(dealer);

            // PESTICIDES
            Product p1 = new Product();
            p1.setName("Bayer Insecticide (Confidor)");
            p1.setCategory(Category.PESTICIDES);
            p1.setBrand("Bayer");
            p1.setPrice(450.00);
            p1.setAvailableStock(120);
            p1.setImageUrls(List.of("https://5.imimg.com/data5/ANDROID/Default/2020/8/EM/QJ/PP/55127022/product-jpeg-500x500.jpg"));
            p1.setDescription("Systemic insecticide for sucking pests.");
            p1.setAverageRating(4.8);
            p1.setDealer(dealer);

            Product p2 = new Product();
            p2.setName("Syngenta Pest Control (Alika)");
            p2.setCategory(Category.PESTICIDES);
            p2.setBrand("Syngenta");
            p2.setPrice(650.00);
            p2.setAvailableStock(90);
            p2.setImageUrls(List.of("https://5.imimg.com/data5/SELLER/Default/2021/6/EM/QJ/PP/55127022/alika-insecticide-500x500.jpg"));
            p2.setDescription("Broad spectrum insecticide with dual mode of action.");
            p2.setAverageRating(4.4);
            p2.setDealer(dealer);

            // EQUIPMENT
            Product e1 = new Product();
            e1.setName("Tractor Rental (Per Hour)");
            e1.setCategory(Category.EQUIPMENT);
            e1.setBrand("Mahindra");
            e1.setPrice(800.00);
            e1.setAvailableStock(5);
            e1.setImageUrls(List.of("https://5.imimg.com/data5/SELLER/Default/2020/11/EM/QJ/PP/55127022/mahindra-tractor-500x500.jpg"));
            e1.setDescription("Heavy duty tractor available for rent. Price per hour.");
            e1.setAverageRating(4.9);
            e1.setDealer(dealer);

            Product e2 = new Product();
            e2.setName("Power Sprayer (16L)");
            e2.setCategory(Category.EQUIPMENT);
            e2.setBrand("Neptune");
            e2.setPrice(2500.00);
            e2.setAvailableStock(20);
            e2.setImageUrls(List.of("https://5.imimg.com/data5/SELLER/Default/2020/9/EM/QJ/PP/55127022/battery-sprayer-pump-500x500.jpg"));
            e2.setDescription("Battery operated knapsack sprayer.");
            e2.setAverageRating(4.3);
            e2.setDealer(dealer);

            Product e3 = new Product();
            e3.setName("Rotavator Machine");
            e3.setCategory(Category.EQUIPMENT);
            e3.setBrand("Shaktiman");
            e3.setPrice(85000.00);
            e3.setAvailableStock(2);
            e3.setImageUrls(List.of("https://5.imimg.com/data5/SELLER/Default/2021/1/EM/QJ/PP/55127022/shaktiman-rotavator-500x500.jpg"));
            e3.setDescription("High quality rotary tiller for soil preparation.");
            e3.setAverageRating(4.5);
            e3.setDealer(dealer);

            productRepository.saveAll(List.of(s1, s2, s3, f1, f2, f3, f4, p1, p2, e1, e2, e3));
            System.out.println("Demo products successfully loaded into database!");
        }
    }
}
