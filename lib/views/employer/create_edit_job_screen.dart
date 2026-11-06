import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/job_categories.dart';
import '../../models/job_post_model.dart';
import '../../state/app_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class CreateEditJobScreen extends StatefulWidget {
  final JobPostModel? jobToEdit;
  final AppState appState;

  const CreateEditJobScreen({super.key, this.jobToEdit, required this.appState});

  @override
  State<CreateEditJobScreen> createState() => _CreateEditJobScreenState();
}

class _CreateEditJobScreenState extends State<CreateEditJobScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _hoursController;
  late TextEditingController _wageController;
  late TextEditingController _workersNeededController;
  late TextEditingController _addressController;

  late String _selectedCategory;
  late JobType _selectedJobType;
  late DateTime _selectedDate;
  late String _selectedCity;
  late String _selectedDistrict;
  late bool _isDailyWage;
  late List<String> _selectedPerks;

  final List<String> _availablePerks = [
    'Öğle Yemeği',
    'Akşam Yemeği',
    'Yol Desteği / Servis',
    'Gün Sonu Nakit',
    'Bahşiş Payı',
    'Kıyafet/Üniforma',
  ];

  @override
  void initState() {
    super.initState();
    final j = widget.jobToEdit;

    _titleController = TextEditingController(text: j?.title ?? '');
    _descController = TextEditingController(text: j?.description ?? '');
    _hoursController = TextEditingController(text: j?.workHours ?? '11:00 - 20:00');
    _wageController = TextEditingController(text: j != null ? j.wage.toStringAsFixed(0) : '2200');
    _workersNeededController = TextEditingController(text: j != null ? j.workersNeeded.toString() : '2');
    _addressController = TextEditingController(text: j?.addressDetails ?? '');

    _selectedCategory = j?.categoryId ?? 'garson';
    _selectedJobType = j?.jobType ?? JobType.daily;
    _selectedDate = j?.workDate ?? DateTime.now().add(const Duration(days: 1));
    _selectedCity = j?.city ?? 'İstanbul';
    _selectedDistrict = j?.district ?? 'Kadıköy';
    _isDailyWage = j?.isDailyWage ?? true;
    _selectedPerks = List.from(j?.perks ?? ['Öğle Yemeği', 'Gün Sonu Nakit']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _hoursController.dispose();
    _wageController.dispose();
    _workersNeededController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveJob() {
    if (_formKey.currentState?.validate() ?? false) {
      final user = widget.appState.currentUser;
      final categoryItem = AppCategories.categories.firstWhere(
        (c) => c.id == _selectedCategory,
        orElse: () => AppCategories.categories[1],
      );

      final job = JobPostModel(
        id: widget.jobToEdit?.id ?? 'job_${DateTime.now().millisecondsSinceEpoch}',
        employerId: user?.id ?? 'employer_1',
        employerName: user?.businessName ?? user?.name ?? 'İşletme',
        employerPhone: user?.phone ?? '',
        isEmployerVerified: user?.isVerified ?? false,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        categoryId: _selectedCategory,
        categoryTitle: categoryItem.title,
        jobType: _selectedJobType,
        workDate: _selectedDate,
        workHours: _hoursController.text.trim(),
        wage: double.tryParse(_wageController.text) ?? 2000.0,
        isDailyWage: _isDailyWage,
        workersNeeded: int.tryParse(_workersNeededController.text) ?? 1,
        workersHired: widget.jobToEdit?.workersHired ?? 0,
        city: _selectedCity,
        district: _selectedDistrict,
        addressDetails: _addressController.text.trim(),
        perks: _selectedPerks,
        createdAt: widget.jobToEdit?.createdAt ?? DateTime.now(),
      );

      if (widget.jobToEdit != null) {
        widget.appState.updateJob(job);
      } else {
        widget.appState.createJob(job);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.jobToEdit != null ? 'İlan başarıyla güncellendi!' : 'İlanınız yayına alındı! 🎉'),
          backgroundColor: AppColors.black,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.jobToEdit != null;
    final districts = AppCategories.cityDistricts[_selectedCity] ?? ['Merkez', 'Diğer'];
    final dateStr = DateFormat('dd MMMM yyyy, EEEE', 'tr_TR').format(_selectedDate);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEditing ? 'İlanı Düzenle' : 'Yeni İlan Oluştur'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık
              CustomTextField(
                label: 'İş Başlığı',
                hint: 'Örn: Hafta Sonu Salon Garsonu (Nakit Yevmiye)',
                controller: _titleController,
                validator: (v) => (v == null || v.isEmpty) ? 'Başlık zorunludur.' : null,
              ),

              const SizedBox(height: 16),

              // Kategori Seçimi
              const Text('İş Kategorisi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    items: AppCategories.categories
                        .where((c) => c.id != 'all')
                        .map((c) => DropdownMenuItem(value: c.id, child: Text(c.title)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Çalışma Tarihi
              const Text('Çalışma Tarihi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Text(dateStr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      const Icon(Icons.edit_calendar_rounded, size: 18, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Saatler ve Kontenjan
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Çalışma Saatleri',
                      hint: '10:00 - 19:00',
                      controller: _hoursController,
                      prefixIcon: Icons.access_time_rounded,
                      validator: (v) => (v == null || v.isEmpty) ? 'Saat aralığı girin.' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: 'Aranan Kişi',
                      hint: '2',
                      controller: _workersNeededController,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.people_outline_rounded,
                      validator: (v) => (v == null || v.isEmpty) ? 'Sayı girin.' : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Ücret Bilgisi
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Ücret Tutarı (₺)',
                      hint: '2000',
                      controller: _wageController,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.payments_outlined,
                      validator: (v) => (v == null || v.isEmpty) ? 'Ücret tutarı girin.' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Row(
                      children: [
                        ChoiceChip(
                          label: const Text('Günlük'),
                          selected: _isDailyWage,
                          selectedColor: AppColors.black,
                          labelStyle: TextStyle(
                            color: _isDailyWage ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                          onSelected: (_) => setState(() => _isDailyWage = true),
                        ),
                        const SizedBox(width: 6),
                        ChoiceChip(
                          label: const Text('Toplam'),
                          selected: !_isDailyWage,
                          selectedColor: AppColors.black,
                          labelStyle: TextStyle(
                            color: !_isDailyWage ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                          onSelected: (_) => setState(() => _isDailyWage = false),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Konum: Şehir & İlçe
              const Text('İş Konumu (Şehir & İlçe)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCity,
                          isExpanded: true,
                          items: AppCategories.popularCities
                              .where((c) => c != 'Tüm Türkiye')
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedCity = val;
                                _selectedDistrict =
                                    AppCategories.cityDistricts[val]?.firstWhere((d) => d != 'Tümü') ?? 'Merkez';
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: districts.contains(_selectedDistrict) ? _selectedDistrict : districts.first,
                          isExpanded: true,
                          items: districts
                              .where((d) => d != 'Tümü')
                              .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedDistrict = val);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: 'Açık Adres / Yol Tarifi',
                hint: 'Örn: Moda Cad. No: 42 (Kadıköy Boğa heykeli yakını)',
                controller: _addressController,
                prefixIcon: Icons.location_on_outlined,
                validator: (v) => (v == null || v.isEmpty) ? 'Adres bilgisi girin.' : null,
              ),

              const SizedBox(height: 16),

              // İmkanlar (Perks)
              const Text('Sağlanan İmkanlar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availablePerks.map((perk) {
                  final isSelected = _selectedPerks.contains(perk);
                  return FilterChip(
                    label: Text(perk),
                    selected: isSelected,
                    selectedColor: AppColors.primary.withOpacity(0.15),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12,
                    ),
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _selectedPerks.add(perk);
                        } else {
                          _selectedPerks.remove(perk);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Açıklama
              CustomTextField(
                label: 'İş Açıklaması ve Şartlar',
                hint: 'İşin detayları, yapılacak görevler ve beklenilen özellikler...',
                controller: _descController,
                maxLines: 4,
                validator: (v) => (v == null || v.isEmpty) ? 'Açıklama zorunludur.' : null,
              ),

              const SizedBox(height: 28),

              CustomButton(
                text: isEditing ? 'Değişiklikleri Kaydet' : 'İlanı Hemen Yayınla',
                backgroundColor: AppColors.primary,
                icon: Icons.check_circle_rounded,
                onPressed: _saveJob,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
