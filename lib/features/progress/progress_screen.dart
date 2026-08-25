import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/features/progress/views/history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // 0 = Duration, 1 = Calories
  final ValueNotifier<int> _selectedChartTab = ValueNotifier<int>(0);
  final ValueNotifier<String> _selectedPeriod = ValueNotifier<String>(
    'This Week',
  );

  final List<double> _durationData = const [
    4.4,
    4.4,
    4.4,
    1.2,
    4.4,
    1.5,
    4.4,
    2.3,
    3.1,
    1.6,
    2.6,
    3.4,
  ];

  final List<double> _caloriesData = const [
    3.8,
    4.2,
    4.5,
    2.0,
    4.8,
    2.2,
    4.1,
    3.0,
    3.8,
    2.5,
    3.2,
    4.0,
  ];

  @override
  void dispose() {
    _selectedChartTab.dispose();
    _selectedPeriod.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar with Greeting & Menu
              _buildTopBar(),

              18.heightBox,

              // 4-item Stats Row
              _buildStatsRow(),

              20.heightBox,

              // Chart Container Card
              _buildChartCard(),

              24.heightBox,

              // Recent History / August 2026
              _buildHistorySection(),

              24.heightBox,
            ],
          ),
        ),
      ),
    );
  }

  // ==================== Top Bar ====================
  Widget _buildTopBar() {
    return Row(
      children: [
        // Menu Button
        GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/svgs/menu.svg',
                width: 18,
                height: 14,
              ),
            ),
          ),
        ),

        14.widthBox,

        // Greeting Texts
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning Emily',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              2.heightBox,
              Text(
                "Let's continue your wellness journey",
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),

        // Notifications Icon
        GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: SvgPicture.asset(
              'assets/svgs/notifications.svg',
              width: 18,
              height: 20,
            ),
          ),
        ),
      ],
    );
  }

  // ==================== Stats Row ====================
  Widget _buildStatsRow() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _buildStatItem(
              svgPath: 'assets/svgs/fire.svg',
              value: '234',
              label: 'Calories',
            ),
          ),
          Container(width: 1, height: 36, color: const Color(0xFFF1F1F1)),
          Expanded(
            child: _buildStatItem(
              svgPath: 'assets/svgs/history.svg',
              value: '25',
              label: '25 Minutes',
            ),
          ),
          Container(width: 1, height: 36, color: const Color(0xFFF1F1F1)),
          Expanded(
            child: _buildStatItem(
              svgPath: 'assets/svgs/check.svg',
              value: '04',
              label: 'Workout',
            ),
          ),
          Container(width: 1, height: 36, color: const Color(0xFFF1F1F1)),
          Expanded(
            child: _buildStatItem(
              svgPath: 'assets/svgs/stars.svg',
              value: '06',
              label: 'Day Streak',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String svgPath,
    required String value,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(svgPath, width: 24, height: 24),
        6.heightBox,
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        2.heightBox,
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ==================== Chart Card Container ====================
  Widget _buildChartCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Column(
        children: [
          // Chart Header: Title and Period Dropdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ValueListenableBuilder<int>(
                valueListenable: _selectedChartTab,
                builder: (context, tabIndex, _) {
                  return Row(
                    children: [
                      Text(
                        tabIndex == 0 ? 'Duration' : 'Calories',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      4.widthBox,
                      Text(
                        tabIndex == 0 ? '(min)' : '(kcal)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  );
                },
              ),

              // Period Dropdown
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F1F1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    6.widthBox,
                    ValueListenableBuilder<String>(
                      valueListenable: _selectedPeriod,
                      builder: (context, period, _) {
                        return Text(
                          period,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4D4D4D),
                          ),
                        );
                      },
                    ),
                    4.widthBox,
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: Color(0xFF9E9E9E),
                    ),
                  ],
                ),
              ),
            ],
          ),

          20.heightBox,

          // Bar Chart with Y-axis and Candle Bars
          ValueListenableBuilder<int>(
            valueListenable: _selectedChartTab,
            builder: (context, tabIndex, _) {
              final data = tabIndex == 0 ? _durationData : _caloriesData;
              return _buildBarChart(data);
            },
          ),

          20.heightBox,

          // Duration vs Calories Toggle Switcher
          _buildChartToggleSwitcher(),
        ],
      ),
    );
  }

  // ==================== Bar Chart Widget ====================
  Widget _buildBarChart(List<double> data) {
    const double chartHeight = 150.0;
    const double maxVal = 5.0;

    return Column(
      children: [
        SizedBox(
          height: chartHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Y-Axis Labels (5 to 1)
              SizedBox(
                height: chartHeight,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '5',
                      style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                    ),
                    Text(
                      '4',
                      style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                    ),
                    Text(
                      '3',
                      style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                    ),
                    Text(
                      '2',
                      style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                    ),
                    Text(
                      '1',
                      style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),

              12.widthBox,

              // Candle Bars
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final barWidth =
                        (constraints.maxWidth / data.length) * 0.35;

                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // Bottom horizontal baseline
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 1,
                            color: const Color(0xFF4D4D4D),
                          ),
                        ),

                        // Bars
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(data.length, (index) {
                            final val = data[index];
                            final activeRatio = (val / maxVal).clamp(0.0, 1.0);

                            return SizedBox(
                              width: barWidth,
                              height: chartHeight,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  // Background Light Pink Candle track (#FEEFF2)
                                  Container(
                                    width: barWidth,
                                    height: chartHeight,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFEEFF2),
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(3),
                                      ),
                                    ),
                                  ),

                                  // Active Gradient Portion (180deg: #FF0C53 -> #E45881)
                                  Container(
                                    width: barWidth,
                                    height: chartHeight * activeRatio,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFFFF0C53),
                                          Color(0xFFE45881),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(3),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        8.heightBox,

        // X-Axis Labels (0, 1, 2, ..., 12)
        Row(
          children: [
            const SizedBox(
              width: 12,
              child: Text(
                '0',
                style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
              ),
            ),
            12.widthBox,
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(data.length, (index) {
                  return Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==================== Chart Toggle Switcher ====================
  Widget _buildChartToggleSwitcher() {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F1F1)),
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: _selectedChartTab,
        builder: (context, activeTab, _) {
          return Row(
            children: [
              // Duration Tab
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectedChartTab.value = 0,
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: activeTab == 0
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 15,
                          color: activeTab == 0
                              ? Colors.white
                              : const Color(0xFF6B7280),
                        ),
                        6.widthBox,
                        Text(
                          'Duration',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: activeTab == 0
                                ? Colors.white
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Calories Tab
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectedChartTab.value = 1,
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: activeTab == 1
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_fire_department_rounded,
                          size: 16,
                          color: activeTab == 1
                              ? Colors.white
                              : const Color(0xFF6B7280),
                        ),
                        6.widthBox,
                        Text(
                          'Calories',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: activeTab == 1
                                ? Colors.white
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==================== History Section ====================
  Widget _buildHistorySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'August 2026',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => context.push(HistoryView()),
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          12.heightBox,

          // Workout History Cards
          _buildHistoryCard(
            category: 'Pilates Premier',
            title: 'Day 2. Beginner',
            time: '04:13 PM',
            date: 'AUG 12',
            duration: '04:13',
            calories: '31',
          ),

          12.heightBox,

          _buildHistoryCard(
            category: 'Pilates Premier',
            title: 'Day 2. Beginner',
            time: '04:13 PM',
            date: 'AUG 12',
            duration: '04:13',
            calories: '31',
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard({
    required String category,
    required String title,
    required String time,
    required String date,
    required String duration,
    required String calories,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Gray Rounded Thumbnail Placeholder
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: const Color(0xFFD4D4D4),
              borderRadius: BorderRadius.circular(14),
            ),
          ),

          14.widthBox,

          // Middle Texts and Stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                2.heightBox,
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                8.heightBox,
                Row(
                  children: [
                    // Time / Date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    10.widthBox,
                    Container(
                      width: 1,
                      height: 20,
                      color: const Color(0xFFE5E7EB),
                    ),
                    10.widthBox,

                    // Duration
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          duration,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Text(
                          'Duration',
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    10.widthBox,
                    Container(
                      width: 1,
                      height: 20,
                      color: const Color(0xFFE5E7EB),
                    ),
                    10.widthBox,

                    // Calories
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          calories,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Text(
                          'Kcal',
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Delete / Trash Icon Button
          GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFE45881),
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
