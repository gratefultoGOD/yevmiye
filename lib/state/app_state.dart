import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/job_post_model.dart';
import '../models/application_model.dart';
import '../models/message_model.dart';
import '../models/pricing_config_model.dart';
import '../services/mock_data.dart';

class AppState extends ChangeNotifier {
  // Aktif Giriş Yapan Kullanıcı
  UserModel? _currentUser;
  bool _isAuthenticated = true; // Hızlı geliştirme ve test için varsayılan açık

  // İş İlanları
  List<JobPostModel> _jobs = [];
  final Set<String> _favoriteJobIds = {'job_1', 'job_4'};

  // Filtreler
  String _searchQuery = '';
  String _selectedCategory = 'all';
  String _selectedCity = 'Tüm Türkiye';
  String? _selectedDistrict;
  JobType? _selectedJobType;

  // Başvurular
  List<ApplicationModel> _applications = [];

  // Mesajlaşma
  List<ChatMessageModel> _messages = [];

  // Güvenlik & Raporlama
  List<ReportModel> _reports = [];

  // Ücretlendirme Yapısı (Varsayılan kapalı - Bölüm 9)
  PricingConfigModel _pricingConfig = const PricingConfigModel();

  AppState() {
    _initData();
  }

  void _initData() {
    _currentUser = MockData.demoSeeker;
    _jobs = List.from(MockData.initialJobs);
    _applications = List.from(MockData.initialApplications);
    _messages = List.from(MockData.initialMessages);
  }

  // --- GETTERS ---
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isEmployer => _currentUser?.isEmployer ?? false;
  bool get isJobSeeker => _currentUser?.isJobSeeker ?? true;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  List<JobPostModel> get jobs => _jobs;
  Set<String> get favoriteJobIds => _favoriteJobIds;
  List<ApplicationModel> get applications => _applications;
  List<ChatMessageModel> get messages => _messages;
  List<ReportModel> get reports => _reports;
  PricingConfigModel get pricingConfig => _pricingConfig;

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedCity => _selectedCity;
  String? get selectedDistrict => _selectedDistrict;
  JobType? get selectedJobType => _selectedJobType;

