import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../state/app_state.dart';

class ReportJobDialog extends StatefulWidget {
  final String targetType; // 'job' veya 'user'
  final String targetId;
  final String targetTitle;
  final AppState appState;

  const ReportJobDialog({
    super.key,
    required this.targetType,
    required this.targetId,
    required this.targetTitle,
    required this.appState,
  });

  static void show(
    BuildContext context, {
    required String targetType,
    required String targetId,
    required String targetTitle,
    required AppState appState,
  }) {
    showDialog(
      context: context,
      builder: (context) => ReportJobDialog(
        targetType: targetType,
        targetId: targetId,
        targetTitle: targetTitle,
        appState: appState,
      ),
    );
  }

  @override
  State<ReportJobDialog> createState() => _ReportJobDialogState();
}

class _ReportJobDialogState extends State<ReportJobDialog> {
  final List<String> _reasons = [
    'Sahte veya yanıltıcı ilan',
    'Belirtilen ücret gerçeği yansıtmıyor',
    'Çalışma koşulları güvenli değil',
    'Hakaret veya uygunsuz iletişim',
    'Dolandırıcılık şüphesi',
    'Diğer',
  ];

  String _selectedReason = 'Sahte veya yanıltıcı ilan';
  final TextEditingController _detailController = TextEditingController();

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.report_problem_rounded, color: AppColors.error, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Şikâyet Bildirimi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '"${widget.targetTitle}" başlıklı kayıt için şikayet nedeninizi seçiniz:',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            ..._reasons.map((reason) {
              return RadioListTile<String>(
                value: reason,
                groupValue: _selectedReason,
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Text(reason, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedReason = val);
                },
              );
            }),
            const SizedBox(height: 12),
            TextField(
              controller: _detailController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Açıklama (opsiyonel)...',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Vazgeç', style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            final reasonText = _detailController.text.trim().isNotEmpty
                ? '$_selectedReason - ${_detailController.text.trim()}'
                : _selectedReason;

            widget.appState.submitReport(
              targetType: widget.targetType,
              targetId: widget.targetId,
              targetTitle: widget.targetTitle,
              reason: reasonText,
            );

            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Şikayetiniz moderasyon ekibimize iletildi. Teşekkürler.'),
                backgroundColor: AppColors.black,
              ),
            );
          },
          child: const Text('Bildir', style: TextStyle(fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
