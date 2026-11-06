import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/job_categories.dart';
import '../../models/job_post_model.dart';
import '../../models/user_model.dart';
import '../../state/app_state.dart';
import '../widgets/category_chip.dart';
import '../widgets/job_card.dart';
import '../common/job_detail_screen.dart';

class SeekerHomeScreen extends StatelessWidget {
  final AppState appState;

  const SeekerHomeScreen({super.key, required this.appState});

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        String tempCity = appState.selectedCity;
        String? tempDistrict = appState.selectedDistrict;
        JobType? tempType = appState.selectedJobType;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final districts = AppCategories.cityDistricts[tempCity] ?? ['Tümü'];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Konum ve İş Filtreleri',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      TextButton(
                        onPressed: () {
                          appState.resetFilters();
                          Navigator.pop(ctx);
                        },
                        child: const Text('Sıfırla', style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Şehir Seçimi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: tempCity,
                    decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                    items: AppCategories.popularCities
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() {
                          tempCity = val;
                          tempDistrict = 'Tümü';
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  if (tempCity != 'Tüm Türkiye') ...[
                    const Text('İlçe Seçimi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: districts.contains(tempDistrict) ? tempDistrict : 'Tümü',
                      decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                      items: districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                      onChanged: (val) {
                        if (val != null) setModalState(() => tempDistrict = val);
                      },
                    ),
                    const SizedBox(height: 14),
                  ],
                  const Text('Çalışma Süresi Türü', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildTypeFilterChip('Tümü', null, tempType, (t) => setModalState(() => tempType = t)),
                      const SizedBox(width: 8),
                      _buildTypeFilterChip('Günlük', JobType.daily, tempType, (t) => setModalState(() => tempType = t)),
                      const SizedBox(width: 8),
                      _buildTypeFilterChip('Haftalık', JobType.weekly, tempType, (t) => setModalState(() => tempType = t)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        appState.setLocation(city: tempCity, district: tempDistrict);
                        appState.setJobType(tempType);
                        Navigator.pop(ctx);
                      },
                      child: const Text('Filtreleri Uygula', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTypeFilterChip(
    String label,
    JobType? type,
    JobType? selectedType,
    Function(JobType?) onSelect,
  ) {
    final isSelected = type == selectedType;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.black,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      ),
      onSelected: (_) => onSelect(type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final jobs = appState.filteredJobs;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.handshake_rounded, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Yevmiye',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: -0.5),
                ),
              ],
            ),
            actions: [
              // Rol Değiştirici Butonu
              TextButton.icon(
                icon: const Icon(Icons.swap_horiz_rounded, size: 18, color: AppColors.primary),
                label: const Text(
                  'İşveren Modu',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13),
                ),
                onPressed: () {
                  appState.switchRole(UserRole.employer);
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Column(
            children: [
              // Üst Arama & Konum Barı
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Arama Girişi
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: TextField(
                              onChanged: appState.setSearchQuery,
                              decoration: const InputDecoration(
                                hintText: 'İş başlığı veya işletme ara...',
                                prefixIcon: Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Filtreleme Butonu
                        InkWell(
                          onTap: () => _showFilterModal(context),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: (appState.selectedCity != 'Tüm Türkiye' || appState.selectedJobType != null)
                                  ? AppColors.primary
                                  : AppColors.black,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Konum Göstergesi
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 15, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          appState.selectedCity == 'Tüm Türkiye'
                              ? 'Tüm Türkiye geneli işler'
                              : '${appState.selectedCity}${appState.selectedDistrict != null && appState.selectedDistrict != 'Tümü' ? ' / ${appState.selectedDistrict}' : ''}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                        ),
                        const Spacer(),
                        Text(
                          '${jobs.length} İlan',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Kategori Çipleri (Yatay Liste)
              Container(
                height: 56,
                color: Colors.white,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: AppCategories.categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = AppCategories.categories[index];
                    return CategoryChip(
                      title: cat.title,
                      icon: cat.icon,
                      isSelected: appState.selectedCategory == cat.id,
                      onTap: () => appState.setSelectedCategory(cat.id),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // İlan Listesi
              Expanded(
                child: jobs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textMuted),
                            const SizedBox(height: 12),
                            const Text(
                              'Aramanıza uygun ilan bulunamadı',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Filtreleri sıfırlayarak daha fazla ilana ulaşabilirsiniz.',
                              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: appState.resetFilters,
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.black),
                              child: const Text('Filtreleri Sıfırla'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        itemCount: jobs.length,
                        itemBuilder: (context, index) {
                          final job = jobs[index];
                          return JobCard(
                            job: job,
                            isFavorite: appState.isFavorite(job.id),
                            hasApplied: appState.hasApplied(job.id),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JobDetailScreen(job: job, appState: appState),
                                ),
                              );
                            },
                            onApply: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JobDetailScreen(job: job, appState: appState),
                                ),
                              );
                            },
                            onToggleFavorite: () => appState.toggleFavorite(job.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
