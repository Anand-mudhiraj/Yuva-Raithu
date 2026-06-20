package com.yuvaraithu.backend.controllers;

import com.yuvaraithu.backend.dto.VoiceRequest;
import com.yuvaraithu.backend.dto.VoiceResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/ai")
@CrossOrigin(origins = "*")
public class AiController {

    @PostMapping("/voice")
    public ResponseEntity<VoiceResponse> processVoiceCommand(@RequestBody VoiceRequest request) {
        String text = request.getText() != null ? request.getText().toLowerCase() : "";

        // Simulated AI NLP processing
        if (text.contains("seed") || text.contains("విత్తనాలు")) {
            return ResponseEntity.ok(new VoiceResponse("SEARCH", "SEEDS", "Sure! Here are some seeds available nearby."));
        } else if (text.contains("fertilizer") || text.contains("ఎరువులు")) {
            return ResponseEntity.ok(new VoiceResponse("SEARCH", "FERTILIZERS", "Here are the best fertilizers for your crop."));
        } else if (text.contains("pesticide") || text.contains("పురుగుమందులు")) {
            return ResponseEntity.ok(new VoiceResponse("SEARCH", "PESTICIDES", "Showing pesticides to protect your crops."));
        } else if (text.contains("order") || text.contains("ఆర్డర్")) {
            return ResponseEntity.ok(new VoiceResponse("NAVIGATE", "ORDERS", "Opening your order history now."));
        } else {
            return ResponseEntity.ok(new VoiceResponse("UNKNOWN", "", "I didn't quite catch that. Try asking for seeds or fertilizers."));
        }
    }
}