  // Filtrelenmiş İlan Listesi
  List<JobPostModel> get filteredJobs {
    return _jobs.where((job) {
      if (!job.isActive) return false;

      // Arama filtresi
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = job.title.toLowerCase().contains(q);
        final matchesDesc = job.description.toLowerCase().contains(q);
        final matchesEmployer = job.employerName.toLowerCase().contains(q);
        if (!matchesTitle && !matchesDesc && !matchesEmployer) return false;
      }

      // Kategori filtresi
      if (_selectedCategory != 'all' && job.categoryId != _selectedCategory) {
        return false;
      }

      // Şehir filtresi
      if (_selectedCity != 'Tüm Türkiye' && job.city != _selectedCity) {
        return false;
      }

      // İlçe filtresi
      if (_selectedDistrict != null && _selectedDistrict != 'Tümü' && job.district != _selectedDistrict) {
        return false;
      }

      // İş Türü filtresi
      if (_selectedJobType != null && job.jobType != _selectedJobType) {
        return false;
      }

      return true;
    }).toList();
  }

  List<JobPostModel> get favoriteJobs {
    return _jobs.where((j) => _favoriteJobIds.contains(j.id)).toList();
  }

  // --- KULLANICI & GİRİŞ İŞLEMLERİ ---
  void loginWithEmail(String email, String password, UserRole role) {
    if (role == UserRole.employer) {
      _currentUser = MockData.demoEmployer;
    } else {
      _currentUser = MockData.demoSeeker;
    }
    _isAuthenticated = true;
    notifyListeners();
  }

  void register(UserModel user) {
    _currentUser = user;
    _isAuthenticated = true;
    notifyListeners();
  }

  void switchRole(UserRole newRole) {
    if (_currentUser == null) return;
    if (newRole == UserRole.employer) {
      _currentUser = MockData.demoEmployer;
    } else {
      _currentUser = MockData.demoSeeker;
    }
    notifyListeners();
  }

  void updateProfile(UserModel updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }

  // --- FİLTRE DEĞİŞTİRME ---
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String categoryId) {
    _selectedCategory = categoryId;
    notifyListeners();
  }

  void setLocation({required String city, String? district}) {
    _selectedCity = city;
    _selectedDistrict = district;
    notifyListeners();
  }

  void setJobType(JobType? jobType) {
    _selectedJobType = jobType;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategory = 'all';
    _selectedCity = 'Tüm Türkiye';
    _selectedDistrict = null;
    _selectedJobType = null;
    notifyListeners();
  }

  // --- FAVORİ İŞLEMLERİ ---
  void toggleFavorite(String jobId) {
    if (_favoriteJobIds.contains(jobId)) {
      _favoriteJobIds.remove(jobId);
    } else {
      _favoriteJobIds.add(jobId);
    }
    notifyListeners();
  }

  bool isFavorite(String jobId) => _favoriteJobIds.contains(jobId);

  // --- İLAN İŞLEMLERİ (İŞVEREN) ---
  void createJob(JobPostModel job) {
    _jobs.insert(0, job);
    notifyListeners();
  }

  void updateJob(JobPostModel updatedJob) {
    final idx = _jobs.indexWhere((j) => j.id == updatedJob.id);
    if (idx != -1) {
      _jobs[idx] = updatedJob;
      notifyListeners();
    }
  }

  void deleteJob(String jobId) {
    _jobs.removeWhere((j) => j.id == jobId);
    _applications.removeWhere((a) => a.jobId == jobId);
    notifyListeners();
  }

  List<JobPostModel> getJobsByEmployer(String employerId) {
    return _jobs.where((j) => j.employerId == employerId).toList();
  }

  // --- BAŞVURU İŞLEMLERİ ---
  bool hasApplied(String jobId) {
    if (_currentUser == null) return false;
    return _applications.any((a) => a.jobId == jobId && a.seekerId == _currentUser!.id);
  }

  void applyToJob(String jobId, {String? note}) {
    if (_currentUser == null) return;
    if (hasApplied(jobId)) return;

    final job = _jobs.firstWhere((j) => j.id == jobId);

    final newApp = ApplicationModel(
      id: 'app_${DateTime.now().millisecondsSinceEpoch}',
      jobId: job.id,
      jobTitle: job.title,
      employerId: job.employerId,
      seekerId: _currentUser!.id,
      seekerName: _currentUser!.name,
      seekerPhone: _currentUser!.phone,
      seekerAge: _currentUser!.age ?? 22,
      seekerExperience: _currentUser!.experienceYears,
      note: note,
      status: ApplicationStatus.pending,
      appliedAt: DateTime.now(),
    );

    _applications.insert(0, newApp);
    notifyListeners();
  }

  List<ApplicationModel> getApplicationsForSeeker(String seekerId) {
    return _applications.where((a) => a.seekerId == seekerId).toList();
  }

  List<ApplicationModel> getApplicationsForJob(String jobId) {
    return _applications.where((a) => a.jobId == jobId).toList();
  }

  void updateApplicationStatus(String applicationId, ApplicationStatus newStatus) {
    final idx = _applications.indexWhere((a) => a.id == applicationId);
    if (idx != -1) {
      final app = _applications[idx];
      _applications[idx] = app.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );

      // Eğer kabul edildiyse ilgili ilanın işe alınan sayısını artır
      if (newStatus == ApplicationStatus.accepted) {
        final jobIdx = _jobs.indexWhere((j) => j.id == app.jobId);
        if (jobIdx != -1) {
          final currentJob = _jobs[jobIdx];
          _jobs[jobIdx] = currentJob.copyWith(
            workersHired: currentJob.workersHired + 1,
          );
        }
      }

      notifyListeners();
    }
  }

  // --- MESAJLAŞMA İŞLEMLERİ ---
  List<ChatMessageModel> getMessagesForConversation(String conversationId) {
    return _messages.where((m) => m.conversationId == conversationId).toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  void sendMessage({
    required String conversationId,
    required String receiverId,
    required String text,
  }) {
    if (_currentUser == null || text.trim().isEmpty) return;

    final newMsg = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: _currentUser!.id,
      senderName: _currentUser!.name,
      receiverId: receiverId,
      text: text.trim(),
      timestamp: DateTime.now(),
      isRead: false,
    );

    _messages.add(newMsg);
    notifyListeners();
  }

  List<ConversationSummaryModel> getConversationsForCurrentUser() {
    if (_currentUser == null) return [];

    final userConversations = <String, ChatMessageModel>{};
    for (var m in _messages) {
      if (m.senderId == _currentUser!.id || m.receiverId == _currentUser!.id) {
        final existing = userConversations[m.conversationId];
        if (existing == null || m.timestamp.isAfter(existing.timestamp)) {
          userConversations[m.conversationId] = m;
        }
      }
    }

    return userConversations.entries.map((entry) {
      final lastMsg = entry.value;
      final otherUserId = lastMsg.senderId == _currentUser!.id ? lastMsg.receiverId : lastMsg.senderId;
      final otherUserName = lastMsg.senderId == _currentUser!.id ? 'İşletme / Aday' : lastMsg.senderName;

      return ConversationSummaryModel(
        id: entry.key,
        otherUserId: otherUserId,
        otherUserName: otherUserName,
        lastMessage: lastMsg.text,
        lastMessageTime: lastMsg.timestamp,
        unreadCount: (!lastMsg.isRead && lastMsg.receiverId == _currentUser!.id) ? 1 : 0,
      );
    }).toList();
  }

  // --- GÜVENLİK & ŞİKAYET ETME ---
  void submitReport({
    required String targetType,
    required String targetId,
    required String targetTitle,
    required String reason,
  }) {
    if (_currentUser == null) return;
    _reports.insert(
      0,
      ReportModel(
        id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
        reporterId: _currentUser!.id,
        targetType: targetType,
        targetId: targetId,
        targetTitle: targetTitle,
        reason: reason,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  // --- YÖNETİCİ & ÜCRETLENDİRME AYARLARI ---
  void updatePricingConfig(PricingConfigModel config) {
    _pricingConfig = config;
    notifyListeners();
  }

  void toggleEmployerVerification(String employerId) {
    for (int i = 0; i < _jobs.length; i++) {
      if (_jobs[i].employerId == employerId) {
        _jobs[i] = _jobs[i].copyWith(); // Yenile
      }
    }
    notifyListeners();
  }
}
