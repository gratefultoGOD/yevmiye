import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../models/application_model.dart';
import '../../models/job_post_model.dart';
import '../../state/app_state.dart';
import '../common/chat_detail_screen.dart';

class EmployerApplicantsScreen extends StatelessWidget {
  final JobPostModel? job;
  final AppState appState;

  const EmployerApplicantsScreen({super.key, this.job, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final employerId = appState.currentUser?.id ?? '';
        final applications = job != null
            ? appState.getApplicationsForJob(job!.id)
            : appState.applications.where((a) => a.employerId == employerId).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(job != null ? '${job!.title} Başvuruları' : 'Tüm Başvurular'),
          ),
          body: applications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(Icons.people_outline_rounded, size: 40, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Henüz başvuru bulunmuyor',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'İlanınıza başvuru yapıldığında adaylar burada listelenecektir.',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  itemCount: applications.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final app = applications[index];
                    final dateStr = DateFormat('dd MMM yyyy, HH:mm', 'tr_TR').format(app.appliedAt);

                    Color statusBg;
                    Color statusColor;
                    switch (app.status) {
                      case ApplicationStatus.accepted:
                        statusBg = AppColors.success.withOpacity(0.12);
                        statusColor = AppColors.success;
                        break;
                      case ApplicationStatus.rejected:
                        statusBg = AppColors.error.withOpacity(0.12);
                        statusColor = AppColors.error;
                        break;
                      case ApplicationStatus.pending:
                        statusBg = AppColors.warning.withOpacity(0.15);
                        statusColor = AppColors.warning;
                        break;
                    }

                    return Container(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: AppColors.black,
                                child: Text(
                                  app.seekerName.isNotEmpty ? app.seekerName[0].toUpperCase() : 'A',
                                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 16),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      app.seekerName,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${app.seekerAge} Yaşında • ${app.seekerExperience} Yıl Deneyim',
                                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  app.status.label,
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'İlan: ${app.jobTitle}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Başvuru Tarihi: $dateStr • Tel: ${app.seekerPhone}',
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                          if (app.note != null && app.note!.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Aday Notu: "${app.note}"',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                          const SizedBox(height: 14),
                          const Divider(height: 1, color: AppColors.border),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              // Mesajlaş Butonu
                              OutlinedButton.icon(
                                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                                label: const Text('Mesajlaş', style: TextStyle(fontSize: 12)),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.black,
                                  side: const BorderSide(color: AppColors.border),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatDetailScreen(
                                        conversationId: 'conv_${app.seekerId}',
                                        otherUserId: app.seekerId,
                                        otherUserName: app.seekerName,
                                        appState: appState,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const Spacer(),
                              if (app.status == ApplicationStatus.pending) ...[
                                TextButton(
                                  onPressed: () {
                                    appState.updateApplicationStatus(app.id, ApplicationStatus.rejected);
                                  },
                                  child: const Text('Reddet', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    appState.updateApplicationStatus(app.id, ApplicationStatus.accepted);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Aday işe kabul edildi! 🎉'),
                                        backgroundColor: AppColors.success,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.success,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: const Text('Kabul Et', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
