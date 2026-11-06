import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../models/application_model.dart';
import '../../state/app_state.dart';
import '../common/chat_detail_screen.dart';

class SeekerApplicationsScreen extends StatelessWidget {
  final AppState appState;

  const SeekerApplicationsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final currentUserId = appState.currentUser?.id ?? '';
        final applications = appState.getApplicationsForSeeker(currentUserId);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Başvurularım'),
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
                        child: const Icon(Icons.assignment_outlined, size: 40, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Henüz bir işe başvurmadınız',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Ana sayfadaki günlük iş ilanlarını inceleyerek\nhemen başvuru yapabilirsiniz.',
                        textAlign: TextAlign.center,
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
                    IconData statusIcon;

                    switch (app.status) {
                      case ApplicationStatus.accepted:
                        statusBg = AppColors.success.withOpacity(0.12);
                        statusColor = AppColors.success;
                        statusIcon = Icons.check_circle_rounded;
                        break;
                      case ApplicationStatus.rejected:
                        statusBg = AppColors.error.withOpacity(0.12);
                        statusColor = AppColors.error;
                        statusIcon = Icons.cancel_rounded;
                        break;
                      case ApplicationStatus.pending:
                        statusBg = AppColors.warning.withOpacity(0.15);
                        statusColor = AppColors.warning;
                        statusIcon = Icons.access_time_filled_rounded;
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: statusBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(statusIcon, size: 14, color: statusColor),
                                    const SizedBox(width: 5),
                                    Text(
                                      app.status.label,
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: statusColor),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                dateStr,
                                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            app.jobTitle,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          ),
                          if (app.note != null && app.note!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Notunuz: "${app.note}"',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                          const SizedBox(height: 14),
                          const Divider(height: 1, color: AppColors.border),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: AppColors.primary),
                                label: const Text(
                                  'İşverenle Mesajlaş',
                                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatDetailScreen(
                                        conversationId: 'conv_${app.employerId}',
                                        otherUserId: app.employerId,
                                        otherUserName: 'İşveren',
                                        appState: appState,
                                      ),
                                    ),
                                  );
                                },
                              ),
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
