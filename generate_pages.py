import os

base_dir = "lib/features/onboarding/pages"
os.makedirs(base_dir, exist_ok=True)

def create_page(filename, class_name, title, content):
    code = f"""import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_button.dart';
{content}
"""
    with open(os.path.join(base_dir, filename), "w") as f:
        f.write(code)

# 1. Intro Pages
create_page("intro_page.dart", "IntroPage", "Welcome", """
class IntroPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const IntroPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Placeholder for image
          Container(
            height: 300.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(Icons.fitness_center, size: 100.sp, color: Colors.grey.shade400),
          ),
          SizedBox(height: 40.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15.h),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          const Spacer(),
          OnboardingButton(
            text: "Next",
            onPressed: () => context.read<OnboardingProvider>().nextPage(),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
""")

# 5. Gender Page
create_page("gender_page.dart", "GenderPage", "What's your gender?", """
import '../widgets/option_selector.dart';

class GenderPage extends StatelessWidget {
  const GenderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text("Tell us about yourself", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("To give you a better experience we need to know your gender", style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          SizedBox(height: 40.h),
          OptionSelector(
            label: "Male",
            icon: "👨",
            isSelected: provider.gender == "Male",
            onTap: () => provider.setGender("Male"),
          ),
          OptionSelector(
            label: "Female",
            icon: "👩",
            isSelected: provider.gender == "Female",
            onTap: () => provider.setGender("Female"),
          ),
          const Spacer(),
          OnboardingButton(
            text: "Next",
            onPressed: () {
              if (provider.gender != null) provider.nextPage();
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
""")

# 6. Age Page
create_page("age_page.dart", "AgePage", "How old are you?", """
import '../widgets/number_picker_widget.dart';

class AgePage extends StatelessWidget {
  const AgePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text("How old are you?", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("This helps us create your personalized plan", style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          const Spacer(),
          NumberPickerWidget(
            minValue: 14,
            maxValue: 100,
            initialValue: provider.age ?? 25,
            onChanged: (val) => context.read<OnboardingProvider>().setAge(val),
          ),
          const Spacer(),
          OnboardingButton(
            text: "Next",
            onPressed: () {
              if (provider.age == null) provider.setAge(25);
              provider.nextPage();
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
""")

# 7. Weight Page
create_page("weight_page.dart", "WeightPage", "What's your weight?", """
import '../widgets/number_picker_widget.dart';

class WeightPage extends StatelessWidget {
  const WeightPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text("What's your weight?", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("You can always change this later", style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          const Spacer(),
          NumberPickerWidget(
            minValue: 30,
            maxValue: 200,
            initialValue: provider.weight?.toInt() ?? 70,
            suffix: "kg",
            onChanged: (val) => context.read<OnboardingProvider>().setWeight(val.toDouble()),
          ),
          const Spacer(),
          OnboardingButton(
            text: "Next",
            onPressed: () {
              if (provider.weight == null) provider.setWeight(70.0);
              provider.nextPage();
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
""")

# 8. Height Page
create_page("height_page.dart", "HeightPage", "What's your height?", """
import '../widgets/number_picker_widget.dart';

class HeightPage extends StatelessWidget {
  const HeightPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text("What's your height?", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("This helps us create your personalized plan", style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          const Spacer(),
          NumberPickerWidget(
            minValue: 100,
            maxValue: 250,
            initialValue: provider.height?.toInt() ?? 170,
            suffix: "cm",
            onChanged: (val) => context.read<OnboardingProvider>().setHeight(val.toDouble()),
          ),
          const Spacer(),
          OnboardingButton(
            text: "Next",
            onPressed: () {
              if (provider.height == null) provider.setHeight(170.0);
              provider.nextPage();
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
""")

# 9. Goal Page
create_page("goal_page.dart", "GoalPage", "What is your goal?", """
import '../widgets/option_selector.dart';

class GoalPage extends StatelessWidget {
  const GoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final goals = ["Lose Weight", "Build Muscle", "Keep Fit", "Improve Flexibility"];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text("What is your goal?", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("It will help us to choose a best program for you", style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          SizedBox(height: 40.h),
          ...goals.map((g) => OptionSelector(
            label: g,
            isSelected: provider.goal == g,
            onTap: () => provider.setGoal(g),
          )),
          const Spacer(),
          OnboardingButton(
            text: "Next",
            onPressed: () {
              if (provider.goal != null) provider.nextPage();
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
""")

