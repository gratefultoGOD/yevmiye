import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../state/app_state.dart';
import '../widgets/job_card.dart';
import '../common/job_detail_screen.dart';

class SeekerFavoritesScreen extends StatelessWidget {
  final AppState appState;

  const SeekerFavoritesScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final favorites = appState.favoriteJobs;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Favori İlanlarım'),
          ),
          body: favorites.isEmpty
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
                        child: const Icon(Icons.favorite_border_rounded, size: 40, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Henüz favori ilanınız yok',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'İlgilendiğiniz iş ilanlarındaki kalp ikonuna tıklayarak\nburaya kaydedebilirsiniz.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final job = favorites[index];
                    return JobCard(
                      job: job,
                      isFavorite: true,
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
        );
      },
    );
  }
}
