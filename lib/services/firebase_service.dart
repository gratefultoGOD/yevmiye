/// ============================================================================
/// FIREBASE ENTEGRASYON VE BULUT SERVİS MİMARİSİ
/// ============================================================================
///
/// Bu dosya, Yevmiye uygulamasının Firebase altyapısı (Auth, Cloud Firestore,
/// Storage ve FCM Bildirimleri) için servis soyutlamasını tanımlar.
///
/// Canlıya alırken:
/// 1. `flutterfire configure` komutunu çalıştırın.
/// 2. `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`,
///    `firebase_messaging` paketlerini pubspec.yaml'a ekleyin.
/// 3. Aşağıdaki metodları ilgili Firebase SDK çağrılarına bağlayın.
///
/// Mevcut durumda uygulama yerel reaktif State katmanı (AppState) ve
/// mock veriler ile hiçbir Firebase istisnası fırlatmadan %100 işlevsel
/// olarak çalışmaktadır.
/// ============================================================================

import '../models/user_model.dart';
import '../models/job_post_model.dart';
import '../models/application_model.dart';
import '../models/message_model.dart';

abstract class IFirebaseService {
  // 1. Firebase Authentication
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signInWithPhone(String phone, String smsCode);
  Future<UserModel> registerUser(UserModel user, String password);
  Future<void> signOut();

  // 2. Cloud Firestore (İş İlanları & Koleksiyonlar)
  Stream<List<JobPostModel>> getActiveJobsStream();
  Future<void> createJobPost(JobPostModel job);
  Future<void> updateJobPost(JobPostModel job);
  Future<void> deleteJobPost(String jobId);

  // 3. Cloud Firestore (Başvurular)
  Stream<List<ApplicationModel>> getApplicationsForSeeker(String seekerId);
  Stream<List<ApplicationModel>> getApplicationsForJob(String jobId);
  Future<void> submitApplication(ApplicationModel application);
  Future<void> updateApplicationStatus(String applicationId, ApplicationStatus status);

  // 4. Cloud Firestore (Gerçek Zamanlı Mesajlaşma)
  Stream<List<ChatMessageModel>> getMessagesStream(String conversationId);
  Future<void> sendMessage(ChatMessageModel message);

  // 5. Firebase Storage (Profil Fotoğrafı ve Belgeler)
  Future<String> uploadProfileImage(String userId, List<int> imageBytes);

  // 6. Firebase Cloud Messaging (FCM Bildirimleri)
  Future<void> setupFCMToken(String userId);
  Future<void> sendPushNotification({
    required String targetFCMToken,
    required String title,
    required String body,
  });
}
