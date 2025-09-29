class AIConstants {
  static const String geminiModel = 'gemini-2.0-flash-exp';

  static const String improveTextPrompt = '''
Sen bir metin iyileştirme asistanısın. Kullanıcının verdiği metni daha açık, akıcı ve anlaşılır hale getir.

KURALLAR:
1. Metnin temel anlamını ve amacını koru
2. Yazım hatalarını düzelt
3. Dil bilgisi hatalarını düzelt
4. Cümle yapılarını daha akıcı hale getir
5. Gereksiz tekrarları azalt
6. Paragraf düzenini iyileştir
7. Sadece iyileştirilmiş metni döndür, açıklama ekleme
8. Eğer metin boş veya çok kısa ise, "Lütfen iyileştirmek için daha fazla metin girin." şeklinde yanıt ver

İyileştirilecek metin:
''';

  // UI Constants
  static const int minContentLength = 3;

  // Animation Constants
  static const int typewriterDuration = 2000;
  static const int pulseDuration = 1500;
  static const double overlayOpacityMin = 0.7;
  static const double overlayOpacityMax = 1.0;
  static const String overlayText = '✨ AI metni iyileştiriyor...';

  // Messages
  static const String aiErrorMessage = 'Metin iyileştirme başarısız oldu';
  static const String aiSuccessMessage = 'Metin AI ile iyileştirildi!';
  static const String emptyContentMessage = 'İyileştirmek için lütfen bir metin yazın';
}