# 10. Activity Level Page
create_page("activity_level_page.dart", "ActivityLevelPage", "Your physical activity level?", """
import '../widgets/option_selector.dart';

class ActivityLevelPage extends StatelessWidget {
  const ActivityLevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final levels = ["Sedentary", "Lightly Active", "Moderately Active", "Very Active"];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text("Physical activity level?", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("Choose your regular activity level", style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          SizedBox(height: 40.h),
          ...levels.map((l) => OptionSelector(
            label: l,
            isSelected: provider.activityLevel == l,
            onTap: () => provider.setActivityLevel(l),
          )),
          const Spacer(),
          OnboardingButton(
            text: "Next",
            onPressed: () {
              if (provider.activityLevel != null) provider.nextPage();
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
""")

# 11. Focus Area Page
create_page("focus_area_page.dart", "FocusAreaPage", "Focus Area", """
import '../widgets/option_selector.dart';

class FocusAreaPage extends StatelessWidget {
  const FocusAreaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final areas = ["Full Body", "Arm", "Chest", "Abs", "Leg"];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text("Focus Area", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("What area do you want to focus on?", style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          SizedBox(height: 20.h),
          Expanded(
            child: ListView(
              children: areas.map((a) => OptionSelector(
                label: a,
                isSelected: provider.focusArea == a,
                onTap: () => provider.setFocusArea(a),
              )).toList(),
            ),
          ),
          OnboardingButton(
            text: "Next",
            onPressed: () {
              if (provider.focusArea != null) provider.nextPage();
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
""")

# 12. Workout Days Page
create_page("workout_days_page.dart", "WorkoutDaysPage", "Workout Days", """
import '../widgets/number_picker_widget.dart';

class WorkoutDaysPage extends StatelessWidget {
  const WorkoutDaysPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text("Workout Days", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("How many days a week do you want to train?", style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          const Spacer(),
          NumberPickerWidget(
            minValue: 1,
            maxValue: 7,
            initialValue: provider.workoutDays ?? 3,
            suffix: "Days",
            onChanged: (val) => context.read<OnboardingProvider>().setWorkoutDays(val),
          ),
          const Spacer(),
          OnboardingButton(
            text: "Next",
            onPressed: () {
              if (provider.workoutDays == null) provider.setWorkoutDays(3);
              provider.nextPage();
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
""")

# 13. Diet Preference Page
create_page("diet_preference_page.dart", "DietPreferencePage", "Diet Preferences", """
import '../widgets/option_selector.dart';

class DietPreferencePage extends StatelessWidget {
  const DietPreferencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final diets = ["Standard", "Vegetarian", "Vegan", "Keto", "Paleo"];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text("Diet Preferences", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("Select your preferred diet", style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          SizedBox(height: 20.h),
          Expanded(
            child: ListView(
              children: diets.map((d) => OptionSelector(
                label: d,
                isSelected: provider.diet == d,
                onTap: () => provider.setDiet(d),
              )).toList(),
            ),
          ),
          OnboardingButton(
            text: "Next",
            onPressed: () {
              if (provider.diet != null) provider.nextPage();
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
""")

# 14. Medical Conditions Page
create_page("medical_conditions_page.dart", "MedicalConditionsPage", "Medical Conditions", """
import '../widgets/option_selector.dart';

class MedicalConditionsPage extends StatelessWidget {
  const MedicalConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final conditions = ["None", "Knee Pain", "Back Pain", "Heart Condition", "Other"];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text("Medical Conditions", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("Any injuries or conditions we should know about?", style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          SizedBox(height: 20.h),
          Expanded(
            child: ListView(
              children: conditions.map((c) => OptionSelector(
                label: c,
                isSelected: provider.medicalConditions == c,
                onTap: () => provider.setMedicalConditions(c),
              )).toList(),
            ),
          ),
          OnboardingButton(
            text: "Next",
            onPressed: () {
              if (provider.medicalConditions != null) provider.nextPage();
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
""")

# 15. Generating Plan Page
create_page("generating_plan_page.dart", "GeneratingPlanPage", "Generating Plan", """
import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../../../../my_app.dart'; // To access rootNavigatorKey or we can just pop
import '../../splash/splash_screen.dart'; // Or wherever we go next

class GeneratingPlanPage extends StatefulWidget {
  const GeneratingPlanPage({super.key});

  @override
  State<GeneratingPlanPage> createState() => _GeneratingPlanPageState();
}

class _GeneratingPlanPageState extends State<GeneratingPlanPage> {
  @override
  void initState() {
    super.initState();
    // Simulate generation
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.read<OnboardingProvider>().completeOnboarding();
        // Go to Home (for now redirect to Splash or a dummy Home)
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text("Home Screen")))));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF92A3FD)),
          SizedBox(height: 30.h),
          Text(
            "Generating your personalized plan...",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15.h),
          Text(
            "This will only take a moment",
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
""")

