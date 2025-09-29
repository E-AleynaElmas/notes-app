import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:notes_app/product/constants/ai_constants.dart';
import 'package:notes_app/product/models/simple_result.dart';

abstract class IGeminiService {
  Future<SimpleResult<String>> improveText(String text);
}

class GeminiService implements IGeminiService {
  GeminiService._init();
  static final GeminiService _instance = GeminiService._init();
  static GeminiService get instance => _instance;

  GenerativeModel? _model;

  Future<void> initialize() async {
    try {
      await dotenv.load();
      final apiKey = dotenv.env['GEMINI_API_KEY'];

      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('GEMINI_API_KEY bulunamadı veya geçersiz. Lütfen .env dosyasını kontrol edin.');
      }

      _model = GenerativeModel(
        model: AIConstants.geminiModel,
        apiKey: apiKey,
        generationConfig: GenerationConfig(temperature: 0.7, topK: 40, topP: 0.95, maxOutputTokens: 1000),
      );
    } catch (e) {
      debugPrint('Gemini servis başlatma hatası: $e');
      rethrow;
    }
  }

  @override
  Future<SimpleResult<String>> improveText(String text) async {
    try {
      if (_model == null) {
        await initialize();
      }

      if (text.trim().isEmpty) {
        return SimpleResult<String>(status: false, message: AIConstants.emptyContentMessage);
      }

      final prompt = '${AIConstants.improveTextPrompt}$text';
      final response = await _model!.generateContent([Content.text(prompt)]);

      if (response.text?.isNotEmpty == true) {
        return SimpleResult<String>(status: true, data: response.text!.trim(), message: AIConstants.aiSuccessMessage);
      } else {
        return SimpleResult<String>(status: false, message: 'AI\'dan boş yanıt alındı');
      }
    } catch (e) {
      debugPrint('Gemini metin iyileştirme hatası: $e');
      return SimpleResult<String>(status: false, message: '${AIConstants.aiErrorMessage}: ${e.toString()}');
    }
  }

  bool get isInitialized => _model != null;
}
