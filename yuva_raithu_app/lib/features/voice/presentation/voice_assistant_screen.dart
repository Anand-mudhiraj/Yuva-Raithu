import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:yuva_raithu_app/core/providers.dart';

class VoiceAssistantScreen extends ConsumerStatefulWidget {
  const VoiceAssistantScreen({super.key});

  @override
  ConsumerState<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends ConsumerState<VoiceAssistantScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final stt.SpeechToText _speech = stt.SpeechToText();
  
  bool _isListening = false;
  String _text = 'Press the mic and start speaking...';
  String _aiReply = '';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _initSpeech();
  }

  void _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
          _controller.stop();
          if (_text.isNotEmpty && _text != 'Press the mic and start speaking...') {
            _processVoiceCommand(_text);
          }
        }
      },
      onError: (errorNotification) {
        setState(() {
          _isListening = false;
          _text = 'Error: ${errorNotification.errorMsg}';
        });
        _controller.stop();
      },
    );
    if (!available) {
      setState(() {
        _text = 'Speech recognition not available on this device.';
      });
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
          _aiReply = ''; // Clear previous reply
          _text = 'Listening...';
        });
        _controller.repeat(reverse: true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      _controller.stop();
    }
  }

  Future<void> _processVoiceCommand(String text) async {
    setState(() => _isProcessing = true);
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.dio.post(
        '/ai/voice',
        data: {'text': text},
      );
      
      final data = response.data;
      setState(() {
        _aiReply = data['reply'] ?? 'Processed command.';
        _isProcessing = false;
      });

      // Handle intents after a short delay so user reads the reply
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        String intent = data['intent'];
        String category = data['category'];
        
        if (intent == 'SEARCH' && category.isNotEmpty) {
          context.push('/products?category=$category');
        } else if (intent == 'NAVIGATE' && category == 'ORDERS') {
          context.push('/orders');
        }
      });
    } catch (e) {
      setState(() {
        _aiReply = 'Sorry, I could not reach the server.';
        _isProcessing = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Yuva Raithu Voice AI',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
            ),
            const SizedBox(height: 8),
            const Text(
              'మీ వ్యవసాయ సహాయకుడు',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // Mic with Ripple Effect
            GestureDetector(
              onTap: _listen,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_isListening) ...[
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Container(
                          width: 150 + (_controller.value * 50),
                          height: 150 + (_controller.value * 50),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                            ),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Container(
                          width: 100 + (_controller.value * 30),
                          height: 100 + (_controller.value * 30),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF2E7D32).withValues(alpha: 0.2),
                            ),
                        );
                      },
                    ),
                  ],
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _isListening ? Colors.red : const Color(0xFF2E7D32),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_isListening ? Icons.stop : Icons.mic, color: Colors.white, size: 40),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            Text(_isListening ? 'Listening...' : 'Tap to Speak', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            if (_isProcessing)
              const CircularProgressIndicator(),
            
            const SizedBox(height: 40),

            // Chat Bubbles
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ListView(
                  children: [
                    if (_text.isNotEmpty && _text != 'Press the mic and start speaking...')
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text('You: "$_text"'),
                        ),
                      ),
                    if (_aiReply.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Assistant:', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                              const SizedBox(height: 4),
                              Text(_aiReply),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Hints
            const Text('You can say', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildHintChip('"Fertilizer kavali"'),
                _buildHintChip('"Pesticides chupinchandi"'),
                _buildHintChip('"Na order ekkada undi?"'),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHintChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}
