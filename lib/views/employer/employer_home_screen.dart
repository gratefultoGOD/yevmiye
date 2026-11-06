import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../state/app_state.dart';
import 'create_edit_job_screen.dart';
import 'employer_applicants_screen.dart';

class EmployerHomeScreen extends StatelessWidget {
  final AppState appState;

  const EmployerHomeScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final employerId = appState.currentUser?.id ?? '';
        final myJobs = appState.getJobsByEmployer(employerId);
        final allEmployerApps = appState.applications.where((a) => a.employerId == employerId).toList();
        final hiredCount = myJobs.fold<int>(0, (sum, j) => sum + j.workersHired);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.storefront_rounded, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  appState.currentUser?.businessName ?? 'İşletme Paneli',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                ),
              ],
            ),
            actions: [
              TextButton.icon(
                icon: const Icon(Icons.swap_horiz_rounded, size: 18, color: AppColors.primary),
                label: const Text(
                  'İş Arayan Modu',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13),
                ),
                onPressed: () => appState.switchRole(UserRole.jobSeeker),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // İstatistik Kartları
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: 'Aktif İlanlar',
                        value: '${myJobs.where((j) => j.isActive).length}',
                        icon: Icons.assignment_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Toplam Başvuru',
                        value: '${allEmployerApps.length}',
                        icon: Icons.people_alt_rounded,
                        color: AppColors.info,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStatCard(
                        title: 'İşe Alınanlar',
                        value: '$hiredCount',
                        icon: Icons.check_circle_rounded,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // Başlık & Yeni İlan Butonu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Yayınladığım İlanlar',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Yeni İlan', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateEditJobScreen(appState: appState),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                if (myJobs.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          const Icon(Icons.post_add_rounded, size: 48, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          const Text(
                            'Henüz bir iş ilanı yayınlamadınız',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Yukarıdaki "Yeni İlan" butonuna tıklayarak\nhemen günlük eleman arayabilirsiniz.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...myJobs.map((job) {
                    final apps = appState.getApplicationsForJob(job.id);
                    final pendingCount = apps.where((a) => a.status.name == 'pending').length;
                    final formattedDate = DateFormat('dd MMM, EEEE', 'tr_TR').format(job.workDate);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  job.categoryTitle,
                                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 11),
                                ),
                              ),
                              Text(
                                '${job.wage.toStringAsFixed(0)} ₺ / gün',
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            job.title,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tarih: $formattedDate • Saat: ${job.workHours}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                'Kontenjan: ${job.workersHired}/${job.workersNeeded} kişi',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                              ),
                              const Spacer(),
                              if (pendingCount > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.warning.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '$pendingCount yeni başvuru',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.warning),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Divider(height: 1, color: AppColors.border),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Başvuruları İncele
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EmployerApplicantsScreen(job: job, appState: appState),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text('Başvuruları Gör (${apps.length})', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.textSecondary),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CreateEditJobScreen(jobToEdit: job, appState: appState),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.error),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('İlanı Sil'),
                                          content: const Text('Bu iş ilanını silmek istediğinize emin misiniz?'),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Vazgeç')),
                                            TextButton(
                                              onPressed: () {
                                                appState.deleteJob(job.id);
                                                Navigator.pop(ctx);
                                              },
                                              child: const Text('Sil', style: TextStyle(color: AppColors.error)),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
