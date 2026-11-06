import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../models/job_post_model.dart';
import '../../state/app_state.dart';
import '../widgets/custom_button.dart';
import 'chat_detail_screen.dart';
import 'legal_disclaimer_sheet.dart';
import 'report_job_dialog.dart';

class JobDetailScreen extends StatefulWidget {
  final JobPostModel job;
  final AppState appState;

  const JobDetailScreen({
    super.key,
    required this.job,
    required this.appState,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _showApplyDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'İlana Başvur',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              Text(
                '${widget.job.employerName} işletmesine başvurunuz profil bilgilerinizle iletilecektir.',
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'İşverene kısa bir not iletmek ister misiniz? (Opsiyonel)',
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Başvuruyu Onayla ve Gönder',
                icon: Icons.check_circle_rounded,
                backgroundColor: AppColors.primary,
                onPressed: () {
                  widget.appState.applyToJob(widget.job.id, note: _noteController.text.trim());
                  Navigator.pop(ctx);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Başvurunuz işverene başarıyla iletildi! 🎉'),
                      backgroundColor: AppColors.black,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy, EEEE', 'tr_TR');
    final formattedDate = dateFormat.format(widget.job.workDate);
    final hasApplied = widget.appState.hasApplied(widget.job.id);
    final isFavorite = widget.appState.isFavorite(widget.job.id);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('İlan Detayı'),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFavorite ? AppColors.error : AppColors.black,
            ),
            onPressed: () {
              widget.appState.toggleFavorite(widget.job.id);
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.outlined_flag_rounded, color: AppColors.textSecondary),
            onPressed: () {
              ReportJobDialog.show(
                context,
                targetType: 'job',
                targetId: widget.job.id,
                targetTitle: widget.job.title,
                appState: widget.appState,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst Başlık & Kategori
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.job.categoryTitle,
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.job.jobType.label,
                    style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              widget.job.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary, height: 1.25),
            ),

            const SizedBox(height: 16),

            // Ücret & Kontenjan Kartı
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Net Günlük Yevmiye',
                        style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${widget.job.wage.toStringAsFixed(0)} ₺',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '/ gün',
                            style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Kalan Kontenjan',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.job.remainingSlots} Kişi',
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Çalışma Bilgileri Grid
            _buildDetailRow(
              icon: Icons.calendar_today_rounded,
              title: 'Çalışma Tarihi',
              value: formattedDate,
            ),
            const Divider(height: 24, color: AppColors.border),
            _buildDetailRow(
              icon: Icons.access_time_rounded,
              title: 'Çalışma Saatleri',
              value: widget.job.workHours,
            ),
            const Divider(height: 24, color: AppColors.border),
            _buildDetailRow(
              icon: Icons.location_on_rounded,
              title: 'İş Adresi & Konum',
              value: '${widget.job.addressDetails}\n${widget.job.district} / ${widget.job.city}',
            ),

            const SizedBox(height: 24),

            // İmkanlar (Perks)
            if (widget.job.perks.isNotEmpty) ...[
              const Text(
                'Sağlanan İmkanlar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.job.perks.map((p) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.success),
                        const SizedBox(width: 6),
                        Text(p, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            // İş Açıklaması
            const Text(
              'İş Açıklaması ve Beklentiler',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            Text(
              widget.job.description,
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6),
            ),

            const SizedBox(height: 24),

            // İşletme Bilgisi Kartı
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.job.employerName.isNotEmpty ? widget.job.employerName[0].toUpperCase() : 'İ',
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.job.employerName,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.job.isEmployerVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(Icons.verified_rounded, size: 16, color: AppColors.info),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Onaylı İşletme Hesabı',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat_outlined, color: AppColors.primary),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailScreen(
                            conversationId: 'conv_${widget.job.employerId}',
                            otherUserId: widget.job.employerId,
                            otherUserName: widget.job.employerName,
                            appState: widget.appState,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Yasal Uyarı Linki
            InkWell(
              onTap: () => LegalDisclaimerSheet.show(context),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textMuted),
                  SizedBox(width: 6),
                  Text(
                    'İş sözleşmesi ve güvenlik bilgilendirmesini görüntüle',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary, decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Mesaj Gönder Butonu
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border, width: 1.5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IconButton(
                  icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          conversationId: 'conv_${widget.job.employerId}',
                          otherUserId: widget.job.employerId,
                          otherUserName: widget.job.employerName,
                          appState: widget.appState,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: hasApplied
                    ? Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Bu İlana Başvurdunuz',
                              style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                          ],
                        ),
                      )
                    : CustomButton(
                        text: 'İlana Hemen Başvur',
                        icon: Icons.send_rounded,
                        backgroundColor: AppColors.primary,
                        onPressed: _showApplyDialog,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
