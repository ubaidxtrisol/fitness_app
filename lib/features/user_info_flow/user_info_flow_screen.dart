import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/constants/app_strings.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/core/services/user_info_storage.dart';
import 'package:fitness_app/features/bottom_bar/bottom_bar_screen.dart';
import 'package:fitness_app/features/user_info_flow/models/user_info_question_model.dart';
import 'package:fitness_app/features/user_info_flow/widgets/activities_chips_widget.dart';
import 'package:fitness_app/features/user_info_flow/widgets/age_slider_widget.dart';
import 'package:fitness_app/features/user_info_flow/widgets/body_shape_grid_widget.dart';
import 'package:fitness_app/features/user_info_flow/widgets/height_slider_widget.dart';
import 'package:fitness_app/features/user_info_flow/widgets/injuries_grid_widget.dart';
import 'package:fitness_app/features/user_info_flow/widgets/subtitled_grid_card_widget.dart';
import 'package:fitness_app/features/user_info_flow/widgets/weight_slider_widget.dart';
import 'package:fitness_app/features/user_info_flow/widgets/workout_level_list_widget.dart';
import 'package:fitness_app/features/user_info_flow/widgets/workout_place_grid_widget.dart';
import 'package:flutter/material.dart';

class UserInfoFlowScreen extends StatefulWidget {
  const UserInfoFlowScreen({super.key});

  @override
  State<UserInfoFlowScreen> createState() => _UserInfoFlowScreenState();
}

class _UserInfoFlowScreenState extends State<UserInfoFlowScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Stored state answers
  final Map<String, dynamic> _answers = {
    'height': 165,
    'weight': 75,
    'target_weight': 70,
    'current_body_shape': 'average',
    'target_body_shape': 'lean',
    'age': 28,
    'workout_place': 'home',
    'activities': ['running', 'swimming', 'weight_training'],
    'workout_level': 'intermediate',
    'injuries': ['knee'],
    'belly_hip_type': 'hourglass',
    'leg_type': 'normal',
  };

  final List<QuestionModel> _questions = UserInfoQuestions.questions;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() async {
    await UserInfoStorage.saveAnswers(_answers);

    if (_currentStep < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      if (mounted) {
        context.pushAndRemoveUntil(BottomBarScreen());
      }
    }
  }

  void _onBack() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalSteps = _questions.length;
    final progress = (_currentStep + 1) / totalSteps;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.heightBox,
              // Top Bar: Back Button & Step Counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _onBack,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '${_currentStep + 1} of $totalSteps',
                    style: const TextStyle(
                      fontFamily: 'Nexa',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              16.heightBox,

              // Linear Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFEBEFF5),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
              24.heightBox,

              // Question Area
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    final question = _questions[index];
                    return _buildQuestionContent(question);
                  },
                ),
              ),

              // Bottom Action Button
              Center(
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ButtonStyle().withFixedSize(.maxFinite, 54),
                  child: Text(AppStrings.next),
                ),
              ),

              // Bottom Ad Banner Slot Reservation with Spacing
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionContent(QuestionModel question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          question.title,
          style: const TextStyle(
            fontFamily: 'Nexa',
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            height: 1.15,
          ),
        ),
        8.heightBox,
        // Subtitle
        Text(
          question.subtitle,
          style: const TextStyle(
            fontFamily: 'Nexa',
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: AppColors.textSecondary,
            height: 1.3,
          ),
        ),
        24.heightBox,

        // Self-contained Question Widget
        Expanded(child: _buildDynamicWidget(question)),
      ],
    );
  }

  Widget _buildDynamicWidget(QuestionModel question) {
    switch (question.type) {
      case QuestionType.heightPicker:
        return SizedBox(
          height: 250,
          child: HeightSliderWidget(
            initialHeight: (_answers['height'] as int?) ?? 165,
            onHeightChanged: (val) {
              _answers['height'] = val;
            },
          ),
        );

      case QuestionType.weightPicker:
        return SizedBox(
          height: 250,
          child: WeightSliderWidget(
            initialWeight: (_answers['weight'] as int?) ?? 75,
            onWeightChanged: (val) {
              _answers['weight'] = val;
            },
          ),
        );

      case QuestionType.targetWeightPicker:
        return SizedBox(
          height: 250,
          child: WeightSliderWidget(
            initialWeight: (_answers['target_weight'] as int?) ?? 70,
            onWeightChanged: (val) {
              _answers['target_weight'] = val;
            },
          ),
        );

      case QuestionType.currentBodyShape:
        return BodyShapeGridWidget(
          options: question.bodyShapeOptions,
          selectedId: (_answers['current_body_shape'] as String?) ?? 'average',
          onSelected: (id) {
            setState(() {
              _answers['current_body_shape'] = id;
            });
          },
        );

      case QuestionType.targetBodyShape:
        return BodyShapeGridWidget(
          options: question.bodyShapeOptions,
          selectedId: (_answers['target_body_shape'] as String?) ?? 'lean',
          onSelected: (id) {
            setState(() {
              _answers['target_body_shape'] = id;
            });
          },
        );

      case QuestionType.agePicker:
        return AgeSliderWidget(
          initialAge: (_answers['age'] as int?) ?? 28,
          onAgeChanged: (val) {
            _answers['age'] = val;
          },
        );

      case QuestionType.workoutPlace:
        return WorkoutPlaceGridWidget(
          options: question.workoutPlaceOptions,
          selectedId: (_answers['workout_place'] as String?) ?? 'home',
          onSelected: (id) {
            setState(() {
              _answers['workout_place'] = id;
            });
          },
        );

      case QuestionType.activities:
        return ActivitiesChipsWidget(
          options: question.activitiesOptions,
          selectedList: List<String>.from(
            (_answers['activities'] as List?) ?? [],
          ),
          onChanged: (list) {
            setState(() {
              _answers['activities'] = list;
            });
          },
        );

      case QuestionType.workoutLevel:
        return WorkoutLevelListWidget(
          options: question.workoutLevelOptions,
          selectedId: (_answers['workout_level'] as String?) ?? 'intermediate',
          onSelected: (id) {
            setState(() {
              _answers['workout_level'] = id;
            });
          },
        );

      case QuestionType.injuries:
        return InjuriesGridWidget(
          options: question.injuryOptions,
          selectedList: List<String>.from(
            (_answers['injuries'] as List?) ?? ['knee'],
          ),
          onChanged: (list) {
            setState(() {
              _answers['injuries'] = list;
            });
          },
        );

      case QuestionType.bellyHipType:
        return SubtitledGridCardWidget(
          options: question.subtitledGridOptions,
          selectedId: (_answers['belly_hip_type'] as String?) ?? 'hourglass',
          onSelected: (id) {
            setState(() {
              _answers['belly_hip_type'] = id;
            });
          },
        );

      case QuestionType.legType:
        return SubtitledGridCardWidget(
          options: question.subtitledGridOptions,
          selectedId: (_answers['leg_type'] as String?) ?? 'normal',
          onSelected: (id) {
            setState(() {
              _answers['leg_type'] = id;
            });
          },
        );
    }
  }
}
