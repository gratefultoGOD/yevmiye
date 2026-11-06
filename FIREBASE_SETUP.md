# 🔥 Yevmiye — Firebase Kurulum ve Canlıya Alma Rehberi

Bu belge, **Yevmiye (Günlük İş & İşçi Bulma)** Flutter uygulamasının yerel test ortamından canlı Firebase backend altyapısına bağlanması için gerekli adımları içerir.

---

## 1. Firebase Projesinin Oluşturulması

1. [Firebase Console](https://console.firebase.google.com/) adresine gidin ve yeni bir proje oluşturun: `yevmiye-app`
2. FlutterFire CLI ile projenizi otomatik olarak yapılandırın:
   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   flutterfire configure --project=yevmiye-app
   ```
3. Bu işlem Android için `google-services.json` ve iOS için `GoogleService-Info.plist` dosyalarını otomatik olarak ekler.

---

## 2. Gerekli Paketlerin Eklenmesi

`pubspec.yaml` dosyasındaki dependencies kısmına aşağıdaki paketleri ekleyin:

```yaml
dependencies:
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
  firebase_storage: ^12.3.2
  firebase_messaging: ^15.1.3
```

---

## 3. Cloud Firestore Veri Tabanı Yapısı (Koleksiyonlar)

Firestore veri tabanında aşağıdaki koleksiyon hiyerarşisi kullanılır:

### 📁 `users` (Kullanıcılar)
```json
{
  "id": "user_123",
  "name": "Ahmet Yılmaz",
  "email": "ahmet@email.com",
  "phone": "05321112233",
  "role": "jobSeeker", // veya "employer"
  "city": "İstanbul",
  "district": "Kadıköy",
  "age": 24,
  "skills": ["Garsonluk", "Kasa"],
  "experienceYears": 2,
  "businessName": null,
  "isVerified": false,
  "createdAt": "2026-11-06T12:00:00Z"
}
```

### 📁 `jobs` (İş İlanları)
```json
{
  "id": "job_123",
  "employerId": "emp_123",
  "employerName": "Boğaziçi Cafe",
  "title": "Hafta Sonu Garsonu",
  "categoryId": "garson",
  "jobType": "daily",
  "workDate": "2026-11-08T09:00:00Z",
  "workHours": "12:00 - 21:00",
  "wage": 2400.0,
  "isDailyWage": true,
  "workersNeeded": 3,
  "workersHired": 1,
  "city": "İstanbul",
  "district": "Kadıköy",
  "isActive": true
}
```

### 📁 `applications` (İş Başvuruları)
```json
{
  "id": "app_123",
  "jobId": "job_123",
  "employerId": "emp_123",
  "seekerId": "seeker_123",
  "seekerName": "Ahmet Yılmaz",
  "status": "pending", // "accepted" veya "rejected"
  "appliedAt": "2026-11-06T15:30:00Z"
}
```

### 📁 `conversations` (Mesajlaşmalar)
- Subcollection: `conversations/{conversationId}/messages/{messageId}`

---

## 4. Firestore Güvenlik Kuralları (Security Rules)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Kullanıcı profilleri
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // İş İlanları
    match /jobs/{jobId} {
      allow read: if true; // Herkes ilanları görüntüleyebilir
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && resource.data.employerId == request.auth.uid;
    }
    
    // Başvurular
    match /applications/{appId} {
      allow read: if request.auth != null && (
        resource.data.seekerId == request.auth.uid || 
        resource.data.employerId == request.auth.uid
      );
      allow create: if request.auth != null;
      allow update: if request.auth != null && resource.data.employerId == request.auth.uid;
    }
    
    // Mesajlaşma
    match /conversations/{convId}/messages/{msgId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

---

## 5. FCM Bildirimleri (Firebase Cloud Messaging)

1. Bir aday başvuru yaptığında Firebase Cloud Function ile işverenin FCM token'ına:
   - **Başlık:** "Yeni İş Başvurusu! 🔔"
   - **Gövde:** "{Aday Adı}, {İlan Başlığı} ilanınıza başvurdu."
2. İşveren başvuruyu kabul ettiğinde veya reddettiğinde adayın FCM token'ına:
   - **Başlık:** "Başvurunuz Güncellendi! 🎉"
   - **Gövde:** "{İşletme Adı} başvurunuzu kabul etti."
