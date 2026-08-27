import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:fitness_app/features/player/models/player_session.dart';
import 'package:fitness_app/features/player/views/exercise_player_screen.dart';
import 'package:fitness_app/features/discover/views/exercise_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final WorkoutModel workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final workout = widget.workout;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 6,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset('assets/svgs/arrow.svg'),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                });
              },
              child: SvgPicture.asset(
                _isFavorite
                    ? 'assets/svgs/favorit_fill.svg'
                    : 'assets/svgs/favorite.svg',
                height: 24,
                width: 24,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              physics: const BouncingScrollPhysics(),
              children: [
                // Top Hero Workout Banner
                Container(
                  width: double.infinity,
                  height: 177,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE8ED),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      // Right Image
                      Positioned.fill(
                        child: Image.network(
                          workout.thumbnailUrl,
                          fit: BoxFit.cover,

                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: const Color(0xFFFAD2DC),
                                child: const Icon(
                                  Icons.fitness_center_rounded,
                                  color: Color(0xFFE45881),
                                  size: 48,
                                ),
                              ),
                        ),
                      ),
                      // Left Content Text
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                workout.title,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF8B2C47),
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              10.heightBox,
                              Text(
                                '${workout.exercises.length} Exercises',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFBA5D77),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                18.heightBox,

                // 3 Metrics Info Cards (Level, Calories, Net Duration)
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        icon: Icons.check_circle_outline_rounded,
                        iconColor: const Color(0xFF22C55E),
                        iconBg: const Color(0xFFE8F8EE),
                        title: workout.difficulty,
                        subtitle: 'Level',
                      ),
                    ),
                    12.widthBox,
                    Expanded(
                      child: _buildMetricCard(
                        icon: Icons.local_fire_department_rounded,
                        iconColor: const Color(0xFFFF5C8C),
                        iconBg: const Color(0xFFFFEEF3),
                        title: '${workout.caloriesBurned}',
                        subtitle: 'Calories',
                      ),
                    ),
                    12.widthBox,
                    Expanded(
                      child: _buildMetricCard(
                        icon: Icons.access_time_rounded,
                        iconColor: const Color(0xFF3B82F6),
                        iconBg: const Color(0xFFEEF5FF),
                        title: '${workout.netTimeMinutes} min',
                        subtitle: 'Net Duration',
                      ),
                    ),
                  ],
                ),
                22.heightBox,

                // Exercises List Section
                ...List.generate(workout.exercises.length, (index) {
                  final exercise = workout.exercises[index];
                  final exerciseNum = (index + 1).toString().padLeft(2, '0');

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ExerciseDetailScreen(
                            exercise: exercise,
                            dayLabel: 'Day 1',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      height: 76,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 76,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE5E7EB),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.network(
                                  exercise.thumbnailUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                        child: Icon(
                                          Icons.fitness_center_rounded,
                                          color: Color(0xFF9CA3AF),
                                          size: 26,
                                        ),
                                      ),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                left: 5,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    shape: .circle,
                                    // borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    exerciseNum,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          14.widthBox,

                          // Exercise Title and Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: .center,
                              children: [
                                Text(
                                  exercise.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                6.heightBox,
                                Text(
                                  '${(exercise.durationSeconds / 60).ceil()} min . ${exercise.reps > 0 ? '${exercise.reps} Reps' : '${exercise.durationSeconds}s'}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF6C434C),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Action Arrow
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFDE8ED),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ),
                          12.widthBox,
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Bottom Fixed Start Button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => context.push(
                    ExercisePlayerScreen(
                      session: PlayerSession(
                        exercises: workout.exercises,
                        workoutTitle: workout.title,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          8.heightBox,
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          2.heightBox,
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
