# Notes App

Modern ve kullanıcı dostu bir not alma uygulaması. Firebase Authentication ile güvenli kullanıcı yönetimi, AI destekli metin iyileştirme ve sonsuz sayfalama özellikleri sunar.

## İçindekiler

- [Özellikler](#özellikler)
- [Teknolojiler](#teknolojiler)
- [Mimari](#mimari)
- [Gereksinimler](#gereksinimler)
- [Kurulum](#kurulum)
- [Yapılandırma](#yapılandırma)
- [Kullanım](#kullanım)
- [Proje Yapısı](#proje-yapısı)
- [API Entegrasyonu](#api-entegrasyonu)
- [Ekran Görüntüleri](#ekran-görüntüleri)

## Özellikler

### Kimlik Doğrulama
- Firebase Authentication ile email/şifre girişi
- Güvenli kullanıcı kaydı ve giriş
- Otomatik token yönetimi
- Auth state değişikliklerini dinleme

### Not Yönetimi
- Not oluşturma, düzenleme ve silme
- Notları sabitleme (pin) özelliği
- Renkli not kategorileri
- Etiket (tag) sistemi (Work, Personal, Important, Ideas)
- Arama fonksiyonu ile hızlı not bulma
- Sonsuz sayfalama (infinite scroll) ile performans optimizasyonu

### AI Özellikleri
- Google Gemini AI entegrasyonu
- Otomatik metin iyileştirme
- Yazım hatası düzeltme
- Cümle yapısı ve akıcılık iyileştirme
- Animasyonlu AI işlem göstergesi

### UI/UX
- Dark mode arayüz
- Staggered grid layout (masonry)
- Smooth animasyonlar
- Focus state göstergeleri
- Responsive tasarım
- Real-time arama (debounced)

## Teknolojiler

### Flutter Paketleri

#### Temel Paketler
- **flutter_sdk**: ^3.9.0 - Flutter framework
- **firebase_core**: ^4.1.1 - Firebase temel SDK
- **firebase_auth**: ^6.1.0 - Firebase kimlik doğrulama

#### State Yönetimi
- **stacked**: ^3.5.0 - MVVM mimarisi için state management

#### UI Bileşenleri
- **flutter_staggered_grid_view**: ^0.7.0 - Masonry grid layout

#### Network
- **dio**: ^5.8.0+1 - HTTP client

#### Serileştirme
- **json_annotation**: ^4.9.0 - JSON serileştirme annotasyonları
- **json_serializable**: ^6.8.0 - JSON kod üreteci

#### AI Entegrasyonu
- **google_generative_ai**: ^0.4.6 - Google Gemini AI SDK
- **flutter_dotenv**: ^5.1.0 - Çevre değişkenleri yönetimi

#### Geliştirme Araçları
- **build_runner**: ^2.4.12 - Kod üretim aracı
- **flutter_lints**: ^5.0.0 - Kod kalitesi kontrolleri

## Mimari

Proje **MVVM (Model-View-ViewModel)** mimarisi kullanılarak geliştirilmiştir.

### Katmanlar

#### 1. Core Layer
- **Constants**: Layout sabitleri, tipografi sabitleri
- **Utils**: Renk dönüştürme, hex color işlemleri
- **Services**: Navigation service (global navigasyon yönetimi)

#### 2. Product Layer
- **Models**: Veri modelleri (NoteModel, PaginationInfo, SimpleResult)
- **Services**:
  - AuthService (Firebase authentication)
  - NoteService (Not CRUD işlemleri)
  - GeminiService (AI metin iyileştirme)
- **Manager**: NetworkManager (Dio ile HTTP istekleri)
- **Theme**: Tema stilleri ve renk paletleri
- **Constants**: API endpoints, query parametreleri, AI sabitleri
- **Navigation**: Route yönetimi ve navigation enums

#### 3. Feature Layer
Her özellik kendi klasöründe MVVM pattern ile yapılandırılmıştır:

- **Splash**: Uygulama başlangıç ekranı ve auth kontrolü
- **Auth**: Giriş ve kayıt ekranları
- **Home**: Not listesi, arama ve sonsuz sayfalama
- **NewNote**: Not oluşturma/düzenleme ve AI entegrasyonu
- **NoteDetail**: Not detay görüntüleme ve silme

### Design Patterns

- **Singleton Pattern**: Service sınıflarında (AuthService, NoteService, NetworkManager)
- **Factory Pattern**: Model serileştirme işlemlerinde
- **Observer Pattern**: Stacked ViewModelBuilder ile reaktif state yönetimi
- **Repository Pattern**: Service katmanında veri erişim soyutlaması

## Gereksinimler

- Flutter SDK: 3.9.0 veya üzeri
- Dart SDK: 3.9.0 veya üzeri
- iOS: 12.0+ (iOS geliştirme için)
- Android: API Level 21+ (Android 5.0+)
- Xcode: 14.0+ (iOS için)
- Android Studio / VS Code
- CocoaPods (iOS için)

### Gerekli Hesaplar
- Firebase projesi (Authentication için)
- Google AI Studio hesabı (Gemini API key için)
- Backend API sunucusu (lokal veya remote)

## Kurulum

### 1. Projeyi Klonlayın

```bash
git clone https://github.com/your-username/notes-app.git
cd notes-app
```

### 2. Flutter Paketlerini Yükleyin

```bash
flutter pub get
```

### 3. Firebase Kurulumu

#### iOS için Firebase Yapılandırması

1. [Firebase Console](https://console.firebase.google.com/) üzerinden iOS uygulaması ekleyin
2. Bundle ID: `com.notes.app`
3. `GoogleService-Info.plist` dosyasını indirin
4. Dosyayı `ios/Runner/` klasörüne yerleştirin
5. Firebase Authentication'ı etkinleştirin:
   - Firebase Console > Authentication > Sign-in method
   - Email/Password provider'ı etkinleştirin

#### Android için Firebase Yapılandırması

1. [Firebase Console](https://console.firebase.google.com/) üzerinden Android uygulaması ekleyin
2. Package name: `com.notes.app`
3. `google-services.json` dosyasını indirin
4. Dosyayı `android/app/` klasörüne yerleştirin

### 4. Gemini AI API Key Kurulumu

1. [Google AI Studio](https://makersuite.google.com/app/apikey) üzerinden API key oluşturun
2. Proje kök dizininde `.env` dosyası oluşturun:

```bash
touch .env
```

3. `.env` dosyasına API key'inizi ekleyin:

```env
GEMINI_API_KEY=your_gemini_api_key_here
```

**Önemli**: `.env` dosyası zaten `.gitignore` içinde olmalıdır. API key'leri asla commit etmeyin!

### 5. Backend API Yapılandırması

Backend API'nizin çalıştığından emin olun. Varsayılan API URL:

```dart
// lib/product/constants/product_constants.dart
static const String localApiUrl = 'http://localhost:8000';
```

API URL'ini kendi backend sunucunuza göre güncelleyin.

### 6. JSON Model Kodlarını Oluşturun

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 7. iOS Podları Yükleyin (iOS için)

```bash
cd ios
pod install
cd ..
```

## Yapılandırma

### API Endpoints

API endpoint'leri `lib/product/constants/note_endpoints.dart` içinde yapılandırılır:

```dart
class NoteEndpoints {
  static const String notes = 'notes';
  static const String notesById = 'notes/';
}
```

### Query Parametreleri

Sayfalama ve arama parametreleri `lib/product/constants/note_query_params.dart` içinde:

```dart
class NoteQueryParams {
  static const String page = 'page';
  static const String limit = 'limit';
  static const String search = 'search';
  static const int defaultLimit = 10;
}
```

### AI Prompt Yapılandırması

AI metin iyileştirme prompt'u `lib/product/constants/ai_constants.dart` içinde özelleştirilebilir:

```dart
class AIConstants {
  static const String geminiModel = 'gemini-2.0-flash-exp';
  static const String improveTextPrompt = '''
  Sen bir metin iyileştirme asistanısın...
  ''';
}
```

## Kullanım

### Uygulamayı Çalıştırma

#### iOS Simulator
```bash
flutter run -d "iPhone 15 Pro"
```

#### Android Emulator
```bash
flutter run -d emulator-5554
```

#### Fiziksel Cihaz
```bash
flutter devices  # Cihazları listele
flutter run -d <device-id>
```

### Debug Build
```bash
flutter run --debug
```

### Release Build

#### iOS
```bash
flutter build ios --release
```

#### Android
```bash
flutter build apk --release  # APK için
flutter build appbundle --release  # App Bundle için
```

### Test Kullanıcısı Oluşturma

1. Uygulamayı başlatın
2. "Create Account" butonuna tıklayın
3. Email ve şifre girin
4. Firebase Console'da kullanıcı oluşturulduğunu doğrulayın

## Proje Yapısı

```
lib/
├── main.dart                          # Uygulama giriş noktası
├── core/                              # Temel katman
│   ├── constants/
│   │   └── layout_constants.dart      # UI sabitleri
│   ├── services/
│   │   └── navigation_service.dart    # Global navigasyon
│   └── utils/
│       ├── color_utils.dart           # Renk yardımcıları
│       └── hex_color.dart             # Hex renk dönüştürücü
├── product/                           # Ürün katmanı
│   ├── init/
│   │   └── application_init.dart      # App başlatma
│   ├── constants/
│   │   ├── ai_constants.dart          # AI sabitleri
│   │   ├── note_endpoints.dart        # API endpoints
│   │   ├── note_query_params.dart     # Query parametreleri
│   │   ├── product_constants.dart     # Genel sabitler
│   │   └── typography_constants.dart  # Font stilleri
│   ├── models/
│   │   ├── note_model.dart            # Not veri modeli
│   │   ├── pagination_info.dart       # Sayfalama modeli
│   │   └── simple_result.dart         # API response wrapper
│   ├── services/
│   │   ├── auth_service.dart          # Firebase auth
│   │   ├── note_service.dart          # Not işlemleri
│   │   └── gemini_service.dart        # AI servisi
│   ├── manager/
│   │   └── network_manager.dart       # HTTP client
│   ├── theme/
│   │   ├── theme_styles.dart          # Tema tanımları
│   │   └── app_colors.dart            # Renk paleti
│   ├── navigate/
│   │   ├── navigation_enums.dart      # Route enums
│   │   └── navigation_route.dart      # Route yapılandırması
│   └── widgets/
│       └── custom_text_field.dart     # Özel widget'lar
└── feature/                           # Özellik katmanı
    ├── splash/
    │   ├── splash_view.dart           # Splash UI
    │   └── splash_view_model.dart     # Splash logic
    ├── auth/
    │   ├── auth_view.dart             # Auth UI
    │   └── auth_view_model.dart       # Auth logic
    ├── home/
    │   ├── home_view.dart             # Home UI
    │   └── home_view_model.dart       # Home logic + pagination
    ├── new_note/
    │   ├── new_note_view.dart         # Note editor UI
    │   ├── new_note_view_model.dart   # Note editor logic
    │   └── sub_view/
    │       ├── new_note_view_widgets.dart           # Note editor widgets
    │       ├── ai_processing_overlay_view.dart      # AI overlay UI
    │       └── ai_processing_overlay_view_model.dart # AI overlay logic
    └── note_detail/
        ├── note_detail_view.dart      # Detail UI
        └── note_detail_view_model.dart # Detail logic
```

## API Entegrasyonu

### Authentication API

#### Login
```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

#### Register
```http
POST /api/v1/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

### Notes API

#### Get Notes (Paginated)
```http
GET /api/v1/notes?page=1&limit=10&search=query
Authorization: Bearer <firebase-token>
```

**Response:**
```json
{
  "status": true,
  "data": {
    "notes": [...],
    "page": 1,
    "page_size": 10,
    "total": 50
  }
}
```

#### Create Note
```http
POST /api/v1/notes
Authorization: Bearer <firebase-token>
Content-Type: application/json

{
  "title": "My Note",
  "content": "Note content",
  "color": "#FFF2CC",
  "tags": ["Work"],
  "is_pinned": false
}
```

#### Update Note
```http
PUT /api/v1/notes/{note_id}
Authorization: Bearer <firebase-token>
Content-Type: application/json

{
  "title": "Updated Note",
  "content": "Updated content"
}
```

#### Delete Note
```http
DELETE /api/v1/notes/{note_id}
Authorization: Bearer <firebase-token>
```

### API Response Format

Tüm API yanıtları `SimpleResult` wrapper'ı ile sarmalanır:

```dart
class SimpleResult<T> {
  final bool status;
  final String? message;
  final T? data;
  final PaginationInfo? pagination;
}
```

## Özellik Detayları

### Sonsuz Sayfalama (Infinite Scroll)

Home view'da scroll pozisyonu dinlenir ve kullanıcı sayfa sonuna yaklaştığında otomatik yeni notlar yüklenir:

```dart
scrollController.addListener(() {
  if (!_hasMore || _isLoadingMore || _isLoading) return;
  final pos = scrollController.position;
  if (pos.pixels >= pos.maxScrollExtent - 300) {
    loadMoreNotes();
  }
});
```

### AI Metin İyileştirme

Gemini AI kullanarak notların içeriğini otomatik iyileştirir:

1. Minimum 3 karakter kontrolü
2. AI isteği gönderme
3. Animasyonlu yükleme göstergesi
4. Sonucu otomatik TextEditingController'a yazma

```dart
final result = await _geminiService.improveText(currentContent);
if (result.status && result.data != null) {
  contentController.text = result.data!;
}
```

### Arama (Debounced Search)

500ms debounce ile gereksiz API isteklerini önler:

```dart
_searchDebounceTimer?.cancel();
_searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
  loadNotes(reset: true);
});
```

### State Management

Stacked paketinin `ViewModelBuilder` kullanılarak reaktif state yönetimi:

```dart
ViewModelBuilder<HomeViewModel>.reactive(
  viewModelBuilder: () => HomeViewModel(),
  onViewModelReady: (viewModel) => viewModel.loadNotes(reset: true),
  builder: (context, viewModel, child) {
    // UI renders automatically when notifyListeners() is called
  },
)
```

## Ekran Görüntüleri

### Ana Ekranlar
- **Splash Screen**: Firebase auth kontrolü ve yönlendirme
- **Auth Screen**: Email/şifre ile giriş ve kayıt
- **Home Screen**: Not listesi, arama ve sonsuz scroll
- **New Note Screen**: Not oluşturma, renk/etiket seçimi, AI iyileştirme
- **Note Detail Screen**: Not detayları ve silme işlemi

### UI Özellikleri
- **Masonry Grid Layout**: Farklı yüksekliklerde notlar için optimize edilmiş
- **Focus States**: Input alanlarına tıklandığında turuncu border animasyonu
- **AI Overlay**: Gradient animasyon ve typewriter efekti
- **Color Picker**: 6 farklı not rengi seçeneği
- **Tag System**: 4 kategori (Work, Personal, Important, Ideas)

## Sorun Giderme

### Firebase Bağlantı Hatası
```
Ensure Firebase is initialized in ApplicationInit.firstlyInit()
Check google-services.json and GoogleService-Info.plist
```

### Gemini API Hatası
```
Check .env file exists and GEMINI_API_KEY is set
Verify API key is valid in Google AI Studio
```

### Build Runner Hatası
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### iOS Pod Hatası
```bash
cd ios
pod deintegrate
pod install
cd ..
```

### Android Manifest Hatası
Ensure `android/app/src/main/AndroidManifest.xml` has internet permission:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

## Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'feat: add amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın

### Commit Mesajı Formatı
```
feat: yeni özellik
fix: hata düzeltme
docs: dokümantasyon
style: kod formatı
refactor: kod yeniden yapılandırma
test: test ekleme
chore: diğer değişiklikler
```

## Lisans

Bu proje özel kullanım içindir.

## İletişim

Proje Sahibi - [GitHub](https://github.com/your-username)

Proje Linki: [https://github.com/your-username/notes-app](https://github.com/your-username/notes-app)

---

**Not**: Bu proje eğitim ve geliştirme amaçlı oluşturulmuştur. Production kullanımı için ek güvenlik önlemleri ve test coverage gereklidir.