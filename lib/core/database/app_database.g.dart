// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<String> goal = GeneratedColumn<String>(
    'goal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('lose_weight'),
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('female'),
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(28),
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<int> heightCm = GeneratedColumn<int>(
    'height_cm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(165),
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<int> weightKg = GeneratedColumn<int>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(75),
  );
  static const VerificationMeta _targetWeightKgMeta = const VerificationMeta(
    'targetWeightKg',
  );
  @override
  late final GeneratedColumn<int> targetWeightKg = GeneratedColumn<int>(
    'target_weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(70),
  );
  static const VerificationMeta _currentBodyShapeMeta = const VerificationMeta(
    'currentBodyShape',
  );
  @override
  late final GeneratedColumn<String> currentBodyShape = GeneratedColumn<String>(
    'current_body_shape',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('average'),
  );
  static const VerificationMeta _targetBodyShapeMeta = const VerificationMeta(
    'targetBodyShape',
  );
  @override
  late final GeneratedColumn<String> targetBodyShape = GeneratedColumn<String>(
    'target_body_shape',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('lean'),
  );
  static const VerificationMeta _workoutPlaceMeta = const VerificationMeta(
    'workoutPlace',
  );
  @override
  late final GeneratedColumn<String> workoutPlace = GeneratedColumn<String>(
    'workout_place',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('home'),
  );
  static const VerificationMeta _workoutLevelMeta = const VerificationMeta(
    'workoutLevel',
  );
  @override
  late final GeneratedColumn<String> workoutLevel = GeneratedColumn<String>(
    'workout_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('intermediate'),
  );
  static const VerificationMeta _bellyHipTypeMeta = const VerificationMeta(
    'bellyHipType',
  );
  @override
  late final GeneratedColumn<String> bellyHipType = GeneratedColumn<String>(
    'belly_hip_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('hourglass'),
  );
  static const VerificationMeta _legTypeMeta = const VerificationMeta(
    'legType',
  );
  @override
  late final GeneratedColumn<String> legType = GeneratedColumn<String>(
    'leg_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _activitiesJsonMeta = const VerificationMeta(
    'activitiesJson',
  );
  @override
  late final GeneratedColumn<String> activitiesJson = GeneratedColumn<String>(
    'activities_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _injuriesJsonMeta = const VerificationMeta(
    'injuriesJson',
  );
  @override
  late final GeneratedColumn<String> injuriesJson = GeneratedColumn<String>(
    'injuries_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _onboardingCompleteMeta =
      const VerificationMeta('onboardingComplete');
  @override
  late final GeneratedColumn<bool> onboardingComplete = GeneratedColumn<bool>(
    'onboarding_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goal,
    gender,
    age,
    heightCm,
    weightKg,
    targetWeightKg,
    currentBodyShape,
    targetBodyShape,
    workoutPlace,
    workoutLevel,
    bellyHipType,
    legType,
    activitiesJson,
    injuriesJson,
    onboardingComplete,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('goal')) {
      context.handle(
        _goalMeta,
        goal.isAcceptableOrUnknown(data['goal']!, _goalMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('target_weight_kg')) {
      context.handle(
        _targetWeightKgMeta,
        targetWeightKg.isAcceptableOrUnknown(
          data['target_weight_kg']!,
          _targetWeightKgMeta,
        ),
      );
    }
    if (data.containsKey('current_body_shape')) {
      context.handle(
        _currentBodyShapeMeta,
        currentBodyShape.isAcceptableOrUnknown(
          data['current_body_shape']!,
          _currentBodyShapeMeta,
        ),
      );
    }
    if (data.containsKey('target_body_shape')) {
      context.handle(
        _targetBodyShapeMeta,
        targetBodyShape.isAcceptableOrUnknown(
          data['target_body_shape']!,
          _targetBodyShapeMeta,
        ),
      );
    }
    if (data.containsKey('workout_place')) {
      context.handle(
        _workoutPlaceMeta,
        workoutPlace.isAcceptableOrUnknown(
          data['workout_place']!,
          _workoutPlaceMeta,
        ),
      );
    }
    if (data.containsKey('workout_level')) {
      context.handle(
        _workoutLevelMeta,
        workoutLevel.isAcceptableOrUnknown(
          data['workout_level']!,
          _workoutLevelMeta,
        ),
      );
    }
    if (data.containsKey('belly_hip_type')) {
      context.handle(
        _bellyHipTypeMeta,
        bellyHipType.isAcceptableOrUnknown(
          data['belly_hip_type']!,
          _bellyHipTypeMeta,
        ),
      );
    }
    if (data.containsKey('leg_type')) {
      context.handle(
        _legTypeMeta,
        legType.isAcceptableOrUnknown(data['leg_type']!, _legTypeMeta),
      );
    }
    if (data.containsKey('activities_json')) {
      context.handle(
        _activitiesJsonMeta,
        activitiesJson.isAcceptableOrUnknown(
          data['activities_json']!,
          _activitiesJsonMeta,
        ),
      );
    }
    if (data.containsKey('injuries_json')) {
      context.handle(
        _injuriesJsonMeta,
        injuriesJson.isAcceptableOrUnknown(
          data['injuries_json']!,
          _injuriesJsonMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_complete')) {
      context.handle(
        _onboardingCompleteMeta,
        onboardingComplete.isAcceptableOrUnknown(
          data['onboarding_complete']!,
          _onboardingCompleteMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      goal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      )!,
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height_cm'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight_kg'],
      )!,
      targetWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_weight_kg'],
      )!,
      currentBodyShape: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_body_shape'],
      )!,
      targetBodyShape: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_body_shape'],
      )!,
      workoutPlace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_place'],
      )!,
      workoutLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_level'],
      )!,
      bellyHipType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}belly_hip_type'],
      )!,
      legType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}leg_type'],
      )!,
      activitiesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activities_json'],
      )!,
      injuriesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}injuries_json'],
      )!,
      onboardingComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_complete'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final int id;
  final String goal;
  final String gender;
  final int age;
  final int heightCm;
  final int weightKg;
  final int targetWeightKg;
  final String currentBodyShape;
  final String targetBodyShape;
  final String workoutPlace;
  final String workoutLevel;
  final String bellyHipType;
  final String legType;

  /// JSON-encoded lists so the multi-select answers survive round-trips.
  final String activitiesJson;
  final String injuriesJson;

  /// Set once the flow is finished — the splash screen gates on this.
  final bool onboardingComplete;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const UserProfile({
    required this.id,
    required this.goal,
    required this.gender,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.targetWeightKg,
    required this.currentBodyShape,
    required this.targetBodyShape,
    required this.workoutPlace,
    required this.workoutLevel,
    required this.bellyHipType,
    required this.legType,
    required this.activitiesJson,
    required this.injuriesJson,
    required this.onboardingComplete,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['goal'] = Variable<String>(goal);
    map['gender'] = Variable<String>(gender);
    map['age'] = Variable<int>(age);
    map['height_cm'] = Variable<int>(heightCm);
    map['weight_kg'] = Variable<int>(weightKg);
    map['target_weight_kg'] = Variable<int>(targetWeightKg);
    map['current_body_shape'] = Variable<String>(currentBodyShape);
    map['target_body_shape'] = Variable<String>(targetBodyShape);
    map['workout_place'] = Variable<String>(workoutPlace);
    map['workout_level'] = Variable<String>(workoutLevel);
    map['belly_hip_type'] = Variable<String>(bellyHipType);
    map['leg_type'] = Variable<String>(legType);
    map['activities_json'] = Variable<String>(activitiesJson);
    map['injuries_json'] = Variable<String>(injuriesJson);
    map['onboarding_complete'] = Variable<bool>(onboardingComplete);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      goal: Value(goal),
      gender: Value(gender),
      age: Value(age),
      heightCm: Value(heightCm),
      weightKg: Value(weightKg),
      targetWeightKg: Value(targetWeightKg),
      currentBodyShape: Value(currentBodyShape),
      targetBodyShape: Value(targetBodyShape),
      workoutPlace: Value(workoutPlace),
      workoutLevel: Value(workoutLevel),
      bellyHipType: Value(bellyHipType),
      legType: Value(legType),
      activitiesJson: Value(activitiesJson),
      injuriesJson: Value(injuriesJson),
      onboardingComplete: Value(onboardingComplete),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<int>(json['id']),
      goal: serializer.fromJson<String>(json['goal']),
      gender: serializer.fromJson<String>(json['gender']),
      age: serializer.fromJson<int>(json['age']),
      heightCm: serializer.fromJson<int>(json['heightCm']),
      weightKg: serializer.fromJson<int>(json['weightKg']),
      targetWeightKg: serializer.fromJson<int>(json['targetWeightKg']),
      currentBodyShape: serializer.fromJson<String>(json['currentBodyShape']),
      targetBodyShape: serializer.fromJson<String>(json['targetBodyShape']),
      workoutPlace: serializer.fromJson<String>(json['workoutPlace']),
      workoutLevel: serializer.fromJson<String>(json['workoutLevel']),
      bellyHipType: serializer.fromJson<String>(json['bellyHipType']),
      legType: serializer.fromJson<String>(json['legType']),
      activitiesJson: serializer.fromJson<String>(json['activitiesJson']),
      injuriesJson: serializer.fromJson<String>(json['injuriesJson']),
      onboardingComplete: serializer.fromJson<bool>(json['onboardingComplete']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'goal': serializer.toJson<String>(goal),
      'gender': serializer.toJson<String>(gender),
      'age': serializer.toJson<int>(age),
      'heightCm': serializer.toJson<int>(heightCm),
      'weightKg': serializer.toJson<int>(weightKg),
      'targetWeightKg': serializer.toJson<int>(targetWeightKg),
      'currentBodyShape': serializer.toJson<String>(currentBodyShape),
      'targetBodyShape': serializer.toJson<String>(targetBodyShape),
      'workoutPlace': serializer.toJson<String>(workoutPlace),
      'workoutLevel': serializer.toJson<String>(workoutLevel),
      'bellyHipType': serializer.toJson<String>(bellyHipType),
      'legType': serializer.toJson<String>(legType),
      'activitiesJson': serializer.toJson<String>(activitiesJson),
      'injuriesJson': serializer.toJson<String>(injuriesJson),
      'onboardingComplete': serializer.toJson<bool>(onboardingComplete),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  UserProfile copyWith({
    int? id,
    String? goal,
    String? gender,
    int? age,
    int? heightCm,
    int? weightKg,
    int? targetWeightKg,
    String? currentBodyShape,
    String? targetBodyShape,
    String? workoutPlace,
    String? workoutLevel,
    String? bellyHipType,
    String? legType,
    String? activitiesJson,
    String? injuriesJson,
    bool? onboardingComplete,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => UserProfile(
    id: id ?? this.id,
    goal: goal ?? this.goal,
    gender: gender ?? this.gender,
    age: age ?? this.age,
    heightCm: heightCm ?? this.heightCm,
    weightKg: weightKg ?? this.weightKg,
    targetWeightKg: targetWeightKg ?? this.targetWeightKg,
    currentBodyShape: currentBodyShape ?? this.currentBodyShape,
    targetBodyShape: targetBodyShape ?? this.targetBodyShape,
    workoutPlace: workoutPlace ?? this.workoutPlace,
    workoutLevel: workoutLevel ?? this.workoutLevel,
    bellyHipType: bellyHipType ?? this.bellyHipType,
    legType: legType ?? this.legType,
    activitiesJson: activitiesJson ?? this.activitiesJson,
    injuriesJson: injuriesJson ?? this.injuriesJson,
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      goal: data.goal.present ? data.goal.value : this.goal,
      gender: data.gender.present ? data.gender.value : this.gender,
      age: data.age.present ? data.age.value : this.age,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      targetWeightKg: data.targetWeightKg.present
          ? data.targetWeightKg.value
          : this.targetWeightKg,
      currentBodyShape: data.currentBodyShape.present
          ? data.currentBodyShape.value
          : this.currentBodyShape,
      targetBodyShape: data.targetBodyShape.present
          ? data.targetBodyShape.value
          : this.targetBodyShape,
      workoutPlace: data.workoutPlace.present
          ? data.workoutPlace.value
          : this.workoutPlace,
      workoutLevel: data.workoutLevel.present
          ? data.workoutLevel.value
          : this.workoutLevel,
      bellyHipType: data.bellyHipType.present
          ? data.bellyHipType.value
          : this.bellyHipType,
      legType: data.legType.present ? data.legType.value : this.legType,
      activitiesJson: data.activitiesJson.present
          ? data.activitiesJson.value
          : this.activitiesJson,
      injuriesJson: data.injuriesJson.present
          ? data.injuriesJson.value
          : this.injuriesJson,
      onboardingComplete: data.onboardingComplete.present
          ? data.onboardingComplete.value
          : this.onboardingComplete,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('goal: $goal, ')
          ..write('gender: $gender, ')
          ..write('age: $age, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('currentBodyShape: $currentBodyShape, ')
          ..write('targetBodyShape: $targetBodyShape, ')
          ..write('workoutPlace: $workoutPlace, ')
          ..write('workoutLevel: $workoutLevel, ')
          ..write('bellyHipType: $bellyHipType, ')
          ..write('legType: $legType, ')
          ..write('activitiesJson: $activitiesJson, ')
          ..write('injuriesJson: $injuriesJson, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    goal,
    gender,
    age,
    heightCm,
    weightKg,
    targetWeightKg,
    currentBodyShape,
    targetBodyShape,
    workoutPlace,
    workoutLevel,
    bellyHipType,
    legType,
    activitiesJson,
    injuriesJson,
    onboardingComplete,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.goal == this.goal &&
          other.gender == this.gender &&
          other.age == this.age &&
          other.heightCm == this.heightCm &&
          other.weightKg == this.weightKg &&
          other.targetWeightKg == this.targetWeightKg &&
          other.currentBodyShape == this.currentBodyShape &&
          other.targetBodyShape == this.targetBodyShape &&
          other.workoutPlace == this.workoutPlace &&
          other.workoutLevel == this.workoutLevel &&
          other.bellyHipType == this.bellyHipType &&
          other.legType == this.legType &&
          other.activitiesJson == this.activitiesJson &&
          other.injuriesJson == this.injuriesJson &&
          other.onboardingComplete == this.onboardingComplete &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> id;
  final Value<String> goal;
  final Value<String> gender;
  final Value<int> age;
  final Value<int> heightCm;
  final Value<int> weightKg;
  final Value<int> targetWeightKg;
  final Value<String> currentBodyShape;
  final Value<String> targetBodyShape;
  final Value<String> workoutPlace;
  final Value<String> workoutLevel;
  final Value<String> bellyHipType;
  final Value<String> legType;
  final Value<String> activitiesJson;
  final Value<String> injuriesJson;
  final Value<bool> onboardingComplete;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.goal = const Value.absent(),
    this.gender = const Value.absent(),
    this.age = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.targetWeightKg = const Value.absent(),
    this.currentBodyShape = const Value.absent(),
    this.targetBodyShape = const Value.absent(),
    this.workoutPlace = const Value.absent(),
    this.workoutLevel = const Value.absent(),
    this.bellyHipType = const Value.absent(),
    this.legType = const Value.absent(),
    this.activitiesJson = const Value.absent(),
    this.injuriesJson = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.goal = const Value.absent(),
    this.gender = const Value.absent(),
    this.age = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.targetWeightKg = const Value.absent(),
    this.currentBodyShape = const Value.absent(),
    this.targetBodyShape = const Value.absent(),
    this.workoutPlace = const Value.absent(),
    this.workoutLevel = const Value.absent(),
    this.bellyHipType = const Value.absent(),
    this.legType = const Value.absent(),
    this.activitiesJson = const Value.absent(),
    this.injuriesJson = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<UserProfile> custom({
    Expression<int>? id,
    Expression<String>? goal,
    Expression<String>? gender,
    Expression<int>? age,
    Expression<int>? heightCm,
    Expression<int>? weightKg,
    Expression<int>? targetWeightKg,
    Expression<String>? currentBodyShape,
    Expression<String>? targetBodyShape,
    Expression<String>? workoutPlace,
    Expression<String>? workoutLevel,
    Expression<String>? bellyHipType,
    Expression<String>? legType,
    Expression<String>? activitiesJson,
    Expression<String>? injuriesJson,
    Expression<bool>? onboardingComplete,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goal != null) 'goal': goal,
      if (gender != null) 'gender': gender,
      if (age != null) 'age': age,
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (targetWeightKg != null) 'target_weight_kg': targetWeightKg,
      if (currentBodyShape != null) 'current_body_shape': currentBodyShape,
      if (targetBodyShape != null) 'target_body_shape': targetBodyShape,
      if (workoutPlace != null) 'workout_place': workoutPlace,
      if (workoutLevel != null) 'workout_level': workoutLevel,
      if (bellyHipType != null) 'belly_hip_type': bellyHipType,
      if (legType != null) 'leg_type': legType,
      if (activitiesJson != null) 'activities_json': activitiesJson,
      if (injuriesJson != null) 'injuries_json': injuriesJson,
      if (onboardingComplete != null) 'onboarding_complete': onboardingComplete,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? goal,
    Value<String>? gender,
    Value<int>? age,
    Value<int>? heightCm,
    Value<int>? weightKg,
    Value<int>? targetWeightKg,
    Value<String>? currentBodyShape,
    Value<String>? targetBodyShape,
    Value<String>? workoutPlace,
    Value<String>? workoutLevel,
    Value<String>? bellyHipType,
    Value<String>? legType,
    Value<String>? activitiesJson,
    Value<String>? injuriesJson,
    Value<bool>? onboardingComplete,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      goal: goal ?? this.goal,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      currentBodyShape: currentBodyShape ?? this.currentBodyShape,
      targetBodyShape: targetBodyShape ?? this.targetBodyShape,
      workoutPlace: workoutPlace ?? this.workoutPlace,
      workoutLevel: workoutLevel ?? this.workoutLevel,
      bellyHipType: bellyHipType ?? this.bellyHipType,
      legType: legType ?? this.legType,
      activitiesJson: activitiesJson ?? this.activitiesJson,
      injuriesJson: injuriesJson ?? this.injuriesJson,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (goal.present) {
      map['goal'] = Variable<String>(goal.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<int>(heightCm.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<int>(weightKg.value);
    }
    if (targetWeightKg.present) {
      map['target_weight_kg'] = Variable<int>(targetWeightKg.value);
    }
    if (currentBodyShape.present) {
      map['current_body_shape'] = Variable<String>(currentBodyShape.value);
    }
    if (targetBodyShape.present) {
      map['target_body_shape'] = Variable<String>(targetBodyShape.value);
    }
    if (workoutPlace.present) {
      map['workout_place'] = Variable<String>(workoutPlace.value);
    }
    if (workoutLevel.present) {
      map['workout_level'] = Variable<String>(workoutLevel.value);
    }
    if (bellyHipType.present) {
      map['belly_hip_type'] = Variable<String>(bellyHipType.value);
    }
    if (legType.present) {
      map['leg_type'] = Variable<String>(legType.value);
    }
    if (activitiesJson.present) {
      map['activities_json'] = Variable<String>(activitiesJson.value);
    }
    if (injuriesJson.present) {
      map['injuries_json'] = Variable<String>(injuriesJson.value);
    }
    if (onboardingComplete.present) {
      map['onboarding_complete'] = Variable<bool>(onboardingComplete.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('goal: $goal, ')
          ..write('gender: $gender, ')
          ..write('age: $age, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('currentBodyShape: $currentBodyShape, ')
          ..write('targetBodyShape: $targetBodyShape, ')
          ..write('workoutPlace: $workoutPlace, ')
          ..write('workoutLevel: $workoutLevel, ')
          ..write('bellyHipType: $bellyHipType, ')
          ..write('legType: $legType, ')
          ..write('activitiesJson: $activitiesJson, ')
          ..write('injuriesJson: $injuriesJson, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSettingsRowsTable extends WorkoutSettingsRows
    with TableInfo<$WorkoutSettingsRowsTable, WorkoutSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSettingsRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _voiceGuideEnabledMeta = const VerificationMeta(
    'voiceGuideEnabled',
  );
  @override
  late final GeneratedColumn<bool> voiceGuideEnabled = GeneratedColumn<bool>(
    'voice_guide_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("voice_guide_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _detailedGuideMeta = const VerificationMeta(
    'detailedGuide',
  );
  @override
  late final GeneratedColumn<bool> detailedGuide = GeneratedColumn<bool>(
    'detailed_guide',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("detailed_guide" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _volumeMeta = const VerificationMeta('volume');
  @override
  late final GeneratedColumn<double> volume = GeneratedColumn<double>(
    'volume',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.6),
  );
  static const VerificationMeta _soundEffectEnabledMeta =
      const VerificationMeta('soundEffectEnabled');
  @override
  late final GeneratedColumn<bool> soundEffectEnabled = GeneratedColumn<bool>(
    'sound_effect_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sound_effect_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _countdownSecondsMeta = const VerificationMeta(
    'countdownSeconds',
  );
  @override
  late final GeneratedColumn<int> countdownSeconds = GeneratedColumn<int>(
    'countdown_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    voiceGuideEnabled,
    detailedGuide,
    volume,
    soundEffectEnabled,
    countdownSeconds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_settings_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('voice_guide_enabled')) {
      context.handle(
        _voiceGuideEnabledMeta,
        voiceGuideEnabled.isAcceptableOrUnknown(
          data['voice_guide_enabled']!,
          _voiceGuideEnabledMeta,
        ),
      );
    }
    if (data.containsKey('detailed_guide')) {
      context.handle(
        _detailedGuideMeta,
        detailedGuide.isAcceptableOrUnknown(
          data['detailed_guide']!,
          _detailedGuideMeta,
        ),
      );
    }
    if (data.containsKey('volume')) {
      context.handle(
        _volumeMeta,
        volume.isAcceptableOrUnknown(data['volume']!, _volumeMeta),
      );
    }
    if (data.containsKey('sound_effect_enabled')) {
      context.handle(
        _soundEffectEnabledMeta,
        soundEffectEnabled.isAcceptableOrUnknown(
          data['sound_effect_enabled']!,
          _soundEffectEnabledMeta,
        ),
      );
    }
    if (data.containsKey('countdown_seconds')) {
      context.handle(
        _countdownSecondsMeta,
        countdownSeconds.isAcceptableOrUnknown(
          data['countdown_seconds']!,
          _countdownSecondsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      voiceGuideEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}voice_guide_enabled'],
      )!,
      detailedGuide: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}detailed_guide'],
      )!,
      volume: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}volume'],
      )!,
      soundEffectEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sound_effect_enabled'],
      )!,
      countdownSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}countdown_seconds'],
      )!,
    );
  }

  @override
  $WorkoutSettingsRowsTable createAlias(String alias) {
    return $WorkoutSettingsRowsTable(attachedDatabase, alias);
  }
}

class WorkoutSettingsRow extends DataClass
    implements Insertable<WorkoutSettingsRow> {
  final int id;
  final bool voiceGuideEnabled;
  final bool detailedGuide;
  final double volume;
  final bool soundEffectEnabled;
  final int countdownSeconds;
  const WorkoutSettingsRow({
    required this.id,
    required this.voiceGuideEnabled,
    required this.detailedGuide,
    required this.volume,
    required this.soundEffectEnabled,
    required this.countdownSeconds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['voice_guide_enabled'] = Variable<bool>(voiceGuideEnabled);
    map['detailed_guide'] = Variable<bool>(detailedGuide);
    map['volume'] = Variable<double>(volume);
    map['sound_effect_enabled'] = Variable<bool>(soundEffectEnabled);
    map['countdown_seconds'] = Variable<int>(countdownSeconds);
    return map;
  }

  WorkoutSettingsRowsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSettingsRowsCompanion(
      id: Value(id),
      voiceGuideEnabled: Value(voiceGuideEnabled),
      detailedGuide: Value(detailedGuide),
      volume: Value(volume),
      soundEffectEnabled: Value(soundEffectEnabled),
      countdownSeconds: Value(countdownSeconds),
    );
  }

  factory WorkoutSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSettingsRow(
      id: serializer.fromJson<int>(json['id']),
      voiceGuideEnabled: serializer.fromJson<bool>(json['voiceGuideEnabled']),
      detailedGuide: serializer.fromJson<bool>(json['detailedGuide']),
      volume: serializer.fromJson<double>(json['volume']),
      soundEffectEnabled: serializer.fromJson<bool>(json['soundEffectEnabled']),
      countdownSeconds: serializer.fromJson<int>(json['countdownSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'voiceGuideEnabled': serializer.toJson<bool>(voiceGuideEnabled),
      'detailedGuide': serializer.toJson<bool>(detailedGuide),
      'volume': serializer.toJson<double>(volume),
      'soundEffectEnabled': serializer.toJson<bool>(soundEffectEnabled),
      'countdownSeconds': serializer.toJson<int>(countdownSeconds),
    };
  }

  WorkoutSettingsRow copyWith({
    int? id,
    bool? voiceGuideEnabled,
    bool? detailedGuide,
    double? volume,
    bool? soundEffectEnabled,
    int? countdownSeconds,
  }) => WorkoutSettingsRow(
    id: id ?? this.id,
    voiceGuideEnabled: voiceGuideEnabled ?? this.voiceGuideEnabled,
    detailedGuide: detailedGuide ?? this.detailedGuide,
    volume: volume ?? this.volume,
    soundEffectEnabled: soundEffectEnabled ?? this.soundEffectEnabled,
    countdownSeconds: countdownSeconds ?? this.countdownSeconds,
  );
  WorkoutSettingsRow copyWithCompanion(WorkoutSettingsRowsCompanion data) {
    return WorkoutSettingsRow(
      id: data.id.present ? data.id.value : this.id,
      voiceGuideEnabled: data.voiceGuideEnabled.present
          ? data.voiceGuideEnabled.value
          : this.voiceGuideEnabled,
      detailedGuide: data.detailedGuide.present
          ? data.detailedGuide.value
          : this.detailedGuide,
      volume: data.volume.present ? data.volume.value : this.volume,
      soundEffectEnabled: data.soundEffectEnabled.present
          ? data.soundEffectEnabled.value
          : this.soundEffectEnabled,
      countdownSeconds: data.countdownSeconds.present
          ? data.countdownSeconds.value
          : this.countdownSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSettingsRow(')
          ..write('id: $id, ')
          ..write('voiceGuideEnabled: $voiceGuideEnabled, ')
          ..write('detailedGuide: $detailedGuide, ')
          ..write('volume: $volume, ')
          ..write('soundEffectEnabled: $soundEffectEnabled, ')
          ..write('countdownSeconds: $countdownSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    voiceGuideEnabled,
    detailedGuide,
    volume,
    soundEffectEnabled,
    countdownSeconds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSettingsRow &&
          other.id == this.id &&
          other.voiceGuideEnabled == this.voiceGuideEnabled &&
          other.detailedGuide == this.detailedGuide &&
          other.volume == this.volume &&
          other.soundEffectEnabled == this.soundEffectEnabled &&
          other.countdownSeconds == this.countdownSeconds);
}

class WorkoutSettingsRowsCompanion extends UpdateCompanion<WorkoutSettingsRow> {
  final Value<int> id;
  final Value<bool> voiceGuideEnabled;
  final Value<bool> detailedGuide;
  final Value<double> volume;
  final Value<bool> soundEffectEnabled;
  final Value<int> countdownSeconds;
  const WorkoutSettingsRowsCompanion({
    this.id = const Value.absent(),
    this.voiceGuideEnabled = const Value.absent(),
    this.detailedGuide = const Value.absent(),
    this.volume = const Value.absent(),
    this.soundEffectEnabled = const Value.absent(),
    this.countdownSeconds = const Value.absent(),
  });
  WorkoutSettingsRowsCompanion.insert({
    this.id = const Value.absent(),
    this.voiceGuideEnabled = const Value.absent(),
    this.detailedGuide = const Value.absent(),
    this.volume = const Value.absent(),
    this.soundEffectEnabled = const Value.absent(),
    this.countdownSeconds = const Value.absent(),
  });
  static Insertable<WorkoutSettingsRow> custom({
    Expression<int>? id,
    Expression<bool>? voiceGuideEnabled,
    Expression<bool>? detailedGuide,
    Expression<double>? volume,
    Expression<bool>? soundEffectEnabled,
    Expression<int>? countdownSeconds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (voiceGuideEnabled != null) 'voice_guide_enabled': voiceGuideEnabled,
      if (detailedGuide != null) 'detailed_guide': detailedGuide,
      if (volume != null) 'volume': volume,
      if (soundEffectEnabled != null)
        'sound_effect_enabled': soundEffectEnabled,
      if (countdownSeconds != null) 'countdown_seconds': countdownSeconds,
    });
  }

  WorkoutSettingsRowsCompanion copyWith({
    Value<int>? id,
    Value<bool>? voiceGuideEnabled,
    Value<bool>? detailedGuide,
    Value<double>? volume,
    Value<bool>? soundEffectEnabled,
    Value<int>? countdownSeconds,
  }) {
    return WorkoutSettingsRowsCompanion(
      id: id ?? this.id,
      voiceGuideEnabled: voiceGuideEnabled ?? this.voiceGuideEnabled,
      detailedGuide: detailedGuide ?? this.detailedGuide,
      volume: volume ?? this.volume,
      soundEffectEnabled: soundEffectEnabled ?? this.soundEffectEnabled,
      countdownSeconds: countdownSeconds ?? this.countdownSeconds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (voiceGuideEnabled.present) {
      map['voice_guide_enabled'] = Variable<bool>(voiceGuideEnabled.value);
    }
    if (detailedGuide.present) {
      map['detailed_guide'] = Variable<bool>(detailedGuide.value);
    }
    if (volume.present) {
      map['volume'] = Variable<double>(volume.value);
    }
    if (soundEffectEnabled.present) {
      map['sound_effect_enabled'] = Variable<bool>(soundEffectEnabled.value);
    }
    if (countdownSeconds.present) {
      map['countdown_seconds'] = Variable<int>(countdownSeconds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSettingsRowsCompanion(')
          ..write('id: $id, ')
          ..write('voiceGuideEnabled: $voiceGuideEnabled, ')
          ..write('detailedGuide: $detailedGuide, ')
          ..write('volume: $volume, ')
          ..write('soundEffectEnabled: $soundEffectEnabled, ')
          ..write('countdownSeconds: $countdownSeconds')
          ..write(')'))
        .toString();
  }
}

class $PlanProgressRowsTable extends PlanProgressRows
    with TableInfo<$PlanProgressRowsTable, PlanProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanProgressRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planTypeMeta = const VerificationMeta(
    'planType',
  );
  @override
  late final GeneratedColumn<String> planType = GeneratedColumn<String>(
    'plan_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planTitleMeta = const VerificationMeta(
    'planTitle',
  );
  @override
  late final GeneratedColumn<String> planTitle = GeneratedColumn<String>(
    'plan_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentDayIndexMeta = const VerificationMeta(
    'currentDayIndex',
  );
  @override
  late final GeneratedColumn<int> currentDayIndex = GeneratedColumn<int>(
    'current_day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalDaysMeta = const VerificationMeta(
    'totalDays',
  );
  @override
  late final GeneratedColumn<int> totalDays = GeneratedColumn<int>(
    'total_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedDaysMeta = const VerificationMeta(
    'completedDays',
  );
  @override
  late final GeneratedColumn<int> completedDays = GeneratedColumn<int>(
    'completed_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastActivityAtMeta = const VerificationMeta(
    'lastActivityAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastActivityAt =
      GeneratedColumn<DateTime>(
        'last_activity_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    planId,
    planType,
    planTitle,
    currentDayIndex,
    totalDays,
    completedDays,
    startedAt,
    lastActivityAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_progress_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('plan_type')) {
      context.handle(
        _planTypeMeta,
        planType.isAcceptableOrUnknown(data['plan_type']!, _planTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_planTypeMeta);
    }
    if (data.containsKey('plan_title')) {
      context.handle(
        _planTitleMeta,
        planTitle.isAcceptableOrUnknown(data['plan_title']!, _planTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_planTitleMeta);
    }
    if (data.containsKey('current_day_index')) {
      context.handle(
        _currentDayIndexMeta,
        currentDayIndex.isAcceptableOrUnknown(
          data['current_day_index']!,
          _currentDayIndexMeta,
        ),
      );
    }
    if (data.containsKey('total_days')) {
      context.handle(
        _totalDaysMeta,
        totalDays.isAcceptableOrUnknown(data['total_days']!, _totalDaysMeta),
      );
    }
    if (data.containsKey('completed_days')) {
      context.handle(
        _completedDaysMeta,
        completedDays.isAcceptableOrUnknown(
          data['completed_days']!,
          _completedDaysMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('last_activity_at')) {
      context.handle(
        _lastActivityAtMeta,
        lastActivityAt.isAcceptableOrUnknown(
          data['last_activity_at']!,
          _lastActivityAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {planId};
  @override
  PlanProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanProgressRow(
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      )!,
      planType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_type'],
      )!,
      planTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_title'],
      )!,
      currentDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_day_index'],
      )!,
      totalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_days'],
      )!,
      completedDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_days'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      lastActivityAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_activity_at'],
      ),
    );
  }

  @override
  $PlanProgressRowsTable createAlias(String alias) {
    return $PlanProgressRowsTable(attachedDatabase, alias);
  }
}

class PlanProgressRow extends DataClass implements Insertable<PlanProgressRow> {
  final String planId;
  final String planType;
  final String planTitle;

  /// Index of the next day to do, 0-based.
  final int currentDayIndex;
  final int totalDays;
  final int completedDays;
  final DateTime? startedAt;
  final DateTime? lastActivityAt;
  const PlanProgressRow({
    required this.planId,
    required this.planType,
    required this.planTitle,
    required this.currentDayIndex,
    required this.totalDays,
    required this.completedDays,
    this.startedAt,
    this.lastActivityAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['plan_id'] = Variable<String>(planId);
    map['plan_type'] = Variable<String>(planType);
    map['plan_title'] = Variable<String>(planTitle);
    map['current_day_index'] = Variable<int>(currentDayIndex);
    map['total_days'] = Variable<int>(totalDays);
    map['completed_days'] = Variable<int>(completedDays);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || lastActivityAt != null) {
      map['last_activity_at'] = Variable<DateTime>(lastActivityAt);
    }
    return map;
  }

  PlanProgressRowsCompanion toCompanion(bool nullToAbsent) {
    return PlanProgressRowsCompanion(
      planId: Value(planId),
      planType: Value(planType),
      planTitle: Value(planTitle),
      currentDayIndex: Value(currentDayIndex),
      totalDays: Value(totalDays),
      completedDays: Value(completedDays),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      lastActivityAt: lastActivityAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastActivityAt),
    );
  }

  factory PlanProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanProgressRow(
      planId: serializer.fromJson<String>(json['planId']),
      planType: serializer.fromJson<String>(json['planType']),
      planTitle: serializer.fromJson<String>(json['planTitle']),
      currentDayIndex: serializer.fromJson<int>(json['currentDayIndex']),
      totalDays: serializer.fromJson<int>(json['totalDays']),
      completedDays: serializer.fromJson<int>(json['completedDays']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      lastActivityAt: serializer.fromJson<DateTime?>(json['lastActivityAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'planId': serializer.toJson<String>(planId),
      'planType': serializer.toJson<String>(planType),
      'planTitle': serializer.toJson<String>(planTitle),
      'currentDayIndex': serializer.toJson<int>(currentDayIndex),
      'totalDays': serializer.toJson<int>(totalDays),
      'completedDays': serializer.toJson<int>(completedDays),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'lastActivityAt': serializer.toJson<DateTime?>(lastActivityAt),
    };
  }

  PlanProgressRow copyWith({
    String? planId,
    String? planType,
    String? planTitle,
    int? currentDayIndex,
    int? totalDays,
    int? completedDays,
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> lastActivityAt = const Value.absent(),
  }) => PlanProgressRow(
    planId: planId ?? this.planId,
    planType: planType ?? this.planType,
    planTitle: planTitle ?? this.planTitle,
    currentDayIndex: currentDayIndex ?? this.currentDayIndex,
    totalDays: totalDays ?? this.totalDays,
    completedDays: completedDays ?? this.completedDays,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    lastActivityAt: lastActivityAt.present
        ? lastActivityAt.value
        : this.lastActivityAt,
  );
  PlanProgressRow copyWithCompanion(PlanProgressRowsCompanion data) {
    return PlanProgressRow(
      planId: data.planId.present ? data.planId.value : this.planId,
      planType: data.planType.present ? data.planType.value : this.planType,
      planTitle: data.planTitle.present ? data.planTitle.value : this.planTitle,
      currentDayIndex: data.currentDayIndex.present
          ? data.currentDayIndex.value
          : this.currentDayIndex,
      totalDays: data.totalDays.present ? data.totalDays.value : this.totalDays,
      completedDays: data.completedDays.present
          ? data.completedDays.value
          : this.completedDays,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      lastActivityAt: data.lastActivityAt.present
          ? data.lastActivityAt.value
          : this.lastActivityAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanProgressRow(')
          ..write('planId: $planId, ')
          ..write('planType: $planType, ')
          ..write('planTitle: $planTitle, ')
          ..write('currentDayIndex: $currentDayIndex, ')
          ..write('totalDays: $totalDays, ')
          ..write('completedDays: $completedDays, ')
          ..write('startedAt: $startedAt, ')
          ..write('lastActivityAt: $lastActivityAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    planId,
    planType,
    planTitle,
    currentDayIndex,
    totalDays,
    completedDays,
    startedAt,
    lastActivityAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanProgressRow &&
          other.planId == this.planId &&
          other.planType == this.planType &&
          other.planTitle == this.planTitle &&
          other.currentDayIndex == this.currentDayIndex &&
          other.totalDays == this.totalDays &&
          other.completedDays == this.completedDays &&
          other.startedAt == this.startedAt &&
          other.lastActivityAt == this.lastActivityAt);
}

class PlanProgressRowsCompanion extends UpdateCompanion<PlanProgressRow> {
  final Value<String> planId;
  final Value<String> planType;
  final Value<String> planTitle;
  final Value<int> currentDayIndex;
  final Value<int> totalDays;
  final Value<int> completedDays;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> lastActivityAt;
  final Value<int> rowid;
  const PlanProgressRowsCompanion({
    this.planId = const Value.absent(),
    this.planType = const Value.absent(),
    this.planTitle = const Value.absent(),
    this.currentDayIndex = const Value.absent(),
    this.totalDays = const Value.absent(),
    this.completedDays = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.lastActivityAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlanProgressRowsCompanion.insert({
    required String planId,
    required String planType,
    required String planTitle,
    this.currentDayIndex = const Value.absent(),
    this.totalDays = const Value.absent(),
    this.completedDays = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.lastActivityAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : planId = Value(planId),
       planType = Value(planType),
       planTitle = Value(planTitle);
  static Insertable<PlanProgressRow> custom({
    Expression<String>? planId,
    Expression<String>? planType,
    Expression<String>? planTitle,
    Expression<int>? currentDayIndex,
    Expression<int>? totalDays,
    Expression<int>? completedDays,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? lastActivityAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (planId != null) 'plan_id': planId,
      if (planType != null) 'plan_type': planType,
      if (planTitle != null) 'plan_title': planTitle,
      if (currentDayIndex != null) 'current_day_index': currentDayIndex,
      if (totalDays != null) 'total_days': totalDays,
      if (completedDays != null) 'completed_days': completedDays,
      if (startedAt != null) 'started_at': startedAt,
      if (lastActivityAt != null) 'last_activity_at': lastActivityAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlanProgressRowsCompanion copyWith({
    Value<String>? planId,
    Value<String>? planType,
    Value<String>? planTitle,
    Value<int>? currentDayIndex,
    Value<int>? totalDays,
    Value<int>? completedDays,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? lastActivityAt,
    Value<int>? rowid,
  }) {
    return PlanProgressRowsCompanion(
      planId: planId ?? this.planId,
      planType: planType ?? this.planType,
      planTitle: planTitle ?? this.planTitle,
      currentDayIndex: currentDayIndex ?? this.currentDayIndex,
      totalDays: totalDays ?? this.totalDays,
      completedDays: completedDays ?? this.completedDays,
      startedAt: startedAt ?? this.startedAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (planType.present) {
      map['plan_type'] = Variable<String>(planType.value);
    }
    if (planTitle.present) {
      map['plan_title'] = Variable<String>(planTitle.value);
    }
    if (currentDayIndex.present) {
      map['current_day_index'] = Variable<int>(currentDayIndex.value);
    }
    if (totalDays.present) {
      map['total_days'] = Variable<int>(totalDays.value);
    }
    if (completedDays.present) {
      map['completed_days'] = Variable<int>(completedDays.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (lastActivityAt.present) {
      map['last_activity_at'] = Variable<DateTime>(lastActivityAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanProgressRowsCompanion(')
          ..write('planId: $planId, ')
          ..write('planType: $planType, ')
          ..write('planTitle: $planTitle, ')
          ..write('currentDayIndex: $currentDayIndex, ')
          ..write('totalDays: $totalDays, ')
          ..write('completedDays: $completedDays, ')
          ..write('startedAt: $startedAt, ')
          ..write('lastActivityAt: $lastActivityAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionLogsTable extends SessionLogs
    with TableInfo<$SessionLogsTable, SessionLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planTypeMeta = const VerificationMeta(
    'planType',
  );
  @override
  late final GeneratedColumn<String> planType = GeneratedColumn<String>(
    'plan_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planTitleMeta = const VerificationMeta(
    'planTitle',
  );
  @override
  late final GeneratedColumn<String> planTitle = GeneratedColumn<String>(
    'plan_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayIdMeta = const VerificationMeta('dayId');
  @override
  late final GeneratedColumn<String> dayId = GeneratedColumn<String>(
    'day_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayTitleMeta = const VerificationMeta(
    'dayTitle',
  );
  @override
  late final GeneratedColumn<String> dayTitle = GeneratedColumn<String>(
    'day_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayLevelMeta = const VerificationMeta(
    'dayLevel',
  );
  @override
  late final GeneratedColumn<String> dayLevel = GeneratedColumn<String>(
    'day_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dayIndexMeta = const VerificationMeta(
    'dayIndex',
  );
  @override
  late final GeneratedColumn<int> dayIndex = GeneratedColumn<int>(
    'day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _exercisesCompletedMeta =
      const VerificationMeta('exercisesCompleted');
  @override
  late final GeneratedColumn<int> exercisesCompleted = GeneratedColumn<int>(
    'exercises_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _exercisesTotalMeta = const VerificationMeta(
    'exercisesTotal',
  );
  @override
  late final GeneratedColumn<int> exercisesTotal = GeneratedColumn<int>(
    'exercises_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _thumbnailUrlMeta = const VerificationMeta(
    'thumbnailUrl',
  );
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
    'thumbnail_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    planId,
    planType,
    planTitle,
    dayId,
    dayTitle,
    dayLevel,
    dayIndex,
    exercisesCompleted,
    exercisesTotal,
    durationSeconds,
    calories,
    completed,
    thumbnailUrl,
    startedAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('plan_type')) {
      context.handle(
        _planTypeMeta,
        planType.isAcceptableOrUnknown(data['plan_type']!, _planTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_planTypeMeta);
    }
    if (data.containsKey('plan_title')) {
      context.handle(
        _planTitleMeta,
        planTitle.isAcceptableOrUnknown(data['plan_title']!, _planTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_planTitleMeta);
    }
    if (data.containsKey('day_id')) {
      context.handle(
        _dayIdMeta,
        dayId.isAcceptableOrUnknown(data['day_id']!, _dayIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIdMeta);
    }
    if (data.containsKey('day_title')) {
      context.handle(
        _dayTitleMeta,
        dayTitle.isAcceptableOrUnknown(data['day_title']!, _dayTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_dayTitleMeta);
    }
    if (data.containsKey('day_level')) {
      context.handle(
        _dayLevelMeta,
        dayLevel.isAcceptableOrUnknown(data['day_level']!, _dayLevelMeta),
      );
    }
    if (data.containsKey('day_index')) {
      context.handle(
        _dayIndexMeta,
        dayIndex.isAcceptableOrUnknown(data['day_index']!, _dayIndexMeta),
      );
    }
    if (data.containsKey('exercises_completed')) {
      context.handle(
        _exercisesCompletedMeta,
        exercisesCompleted.isAcceptableOrUnknown(
          data['exercises_completed']!,
          _exercisesCompletedMeta,
        ),
      );
    }
    if (data.containsKey('exercises_total')) {
      context.handle(
        _exercisesTotalMeta,
        exercisesTotal.isAcceptableOrUnknown(
          data['exercises_total']!,
          _exercisesTotalMeta,
        ),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
        _thumbnailUrlMeta,
        thumbnailUrl.isAcceptableOrUnknown(
          data['thumbnail_url']!,
          _thumbnailUrlMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      )!,
      planType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_type'],
      )!,
      planTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_title'],
      )!,
      dayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_id'],
      )!,
      dayTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_title'],
      )!,
      dayLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_level'],
      )!,
      dayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_index'],
      )!,
      exercisesCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercises_completed'],
      )!,
      exercisesTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercises_total'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      thumbnailUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_url'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
    );
  }

  @override
  $SessionLogsTable createAlias(String alias) {
    return $SessionLogsTable(attachedDatabase, alias);
  }
}

class SessionLog extends DataClass implements Insertable<SessionLog> {
  final int id;
  final String planId;
  final String planType;
  final String planTitle;
  final String dayId;
  final String dayTitle;

  /// "Beginner" / "Intermediate" — the second half of the history card's
  /// "Day 2. Beginner" line (Figma 17:1633).
  final String dayLevel;
  final int dayIndex;
  final int exercisesCompleted;
  final int exercisesTotal;
  final int durationSeconds;
  final int calories;
  final bool completed;

  /// Artwork for the history card's tile (Figma 17:1631) — the thumbnail of
  /// the first exercise in the run, captured at log time so history keeps
  /// showing what the user actually did even if the catalogue changes.
  final String thumbnailUrl;
  final DateTime startedAt;
  final DateTime completedAt;
  const SessionLog({
    required this.id,
    required this.planId,
    required this.planType,
    required this.planTitle,
    required this.dayId,
    required this.dayTitle,
    required this.dayLevel,
    required this.dayIndex,
    required this.exercisesCompleted,
    required this.exercisesTotal,
    required this.durationSeconds,
    required this.calories,
    required this.completed,
    required this.thumbnailUrl,
    required this.startedAt,
    required this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_id'] = Variable<String>(planId);
    map['plan_type'] = Variable<String>(planType);
    map['plan_title'] = Variable<String>(planTitle);
    map['day_id'] = Variable<String>(dayId);
    map['day_title'] = Variable<String>(dayTitle);
    map['day_level'] = Variable<String>(dayLevel);
    map['day_index'] = Variable<int>(dayIndex);
    map['exercises_completed'] = Variable<int>(exercisesCompleted);
    map['exercises_total'] = Variable<int>(exercisesTotal);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['calories'] = Variable<int>(calories);
    map['completed'] = Variable<bool>(completed);
    map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  SessionLogsCompanion toCompanion(bool nullToAbsent) {
    return SessionLogsCompanion(
      id: Value(id),
      planId: Value(planId),
      planType: Value(planType),
      planTitle: Value(planTitle),
      dayId: Value(dayId),
      dayTitle: Value(dayTitle),
      dayLevel: Value(dayLevel),
      dayIndex: Value(dayIndex),
      exercisesCompleted: Value(exercisesCompleted),
      exercisesTotal: Value(exercisesTotal),
      durationSeconds: Value(durationSeconds),
      calories: Value(calories),
      completed: Value(completed),
      thumbnailUrl: Value(thumbnailUrl),
      startedAt: Value(startedAt),
      completedAt: Value(completedAt),
    );
  }

  factory SessionLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionLog(
      id: serializer.fromJson<int>(json['id']),
      planId: serializer.fromJson<String>(json['planId']),
      planType: serializer.fromJson<String>(json['planType']),
      planTitle: serializer.fromJson<String>(json['planTitle']),
      dayId: serializer.fromJson<String>(json['dayId']),
      dayTitle: serializer.fromJson<String>(json['dayTitle']),
      dayLevel: serializer.fromJson<String>(json['dayLevel']),
      dayIndex: serializer.fromJson<int>(json['dayIndex']),
      exercisesCompleted: serializer.fromJson<int>(json['exercisesCompleted']),
      exercisesTotal: serializer.fromJson<int>(json['exercisesTotal']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      calories: serializer.fromJson<int>(json['calories']),
      completed: serializer.fromJson<bool>(json['completed']),
      thumbnailUrl: serializer.fromJson<String>(json['thumbnailUrl']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planId': serializer.toJson<String>(planId),
      'planType': serializer.toJson<String>(planType),
      'planTitle': serializer.toJson<String>(planTitle),
      'dayId': serializer.toJson<String>(dayId),
      'dayTitle': serializer.toJson<String>(dayTitle),
      'dayLevel': serializer.toJson<String>(dayLevel),
      'dayIndex': serializer.toJson<int>(dayIndex),
      'exercisesCompleted': serializer.toJson<int>(exercisesCompleted),
      'exercisesTotal': serializer.toJson<int>(exercisesTotal),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'calories': serializer.toJson<int>(calories),
      'completed': serializer.toJson<bool>(completed),
      'thumbnailUrl': serializer.toJson<String>(thumbnailUrl),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  SessionLog copyWith({
    int? id,
    String? planId,
    String? planType,
    String? planTitle,
    String? dayId,
    String? dayTitle,
    String? dayLevel,
    int? dayIndex,
    int? exercisesCompleted,
    int? exercisesTotal,
    int? durationSeconds,
    int? calories,
    bool? completed,
    String? thumbnailUrl,
    DateTime? startedAt,
    DateTime? completedAt,
  }) => SessionLog(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    planType: planType ?? this.planType,
    planTitle: planTitle ?? this.planTitle,
    dayId: dayId ?? this.dayId,
    dayTitle: dayTitle ?? this.dayTitle,
    dayLevel: dayLevel ?? this.dayLevel,
    dayIndex: dayIndex ?? this.dayIndex,
    exercisesCompleted: exercisesCompleted ?? this.exercisesCompleted,
    exercisesTotal: exercisesTotal ?? this.exercisesTotal,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    calories: calories ?? this.calories,
    completed: completed ?? this.completed,
    thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt ?? this.completedAt,
  );
  SessionLog copyWithCompanion(SessionLogsCompanion data) {
    return SessionLog(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      planType: data.planType.present ? data.planType.value : this.planType,
      planTitle: data.planTitle.present ? data.planTitle.value : this.planTitle,
      dayId: data.dayId.present ? data.dayId.value : this.dayId,
      dayTitle: data.dayTitle.present ? data.dayTitle.value : this.dayTitle,
      dayLevel: data.dayLevel.present ? data.dayLevel.value : this.dayLevel,
      dayIndex: data.dayIndex.present ? data.dayIndex.value : this.dayIndex,
      exercisesCompleted: data.exercisesCompleted.present
          ? data.exercisesCompleted.value
          : this.exercisesCompleted,
      exercisesTotal: data.exercisesTotal.present
          ? data.exercisesTotal.value
          : this.exercisesTotal,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      calories: data.calories.present ? data.calories.value : this.calories,
      completed: data.completed.present ? data.completed.value : this.completed,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionLog(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('planType: $planType, ')
          ..write('planTitle: $planTitle, ')
          ..write('dayId: $dayId, ')
          ..write('dayTitle: $dayTitle, ')
          ..write('dayLevel: $dayLevel, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('exercisesCompleted: $exercisesCompleted, ')
          ..write('exercisesTotal: $exercisesTotal, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('calories: $calories, ')
          ..write('completed: $completed, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    planId,
    planType,
    planTitle,
    dayId,
    dayTitle,
    dayLevel,
    dayIndex,
    exercisesCompleted,
    exercisesTotal,
    durationSeconds,
    calories,
    completed,
    thumbnailUrl,
    startedAt,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionLog &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.planType == this.planType &&
          other.planTitle == this.planTitle &&
          other.dayId == this.dayId &&
          other.dayTitle == this.dayTitle &&
          other.dayLevel == this.dayLevel &&
          other.dayIndex == this.dayIndex &&
          other.exercisesCompleted == this.exercisesCompleted &&
          other.exercisesTotal == this.exercisesTotal &&
          other.durationSeconds == this.durationSeconds &&
          other.calories == this.calories &&
          other.completed == this.completed &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt);
}

class SessionLogsCompanion extends UpdateCompanion<SessionLog> {
  final Value<int> id;
  final Value<String> planId;
  final Value<String> planType;
  final Value<String> planTitle;
  final Value<String> dayId;
  final Value<String> dayTitle;
  final Value<String> dayLevel;
  final Value<int> dayIndex;
  final Value<int> exercisesCompleted;
  final Value<int> exercisesTotal;
  final Value<int> durationSeconds;
  final Value<int> calories;
  final Value<bool> completed;
  final Value<String> thumbnailUrl;
  final Value<DateTime> startedAt;
  final Value<DateTime> completedAt;
  const SessionLogsCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.planType = const Value.absent(),
    this.planTitle = const Value.absent(),
    this.dayId = const Value.absent(),
    this.dayTitle = const Value.absent(),
    this.dayLevel = const Value.absent(),
    this.dayIndex = const Value.absent(),
    this.exercisesCompleted = const Value.absent(),
    this.exercisesTotal = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.calories = const Value.absent(),
    this.completed = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  SessionLogsCompanion.insert({
    this.id = const Value.absent(),
    required String planId,
    required String planType,
    required String planTitle,
    required String dayId,
    required String dayTitle,
    this.dayLevel = const Value.absent(),
    this.dayIndex = const Value.absent(),
    this.exercisesCompleted = const Value.absent(),
    this.exercisesTotal = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.calories = const Value.absent(),
    this.completed = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    required DateTime startedAt,
    required DateTime completedAt,
  }) : planId = Value(planId),
       planType = Value(planType),
       planTitle = Value(planTitle),
       dayId = Value(dayId),
       dayTitle = Value(dayTitle),
       startedAt = Value(startedAt),
       completedAt = Value(completedAt);
  static Insertable<SessionLog> custom({
    Expression<int>? id,
    Expression<String>? planId,
    Expression<String>? planType,
    Expression<String>? planTitle,
    Expression<String>? dayId,
    Expression<String>? dayTitle,
    Expression<String>? dayLevel,
    Expression<int>? dayIndex,
    Expression<int>? exercisesCompleted,
    Expression<int>? exercisesTotal,
    Expression<int>? durationSeconds,
    Expression<int>? calories,
    Expression<bool>? completed,
    Expression<String>? thumbnailUrl,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (planType != null) 'plan_type': planType,
      if (planTitle != null) 'plan_title': planTitle,
      if (dayId != null) 'day_id': dayId,
      if (dayTitle != null) 'day_title': dayTitle,
      if (dayLevel != null) 'day_level': dayLevel,
      if (dayIndex != null) 'day_index': dayIndex,
      if (exercisesCompleted != null) 'exercises_completed': exercisesCompleted,
      if (exercisesTotal != null) 'exercises_total': exercisesTotal,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (calories != null) 'calories': calories,
      if (completed != null) 'completed': completed,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  SessionLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? planId,
    Value<String>? planType,
    Value<String>? planTitle,
    Value<String>? dayId,
    Value<String>? dayTitle,
    Value<String>? dayLevel,
    Value<int>? dayIndex,
    Value<int>? exercisesCompleted,
    Value<int>? exercisesTotal,
    Value<int>? durationSeconds,
    Value<int>? calories,
    Value<bool>? completed,
    Value<String>? thumbnailUrl,
    Value<DateTime>? startedAt,
    Value<DateTime>? completedAt,
  }) {
    return SessionLogsCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      planType: planType ?? this.planType,
      planTitle: planTitle ?? this.planTitle,
      dayId: dayId ?? this.dayId,
      dayTitle: dayTitle ?? this.dayTitle,
      dayLevel: dayLevel ?? this.dayLevel,
      dayIndex: dayIndex ?? this.dayIndex,
      exercisesCompleted: exercisesCompleted ?? this.exercisesCompleted,
      exercisesTotal: exercisesTotal ?? this.exercisesTotal,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      calories: calories ?? this.calories,
      completed: completed ?? this.completed,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (planType.present) {
      map['plan_type'] = Variable<String>(planType.value);
    }
    if (planTitle.present) {
      map['plan_title'] = Variable<String>(planTitle.value);
    }
    if (dayId.present) {
      map['day_id'] = Variable<String>(dayId.value);
    }
    if (dayTitle.present) {
      map['day_title'] = Variable<String>(dayTitle.value);
    }
    if (dayLevel.present) {
      map['day_level'] = Variable<String>(dayLevel.value);
    }
    if (dayIndex.present) {
      map['day_index'] = Variable<int>(dayIndex.value);
    }
    if (exercisesCompleted.present) {
      map['exercises_completed'] = Variable<int>(exercisesCompleted.value);
    }
    if (exercisesTotal.present) {
      map['exercises_total'] = Variable<int>(exercisesTotal.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionLogsCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('planType: $planType, ')
          ..write('planTitle: $planTitle, ')
          ..write('dayId: $dayId, ')
          ..write('dayTitle: $dayTitle, ')
          ..write('dayLevel: $dayLevel, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('exercisesCompleted: $exercisesCompleted, ')
          ..write('exercisesTotal: $exercisesTotal, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('calories: $calories, ')
          ..write('completed: $completed, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $ExerciseLogsTable extends ExerciseLogs
    with TableInfo<$ExerciseLogsTable, ExerciseLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionLogIdMeta = const VerificationMeta(
    'sessionLogId',
  );
  @override
  late final GeneratedColumn<int> sessionLogId = GeneratedColumn<int>(
    'session_log_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _thumbnailUrlMeta = const VerificationMeta(
    'thumbnailUrl',
  );
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
    'thumbnail_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionLogId,
    exerciseId,
    title,
    durationSeconds,
    calories,
    thumbnailUrl,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_log_id')) {
      context.handle(
        _sessionLogIdMeta,
        sessionLogId.isAcceptableOrUnknown(
          data['session_log_id']!,
          _sessionLogIdMeta,
        ),
      );
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
        _thumbnailUrlMeta,
        thumbnailUrl.isAcceptableOrUnknown(
          data['thumbnail_url']!,
          _thumbnailUrlMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionLogId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_log_id'],
      ),
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories'],
      )!,
      thumbnailUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_url'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
    );
  }

  @override
  $ExerciseLogsTable createAlias(String alias) {
    return $ExerciseLogsTable(attachedDatabase, alias);
  }
}

class ExerciseLog extends DataClass implements Insertable<ExerciseLog> {
  final int id;
  final int? sessionLogId;
  final String exerciseId;
  final String title;
  final int durationSeconds;
  final int calories;
  final String thumbnailUrl;
  final DateTime completedAt;
  const ExerciseLog({
    required this.id,
    this.sessionLogId,
    required this.exerciseId,
    required this.title,
    required this.durationSeconds,
    required this.calories,
    required this.thumbnailUrl,
    required this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || sessionLogId != null) {
      map['session_log_id'] = Variable<int>(sessionLogId);
    }
    map['exercise_id'] = Variable<String>(exerciseId);
    map['title'] = Variable<String>(title);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['calories'] = Variable<int>(calories);
    map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  ExerciseLogsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseLogsCompanion(
      id: Value(id),
      sessionLogId: sessionLogId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionLogId),
      exerciseId: Value(exerciseId),
      title: Value(title),
      durationSeconds: Value(durationSeconds),
      calories: Value(calories),
      thumbnailUrl: Value(thumbnailUrl),
      completedAt: Value(completedAt),
    );
  }

  factory ExerciseLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseLog(
      id: serializer.fromJson<int>(json['id']),
      sessionLogId: serializer.fromJson<int?>(json['sessionLogId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      title: serializer.fromJson<String>(json['title']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      calories: serializer.fromJson<int>(json['calories']),
      thumbnailUrl: serializer.fromJson<String>(json['thumbnailUrl']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionLogId': serializer.toJson<int?>(sessionLogId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'title': serializer.toJson<String>(title),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'calories': serializer.toJson<int>(calories),
      'thumbnailUrl': serializer.toJson<String>(thumbnailUrl),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  ExerciseLog copyWith({
    int? id,
    Value<int?> sessionLogId = const Value.absent(),
    String? exerciseId,
    String? title,
    int? durationSeconds,
    int? calories,
    String? thumbnailUrl,
    DateTime? completedAt,
  }) => ExerciseLog(
    id: id ?? this.id,
    sessionLogId: sessionLogId.present ? sessionLogId.value : this.sessionLogId,
    exerciseId: exerciseId ?? this.exerciseId,
    title: title ?? this.title,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    calories: calories ?? this.calories,
    thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    completedAt: completedAt ?? this.completedAt,
  );
  ExerciseLog copyWithCompanion(ExerciseLogsCompanion data) {
    return ExerciseLog(
      id: data.id.present ? data.id.value : this.id,
      sessionLogId: data.sessionLogId.present
          ? data.sessionLogId.value
          : this.sessionLogId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      title: data.title.present ? data.title.value : this.title,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      calories: data.calories.present ? data.calories.value : this.calories,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseLog(')
          ..write('id: $id, ')
          ..write('sessionLogId: $sessionLogId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('title: $title, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('calories: $calories, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionLogId,
    exerciseId,
    title,
    durationSeconds,
    calories,
    thumbnailUrl,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseLog &&
          other.id == this.id &&
          other.sessionLogId == this.sessionLogId &&
          other.exerciseId == this.exerciseId &&
          other.title == this.title &&
          other.durationSeconds == this.durationSeconds &&
          other.calories == this.calories &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.completedAt == this.completedAt);
}

class ExerciseLogsCompanion extends UpdateCompanion<ExerciseLog> {
  final Value<int> id;
  final Value<int?> sessionLogId;
  final Value<String> exerciseId;
  final Value<String> title;
  final Value<int> durationSeconds;
  final Value<int> calories;
  final Value<String> thumbnailUrl;
  final Value<DateTime> completedAt;
  const ExerciseLogsCompanion({
    this.id = const Value.absent(),
    this.sessionLogId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.title = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.calories = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  ExerciseLogsCompanion.insert({
    this.id = const Value.absent(),
    this.sessionLogId = const Value.absent(),
    required String exerciseId,
    required String title,
    this.durationSeconds = const Value.absent(),
    this.calories = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    required DateTime completedAt,
  }) : exerciseId = Value(exerciseId),
       title = Value(title),
       completedAt = Value(completedAt);
  static Insertable<ExerciseLog> custom({
    Expression<int>? id,
    Expression<int>? sessionLogId,
    Expression<String>? exerciseId,
    Expression<String>? title,
    Expression<int>? durationSeconds,
    Expression<int>? calories,
    Expression<String>? thumbnailUrl,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionLogId != null) 'session_log_id': sessionLogId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (title != null) 'title': title,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (calories != null) 'calories': calories,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  ExerciseLogsCompanion copyWith({
    Value<int>? id,
    Value<int?>? sessionLogId,
    Value<String>? exerciseId,
    Value<String>? title,
    Value<int>? durationSeconds,
    Value<int>? calories,
    Value<String>? thumbnailUrl,
    Value<DateTime>? completedAt,
  }) {
    return ExerciseLogsCompanion(
      id: id ?? this.id,
      sessionLogId: sessionLogId ?? this.sessionLogId,
      exerciseId: exerciseId ?? this.exerciseId,
      title: title ?? this.title,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      calories: calories ?? this.calories,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionLogId.present) {
      map['session_log_id'] = Variable<int>(sessionLogId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseLogsCompanion(')
          ..write('id: $id, ')
          ..write('sessionLogId: $sessionLogId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('title: $title, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('calories: $calories, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $ExercisePreferencesTable extends ExercisePreferences
    with TableInfo<$ExercisePreferencesTable, ExercisePreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisePreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    exerciseId,
    durationSeconds,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExercisePreference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {exerciseId};
  @override
  ExercisePreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExercisePreference(
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ExercisePreferencesTable createAlias(String alias) {
    return $ExercisePreferencesTable(attachedDatabase, alias);
  }
}

class ExercisePreference extends DataClass
    implements Insertable<ExercisePreference> {
  final String exerciseId;
  final int durationSeconds;
  final DateTime? updatedAt;
  const ExercisePreference({
    required this.exerciseId,
    required this.durationSeconds,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['exercise_id'] = Variable<String>(exerciseId);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ExercisePreferencesCompanion toCompanion(bool nullToAbsent) {
    return ExercisePreferencesCompanion(
      exerciseId: Value(exerciseId),
      durationSeconds: Value(durationSeconds),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ExercisePreference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExercisePreference(
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'exerciseId': serializer.toJson<String>(exerciseId),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  ExercisePreference copyWith({
    String? exerciseId,
    int? durationSeconds,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => ExercisePreference(
    exerciseId: exerciseId ?? this.exerciseId,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  ExercisePreference copyWithCompanion(ExercisePreferencesCompanion data) {
    return ExercisePreference(
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExercisePreference(')
          ..write('exerciseId: $exerciseId, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(exerciseId, durationSeconds, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExercisePreference &&
          other.exerciseId == this.exerciseId &&
          other.durationSeconds == this.durationSeconds &&
          other.updatedAt == this.updatedAt);
}

class ExercisePreferencesCompanion extends UpdateCompanion<ExercisePreference> {
  final Value<String> exerciseId;
  final Value<int> durationSeconds;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const ExercisePreferencesCompanion({
    this.exerciseId = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExercisePreferencesCompanion.insert({
    required String exerciseId,
    required int durationSeconds,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : exerciseId = Value(exerciseId),
       durationSeconds = Value(durationSeconds);
  static Insertable<ExercisePreference> custom({
    Expression<String>? exerciseId,
    Expression<int>? durationSeconds,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExercisePreferencesCompanion copyWith({
    Value<String>? exerciseId,
    Value<int>? durationSeconds,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return ExercisePreferencesCompanion(
      exerciseId: exerciseId ?? this.exerciseId,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisePreferencesCompanion(')
          ..write('exerciseId: $exerciseId, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActiveSessionsTable extends ActiveSessions
    with TableInfo<$ActiveSessionsTable, ActiveSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayIdMeta = const VerificationMeta('dayId');
  @override
  late final GeneratedColumn<String> dayId = GeneratedColumn<String>(
    'day_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planTypeMeta = const VerificationMeta(
    'planType',
  );
  @override
  late final GeneratedColumn<String> planType = GeneratedColumn<String>(
    'plan_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planTitleMeta = const VerificationMeta(
    'planTitle',
  );
  @override
  late final GeneratedColumn<String> planTitle = GeneratedColumn<String>(
    'plan_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayTitleMeta = const VerificationMeta(
    'dayTitle',
  );
  @override
  late final GeneratedColumn<String> dayTitle = GeneratedColumn<String>(
    'day_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayLevelMeta = const VerificationMeta(
    'dayLevel',
  );
  @override
  late final GeneratedColumn<String> dayLevel = GeneratedColumn<String>(
    'day_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dayIndexMeta = const VerificationMeta(
    'dayIndex',
  );
  @override
  late final GeneratedColumn<int> dayIndex = GeneratedColumn<int>(
    'day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalDaysMeta = const VerificationMeta(
    'totalDays',
  );
  @override
  late final GeneratedColumn<int> totalDays = GeneratedColumn<int>(
    'total_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedExerciseIdsJsonMeta =
      const VerificationMeta('completedExerciseIdsJson');
  @override
  late final GeneratedColumn<String> completedExerciseIdsJson =
      GeneratedColumn<String>(
        'completed_exercise_ids_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _elapsedSecondsMeta = const VerificationMeta(
    'elapsedSeconds',
  );
  @override
  late final GeneratedColumn<int> elapsedSeconds = GeneratedColumn<int>(
    'elapsed_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    planId,
    dayId,
    planType,
    planTitle,
    dayTitle,
    dayLevel,
    dayIndex,
    totalDays,
    completedExerciseIdsJson,
    elapsedSeconds,
    startedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActiveSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('day_id')) {
      context.handle(
        _dayIdMeta,
        dayId.isAcceptableOrUnknown(data['day_id']!, _dayIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIdMeta);
    }
    if (data.containsKey('plan_type')) {
      context.handle(
        _planTypeMeta,
        planType.isAcceptableOrUnknown(data['plan_type']!, _planTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_planTypeMeta);
    }
    if (data.containsKey('plan_title')) {
      context.handle(
        _planTitleMeta,
        planTitle.isAcceptableOrUnknown(data['plan_title']!, _planTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_planTitleMeta);
    }
    if (data.containsKey('day_title')) {
      context.handle(
        _dayTitleMeta,
        dayTitle.isAcceptableOrUnknown(data['day_title']!, _dayTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_dayTitleMeta);
    }
    if (data.containsKey('day_level')) {
      context.handle(
        _dayLevelMeta,
        dayLevel.isAcceptableOrUnknown(data['day_level']!, _dayLevelMeta),
      );
    }
    if (data.containsKey('day_index')) {
      context.handle(
        _dayIndexMeta,
        dayIndex.isAcceptableOrUnknown(data['day_index']!, _dayIndexMeta),
      );
    }
    if (data.containsKey('total_days')) {
      context.handle(
        _totalDaysMeta,
        totalDays.isAcceptableOrUnknown(data['total_days']!, _totalDaysMeta),
      );
    }
    if (data.containsKey('completed_exercise_ids_json')) {
      context.handle(
        _completedExerciseIdsJsonMeta,
        completedExerciseIdsJson.isAcceptableOrUnknown(
          data['completed_exercise_ids_json']!,
          _completedExerciseIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('elapsed_seconds')) {
      context.handle(
        _elapsedSecondsMeta,
        elapsedSeconds.isAcceptableOrUnknown(
          data['elapsed_seconds']!,
          _elapsedSecondsMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {planId, dayId};
  @override
  ActiveSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveSession(
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      )!,
      dayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_id'],
      )!,
      planType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_type'],
      )!,
      planTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_title'],
      )!,
      dayTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_title'],
      )!,
      dayLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_level'],
      )!,
      dayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_index'],
      )!,
      totalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_days'],
      )!,
      completedExerciseIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_exercise_ids_json'],
      )!,
      elapsedSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elapsed_seconds'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ActiveSessionsTable createAlias(String alias) {
    return $ActiveSessionsTable(attachedDatabase, alias);
  }
}

class ActiveSession extends DataClass implements Insertable<ActiveSession> {
  final String planId;
  final String dayId;
  final String planType;
  final String planTitle;
  final String dayTitle;
  final String dayLevel;
  final int dayIndex;
  final int totalDays;

  /// JSON-encoded list of `"exerciseId#index"` keys — the same dedup key the
  /// player already uses, so resuming can't double-log an exercise.
  final String completedExerciseIdsJson;
  final int elapsedSeconds;
  final DateTime startedAt;
  final DateTime updatedAt;
  const ActiveSession({
    required this.planId,
    required this.dayId,
    required this.planType,
    required this.planTitle,
    required this.dayTitle,
    required this.dayLevel,
    required this.dayIndex,
    required this.totalDays,
    required this.completedExerciseIdsJson,
    required this.elapsedSeconds,
    required this.startedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['plan_id'] = Variable<String>(planId);
    map['day_id'] = Variable<String>(dayId);
    map['plan_type'] = Variable<String>(planType);
    map['plan_title'] = Variable<String>(planTitle);
    map['day_title'] = Variable<String>(dayTitle);
    map['day_level'] = Variable<String>(dayLevel);
    map['day_index'] = Variable<int>(dayIndex);
    map['total_days'] = Variable<int>(totalDays);
    map['completed_exercise_ids_json'] = Variable<String>(
      completedExerciseIdsJson,
    );
    map['elapsed_seconds'] = Variable<int>(elapsedSeconds);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ActiveSessionsCompanion toCompanion(bool nullToAbsent) {
    return ActiveSessionsCompanion(
      planId: Value(planId),
      dayId: Value(dayId),
      planType: Value(planType),
      planTitle: Value(planTitle),
      dayTitle: Value(dayTitle),
      dayLevel: Value(dayLevel),
      dayIndex: Value(dayIndex),
      totalDays: Value(totalDays),
      completedExerciseIdsJson: Value(completedExerciseIdsJson),
      elapsedSeconds: Value(elapsedSeconds),
      startedAt: Value(startedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ActiveSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveSession(
      planId: serializer.fromJson<String>(json['planId']),
      dayId: serializer.fromJson<String>(json['dayId']),
      planType: serializer.fromJson<String>(json['planType']),
      planTitle: serializer.fromJson<String>(json['planTitle']),
      dayTitle: serializer.fromJson<String>(json['dayTitle']),
      dayLevel: serializer.fromJson<String>(json['dayLevel']),
      dayIndex: serializer.fromJson<int>(json['dayIndex']),
      totalDays: serializer.fromJson<int>(json['totalDays']),
      completedExerciseIdsJson: serializer.fromJson<String>(
        json['completedExerciseIdsJson'],
      ),
      elapsedSeconds: serializer.fromJson<int>(json['elapsedSeconds']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'planId': serializer.toJson<String>(planId),
      'dayId': serializer.toJson<String>(dayId),
      'planType': serializer.toJson<String>(planType),
      'planTitle': serializer.toJson<String>(planTitle),
      'dayTitle': serializer.toJson<String>(dayTitle),
      'dayLevel': serializer.toJson<String>(dayLevel),
      'dayIndex': serializer.toJson<int>(dayIndex),
      'totalDays': serializer.toJson<int>(totalDays),
      'completedExerciseIdsJson': serializer.toJson<String>(
        completedExerciseIdsJson,
      ),
      'elapsedSeconds': serializer.toJson<int>(elapsedSeconds),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ActiveSession copyWith({
    String? planId,
    String? dayId,
    String? planType,
    String? planTitle,
    String? dayTitle,
    String? dayLevel,
    int? dayIndex,
    int? totalDays,
    String? completedExerciseIdsJson,
    int? elapsedSeconds,
    DateTime? startedAt,
    DateTime? updatedAt,
  }) => ActiveSession(
    planId: planId ?? this.planId,
    dayId: dayId ?? this.dayId,
    planType: planType ?? this.planType,
    planTitle: planTitle ?? this.planTitle,
    dayTitle: dayTitle ?? this.dayTitle,
    dayLevel: dayLevel ?? this.dayLevel,
    dayIndex: dayIndex ?? this.dayIndex,
    totalDays: totalDays ?? this.totalDays,
    completedExerciseIdsJson:
        completedExerciseIdsJson ?? this.completedExerciseIdsJson,
    elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    startedAt: startedAt ?? this.startedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ActiveSession copyWithCompanion(ActiveSessionsCompanion data) {
    return ActiveSession(
      planId: data.planId.present ? data.planId.value : this.planId,
      dayId: data.dayId.present ? data.dayId.value : this.dayId,
      planType: data.planType.present ? data.planType.value : this.planType,
      planTitle: data.planTitle.present ? data.planTitle.value : this.planTitle,
      dayTitle: data.dayTitle.present ? data.dayTitle.value : this.dayTitle,
      dayLevel: data.dayLevel.present ? data.dayLevel.value : this.dayLevel,
      dayIndex: data.dayIndex.present ? data.dayIndex.value : this.dayIndex,
      totalDays: data.totalDays.present ? data.totalDays.value : this.totalDays,
      completedExerciseIdsJson: data.completedExerciseIdsJson.present
          ? data.completedExerciseIdsJson.value
          : this.completedExerciseIdsJson,
      elapsedSeconds: data.elapsedSeconds.present
          ? data.elapsedSeconds.value
          : this.elapsedSeconds,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveSession(')
          ..write('planId: $planId, ')
          ..write('dayId: $dayId, ')
          ..write('planType: $planType, ')
          ..write('planTitle: $planTitle, ')
          ..write('dayTitle: $dayTitle, ')
          ..write('dayLevel: $dayLevel, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('totalDays: $totalDays, ')
          ..write('completedExerciseIdsJson: $completedExerciseIdsJson, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('startedAt: $startedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    planId,
    dayId,
    planType,
    planTitle,
    dayTitle,
    dayLevel,
    dayIndex,
    totalDays,
    completedExerciseIdsJson,
    elapsedSeconds,
    startedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveSession &&
          other.planId == this.planId &&
          other.dayId == this.dayId &&
          other.planType == this.planType &&
          other.planTitle == this.planTitle &&
          other.dayTitle == this.dayTitle &&
          other.dayLevel == this.dayLevel &&
          other.dayIndex == this.dayIndex &&
          other.totalDays == this.totalDays &&
          other.completedExerciseIdsJson == this.completedExerciseIdsJson &&
          other.elapsedSeconds == this.elapsedSeconds &&
          other.startedAt == this.startedAt &&
          other.updatedAt == this.updatedAt);
}

class ActiveSessionsCompanion extends UpdateCompanion<ActiveSession> {
  final Value<String> planId;
  final Value<String> dayId;
  final Value<String> planType;
  final Value<String> planTitle;
  final Value<String> dayTitle;
  final Value<String> dayLevel;
  final Value<int> dayIndex;
  final Value<int> totalDays;
  final Value<String> completedExerciseIdsJson;
  final Value<int> elapsedSeconds;
  final Value<DateTime> startedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ActiveSessionsCompanion({
    this.planId = const Value.absent(),
    this.dayId = const Value.absent(),
    this.planType = const Value.absent(),
    this.planTitle = const Value.absent(),
    this.dayTitle = const Value.absent(),
    this.dayLevel = const Value.absent(),
    this.dayIndex = const Value.absent(),
    this.totalDays = const Value.absent(),
    this.completedExerciseIdsJson = const Value.absent(),
    this.elapsedSeconds = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActiveSessionsCompanion.insert({
    required String planId,
    required String dayId,
    required String planType,
    required String planTitle,
    required String dayTitle,
    this.dayLevel = const Value.absent(),
    this.dayIndex = const Value.absent(),
    this.totalDays = const Value.absent(),
    this.completedExerciseIdsJson = const Value.absent(),
    this.elapsedSeconds = const Value.absent(),
    required DateTime startedAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : planId = Value(planId),
       dayId = Value(dayId),
       planType = Value(planType),
       planTitle = Value(planTitle),
       dayTitle = Value(dayTitle),
       startedAt = Value(startedAt),
       updatedAt = Value(updatedAt);
  static Insertable<ActiveSession> custom({
    Expression<String>? planId,
    Expression<String>? dayId,
    Expression<String>? planType,
    Expression<String>? planTitle,
    Expression<String>? dayTitle,
    Expression<String>? dayLevel,
    Expression<int>? dayIndex,
    Expression<int>? totalDays,
    Expression<String>? completedExerciseIdsJson,
    Expression<int>? elapsedSeconds,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (planId != null) 'plan_id': planId,
      if (dayId != null) 'day_id': dayId,
      if (planType != null) 'plan_type': planType,
      if (planTitle != null) 'plan_title': planTitle,
      if (dayTitle != null) 'day_title': dayTitle,
      if (dayLevel != null) 'day_level': dayLevel,
      if (dayIndex != null) 'day_index': dayIndex,
      if (totalDays != null) 'total_days': totalDays,
      if (completedExerciseIdsJson != null)
        'completed_exercise_ids_json': completedExerciseIdsJson,
      if (elapsedSeconds != null) 'elapsed_seconds': elapsedSeconds,
      if (startedAt != null) 'started_at': startedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActiveSessionsCompanion copyWith({
    Value<String>? planId,
    Value<String>? dayId,
    Value<String>? planType,
    Value<String>? planTitle,
    Value<String>? dayTitle,
    Value<String>? dayLevel,
    Value<int>? dayIndex,
    Value<int>? totalDays,
    Value<String>? completedExerciseIdsJson,
    Value<int>? elapsedSeconds,
    Value<DateTime>? startedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ActiveSessionsCompanion(
      planId: planId ?? this.planId,
      dayId: dayId ?? this.dayId,
      planType: planType ?? this.planType,
      planTitle: planTitle ?? this.planTitle,
      dayTitle: dayTitle ?? this.dayTitle,
      dayLevel: dayLevel ?? this.dayLevel,
      dayIndex: dayIndex ?? this.dayIndex,
      totalDays: totalDays ?? this.totalDays,
      completedExerciseIdsJson:
          completedExerciseIdsJson ?? this.completedExerciseIdsJson,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      startedAt: startedAt ?? this.startedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (dayId.present) {
      map['day_id'] = Variable<String>(dayId.value);
    }
    if (planType.present) {
      map['plan_type'] = Variable<String>(planType.value);
    }
    if (planTitle.present) {
      map['plan_title'] = Variable<String>(planTitle.value);
    }
    if (dayTitle.present) {
      map['day_title'] = Variable<String>(dayTitle.value);
    }
    if (dayLevel.present) {
      map['day_level'] = Variable<String>(dayLevel.value);
    }
    if (dayIndex.present) {
      map['day_index'] = Variable<int>(dayIndex.value);
    }
    if (totalDays.present) {
      map['total_days'] = Variable<int>(totalDays.value);
    }
    if (completedExerciseIdsJson.present) {
      map['completed_exercise_ids_json'] = Variable<String>(
        completedExerciseIdsJson.value,
      );
    }
    if (elapsedSeconds.present) {
      map['elapsed_seconds'] = Variable<int>(elapsedSeconds.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveSessionsCompanion(')
          ..write('planId: $planId, ')
          ..write('dayId: $dayId, ')
          ..write('planType: $planType, ')
          ..write('planTitle: $planTitle, ')
          ..write('dayTitle: $dayTitle, ')
          ..write('dayLevel: $dayLevel, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('totalDays: $totalDays, ')
          ..write('completedExerciseIdsJson: $completedExerciseIdsJson, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('startedAt: $startedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $WorkoutSettingsRowsTable workoutSettingsRows =
      $WorkoutSettingsRowsTable(this);
  late final $PlanProgressRowsTable planProgressRows = $PlanProgressRowsTable(
    this,
  );
  late final $SessionLogsTable sessionLogs = $SessionLogsTable(this);
  late final $ExerciseLogsTable exerciseLogs = $ExerciseLogsTable(this);
  late final $ExercisePreferencesTable exercisePreferences =
      $ExercisePreferencesTable(this);
  late final $ActiveSessionsTable activeSessions = $ActiveSessionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfiles,
    workoutSettingsRows,
    planProgressRows,
    sessionLogs,
    exerciseLogs,
    exercisePreferences,
    activeSessions,
  ];
}

typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<String> goal,
      Value<String> gender,
      Value<int> age,
      Value<int> heightCm,
      Value<int> weightKg,
      Value<int> targetWeightKg,
      Value<String> currentBodyShape,
      Value<String> targetBodyShape,
      Value<String> workoutPlace,
      Value<String> workoutLevel,
      Value<String> bellyHipType,
      Value<String> legType,
      Value<String> activitiesJson,
      Value<String> injuriesJson,
      Value<bool> onboardingComplete,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<String> goal,
      Value<String> gender,
      Value<int> age,
      Value<int> heightCm,
      Value<int> weightKg,
      Value<int> targetWeightKg,
      Value<String> currentBodyShape,
      Value<String> targetBodyShape,
      Value<String> workoutPlace,
      Value<String> workoutLevel,
      Value<String> bellyHipType,
      Value<String> legType,
      Value<String> activitiesJson,
      Value<String> injuriesJson,
      Value<bool> onboardingComplete,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentBodyShape => $composableBuilder(
    column: $table.currentBodyShape,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetBodyShape => $composableBuilder(
    column: $table.targetBodyShape,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workoutPlace => $composableBuilder(
    column: $table.workoutPlace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workoutLevel => $composableBuilder(
    column: $table.workoutLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bellyHipType => $composableBuilder(
    column: $table.bellyHipType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get legType => $composableBuilder(
    column: $table.legType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activitiesJson => $composableBuilder(
    column: $table.activitiesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get injuriesJson => $composableBuilder(
    column: $table.injuriesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentBodyShape => $composableBuilder(
    column: $table.currentBodyShape,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetBodyShape => $composableBuilder(
    column: $table.targetBodyShape,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workoutPlace => $composableBuilder(
    column: $table.workoutPlace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workoutLevel => $composableBuilder(
    column: $table.workoutLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bellyHipType => $composableBuilder(
    column: $table.bellyHipType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get legType => $composableBuilder(
    column: $table.legType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activitiesJson => $composableBuilder(
    column: $table.activitiesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get injuriesJson => $composableBuilder(
    column: $table.injuriesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<int> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<int> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currentBodyShape => $composableBuilder(
    column: $table.currentBodyShape,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetBodyShape => $composableBuilder(
    column: $table.targetBodyShape,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workoutPlace => $composableBuilder(
    column: $table.workoutPlace,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workoutLevel => $composableBuilder(
    column: $table.workoutLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bellyHipType => $composableBuilder(
    column: $table.bellyHipType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get legType =>
      $composableBuilder(column: $table.legType, builder: (column) => column);

  GeneratedColumn<String> get activitiesJson => $composableBuilder(
    column: $table.activitiesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get injuriesJson => $composableBuilder(
    column: $table.injuriesJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> goal = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<int> heightCm = const Value.absent(),
                Value<int> weightKg = const Value.absent(),
                Value<int> targetWeightKg = const Value.absent(),
                Value<String> currentBodyShape = const Value.absent(),
                Value<String> targetBodyShape = const Value.absent(),
                Value<String> workoutPlace = const Value.absent(),
                Value<String> workoutLevel = const Value.absent(),
                Value<String> bellyHipType = const Value.absent(),
                Value<String> legType = const Value.absent(),
                Value<String> activitiesJson = const Value.absent(),
                Value<String> injuriesJson = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                goal: goal,
                gender: gender,
                age: age,
                heightCm: heightCm,
                weightKg: weightKg,
                targetWeightKg: targetWeightKg,
                currentBodyShape: currentBodyShape,
                targetBodyShape: targetBodyShape,
                workoutPlace: workoutPlace,
                workoutLevel: workoutLevel,
                bellyHipType: bellyHipType,
                legType: legType,
                activitiesJson: activitiesJson,
                injuriesJson: injuriesJson,
                onboardingComplete: onboardingComplete,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> goal = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<int> heightCm = const Value.absent(),
                Value<int> weightKg = const Value.absent(),
                Value<int> targetWeightKg = const Value.absent(),
                Value<String> currentBodyShape = const Value.absent(),
                Value<String> targetBodyShape = const Value.absent(),
                Value<String> workoutPlace = const Value.absent(),
                Value<String> workoutLevel = const Value.absent(),
                Value<String> bellyHipType = const Value.absent(),
                Value<String> legType = const Value.absent(),
                Value<String> activitiesJson = const Value.absent(),
                Value<String> injuriesJson = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                goal: goal,
                gender: gender,
                age: age,
                heightCm: heightCm,
                weightKg: weightKg,
                targetWeightKg: targetWeightKg,
                currentBodyShape: currentBodyShape,
                targetBodyShape: targetBodyShape,
                workoutPlace: workoutPlace,
                workoutLevel: workoutLevel,
                bellyHipType: bellyHipType,
                legType: legType,
                activitiesJson: activitiesJson,
                injuriesJson: injuriesJson,
                onboardingComplete: onboardingComplete,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;
typedef $$WorkoutSettingsRowsTableCreateCompanionBuilder =
    WorkoutSettingsRowsCompanion Function({
      Value<int> id,
      Value<bool> voiceGuideEnabled,
      Value<bool> detailedGuide,
      Value<double> volume,
      Value<bool> soundEffectEnabled,
      Value<int> countdownSeconds,
    });
typedef $$WorkoutSettingsRowsTableUpdateCompanionBuilder =
    WorkoutSettingsRowsCompanion Function({
      Value<int> id,
      Value<bool> voiceGuideEnabled,
      Value<bool> detailedGuide,
      Value<double> volume,
      Value<bool> soundEffectEnabled,
      Value<int> countdownSeconds,
    });

class $$WorkoutSettingsRowsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSettingsRowsTable> {
  $$WorkoutSettingsRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get voiceGuideEnabled => $composableBuilder(
    column: $table.voiceGuideEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get detailedGuide => $composableBuilder(
    column: $table.detailedGuide,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get volume => $composableBuilder(
    column: $table.volume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get soundEffectEnabled => $composableBuilder(
    column: $table.soundEffectEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get countdownSeconds => $composableBuilder(
    column: $table.countdownSeconds,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkoutSettingsRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSettingsRowsTable> {
  $$WorkoutSettingsRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get voiceGuideEnabled => $composableBuilder(
    column: $table.voiceGuideEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get detailedGuide => $composableBuilder(
    column: $table.detailedGuide,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get volume => $composableBuilder(
    column: $table.volume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get soundEffectEnabled => $composableBuilder(
    column: $table.soundEffectEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get countdownSeconds => $composableBuilder(
    column: $table.countdownSeconds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutSettingsRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSettingsRowsTable> {
  $$WorkoutSettingsRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get voiceGuideEnabled => $composableBuilder(
    column: $table.voiceGuideEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get detailedGuide => $composableBuilder(
    column: $table.detailedGuide,
    builder: (column) => column,
  );

  GeneratedColumn<double> get volume =>
      $composableBuilder(column: $table.volume, builder: (column) => column);

  GeneratedColumn<bool> get soundEffectEnabled => $composableBuilder(
    column: $table.soundEffectEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get countdownSeconds => $composableBuilder(
    column: $table.countdownSeconds,
    builder: (column) => column,
  );
}

class $$WorkoutSettingsRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSettingsRowsTable,
          WorkoutSettingsRow,
          $$WorkoutSettingsRowsTableFilterComposer,
          $$WorkoutSettingsRowsTableOrderingComposer,
          $$WorkoutSettingsRowsTableAnnotationComposer,
          $$WorkoutSettingsRowsTableCreateCompanionBuilder,
          $$WorkoutSettingsRowsTableUpdateCompanionBuilder,
          (
            WorkoutSettingsRow,
            BaseReferences<
              _$AppDatabase,
              $WorkoutSettingsRowsTable,
              WorkoutSettingsRow
            >,
          ),
          WorkoutSettingsRow,
          PrefetchHooks Function()
        > {
  $$WorkoutSettingsRowsTableTableManager(
    _$AppDatabase db,
    $WorkoutSettingsRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSettingsRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSettingsRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WorkoutSettingsRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> voiceGuideEnabled = const Value.absent(),
                Value<bool> detailedGuide = const Value.absent(),
                Value<double> volume = const Value.absent(),
                Value<bool> soundEffectEnabled = const Value.absent(),
                Value<int> countdownSeconds = const Value.absent(),
              }) => WorkoutSettingsRowsCompanion(
                id: id,
                voiceGuideEnabled: voiceGuideEnabled,
                detailedGuide: detailedGuide,
                volume: volume,
                soundEffectEnabled: soundEffectEnabled,
                countdownSeconds: countdownSeconds,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> voiceGuideEnabled = const Value.absent(),
                Value<bool> detailedGuide = const Value.absent(),
                Value<double> volume = const Value.absent(),
                Value<bool> soundEffectEnabled = const Value.absent(),
                Value<int> countdownSeconds = const Value.absent(),
              }) => WorkoutSettingsRowsCompanion.insert(
                id: id,
                voiceGuideEnabled: voiceGuideEnabled,
                detailedGuide: detailedGuide,
                volume: volume,
                soundEffectEnabled: soundEffectEnabled,
                countdownSeconds: countdownSeconds,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkoutSettingsRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSettingsRowsTable,
      WorkoutSettingsRow,
      $$WorkoutSettingsRowsTableFilterComposer,
      $$WorkoutSettingsRowsTableOrderingComposer,
      $$WorkoutSettingsRowsTableAnnotationComposer,
      $$WorkoutSettingsRowsTableCreateCompanionBuilder,
      $$WorkoutSettingsRowsTableUpdateCompanionBuilder,
      (
        WorkoutSettingsRow,
        BaseReferences<
          _$AppDatabase,
          $WorkoutSettingsRowsTable,
          WorkoutSettingsRow
        >,
      ),
      WorkoutSettingsRow,
      PrefetchHooks Function()
    >;
typedef $$PlanProgressRowsTableCreateCompanionBuilder =
    PlanProgressRowsCompanion Function({
      required String planId,
      required String planType,
      required String planTitle,
      Value<int> currentDayIndex,
      Value<int> totalDays,
      Value<int> completedDays,
      Value<DateTime?> startedAt,
      Value<DateTime?> lastActivityAt,
      Value<int> rowid,
    });
typedef $$PlanProgressRowsTableUpdateCompanionBuilder =
    PlanProgressRowsCompanion Function({
      Value<String> planId,
      Value<String> planType,
      Value<String> planTitle,
      Value<int> currentDayIndex,
      Value<int> totalDays,
      Value<int> completedDays,
      Value<DateTime?> startedAt,
      Value<DateTime?> lastActivityAt,
      Value<int> rowid,
    });

class $$PlanProgressRowsTableFilterComposer
    extends Composer<_$AppDatabase, $PlanProgressRowsTable> {
  $$PlanProgressRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planType => $composableBuilder(
    column: $table.planType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planTitle => $composableBuilder(
    column: $table.planTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentDayIndex => $composableBuilder(
    column: $table.currentDayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDays => $composableBuilder(
    column: $table.totalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedDays => $composableBuilder(
    column: $table.completedDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastActivityAt => $composableBuilder(
    column: $table.lastActivityAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlanProgressRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanProgressRowsTable> {
  $$PlanProgressRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planType => $composableBuilder(
    column: $table.planType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planTitle => $composableBuilder(
    column: $table.planTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentDayIndex => $composableBuilder(
    column: $table.currentDayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDays => $composableBuilder(
    column: $table.totalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedDays => $composableBuilder(
    column: $table.completedDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastActivityAt => $composableBuilder(
    column: $table.lastActivityAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlanProgressRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanProgressRowsTable> {
  $$PlanProgressRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<String> get planType =>
      $composableBuilder(column: $table.planType, builder: (column) => column);

  GeneratedColumn<String> get planTitle =>
      $composableBuilder(column: $table.planTitle, builder: (column) => column);

  GeneratedColumn<int> get currentDayIndex => $composableBuilder(
    column: $table.currentDayIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalDays =>
      $composableBuilder(column: $table.totalDays, builder: (column) => column);

  GeneratedColumn<int> get completedDays => $composableBuilder(
    column: $table.completedDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastActivityAt => $composableBuilder(
    column: $table.lastActivityAt,
    builder: (column) => column,
  );
}

class $$PlanProgressRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanProgressRowsTable,
          PlanProgressRow,
          $$PlanProgressRowsTableFilterComposer,
          $$PlanProgressRowsTableOrderingComposer,
          $$PlanProgressRowsTableAnnotationComposer,
          $$PlanProgressRowsTableCreateCompanionBuilder,
          $$PlanProgressRowsTableUpdateCompanionBuilder,
          (
            PlanProgressRow,
            BaseReferences<
              _$AppDatabase,
              $PlanProgressRowsTable,
              PlanProgressRow
            >,
          ),
          PlanProgressRow,
          PrefetchHooks Function()
        > {
  $$PlanProgressRowsTableTableManager(
    _$AppDatabase db,
    $PlanProgressRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanProgressRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanProgressRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanProgressRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> planId = const Value.absent(),
                Value<String> planType = const Value.absent(),
                Value<String> planTitle = const Value.absent(),
                Value<int> currentDayIndex = const Value.absent(),
                Value<int> totalDays = const Value.absent(),
                Value<int> completedDays = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> lastActivityAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlanProgressRowsCompanion(
                planId: planId,
                planType: planType,
                planTitle: planTitle,
                currentDayIndex: currentDayIndex,
                totalDays: totalDays,
                completedDays: completedDays,
                startedAt: startedAt,
                lastActivityAt: lastActivityAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String planId,
                required String planType,
                required String planTitle,
                Value<int> currentDayIndex = const Value.absent(),
                Value<int> totalDays = const Value.absent(),
                Value<int> completedDays = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> lastActivityAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlanProgressRowsCompanion.insert(
                planId: planId,
                planType: planType,
                planTitle: planTitle,
                currentDayIndex: currentDayIndex,
                totalDays: totalDays,
                completedDays: completedDays,
                startedAt: startedAt,
                lastActivityAt: lastActivityAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlanProgressRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanProgressRowsTable,
      PlanProgressRow,
      $$PlanProgressRowsTableFilterComposer,
      $$PlanProgressRowsTableOrderingComposer,
      $$PlanProgressRowsTableAnnotationComposer,
      $$PlanProgressRowsTableCreateCompanionBuilder,
      $$PlanProgressRowsTableUpdateCompanionBuilder,
      (
        PlanProgressRow,
        BaseReferences<_$AppDatabase, $PlanProgressRowsTable, PlanProgressRow>,
      ),
      PlanProgressRow,
      PrefetchHooks Function()
    >;
typedef $$SessionLogsTableCreateCompanionBuilder =
    SessionLogsCompanion Function({
      Value<int> id,
      required String planId,
      required String planType,
      required String planTitle,
      required String dayId,
      required String dayTitle,
      Value<String> dayLevel,
      Value<int> dayIndex,
      Value<int> exercisesCompleted,
      Value<int> exercisesTotal,
      Value<int> durationSeconds,
      Value<int> calories,
      Value<bool> completed,
      Value<String> thumbnailUrl,
      required DateTime startedAt,
      required DateTime completedAt,
    });
typedef $$SessionLogsTableUpdateCompanionBuilder =
    SessionLogsCompanion Function({
      Value<int> id,
      Value<String> planId,
      Value<String> planType,
      Value<String> planTitle,
      Value<String> dayId,
      Value<String> dayTitle,
      Value<String> dayLevel,
      Value<int> dayIndex,
      Value<int> exercisesCompleted,
      Value<int> exercisesTotal,
      Value<int> durationSeconds,
      Value<int> calories,
      Value<bool> completed,
      Value<String> thumbnailUrl,
      Value<DateTime> startedAt,
      Value<DateTime> completedAt,
    });

class $$SessionLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionLogsTable> {
  $$SessionLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planType => $composableBuilder(
    column: $table.planType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planTitle => $composableBuilder(
    column: $table.planTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayTitle => $composableBuilder(
    column: $table.dayTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayLevel => $composableBuilder(
    column: $table.dayLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exercisesCompleted => $composableBuilder(
    column: $table.exercisesCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exercisesTotal => $composableBuilder(
    column: $table.exercisesTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionLogsTable> {
  $$SessionLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planType => $composableBuilder(
    column: $table.planType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planTitle => $composableBuilder(
    column: $table.planTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayTitle => $composableBuilder(
    column: $table.dayTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayLevel => $composableBuilder(
    column: $table.dayLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exercisesCompleted => $composableBuilder(
    column: $table.exercisesCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exercisesTotal => $composableBuilder(
    column: $table.exercisesTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionLogsTable> {
  $$SessionLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<String> get planType =>
      $composableBuilder(column: $table.planType, builder: (column) => column);

  GeneratedColumn<String> get planTitle =>
      $composableBuilder(column: $table.planTitle, builder: (column) => column);

  GeneratedColumn<String> get dayId =>
      $composableBuilder(column: $table.dayId, builder: (column) => column);

  GeneratedColumn<String> get dayTitle =>
      $composableBuilder(column: $table.dayTitle, builder: (column) => column);

  GeneratedColumn<String> get dayLevel =>
      $composableBuilder(column: $table.dayLevel, builder: (column) => column);

  GeneratedColumn<int> get dayIndex =>
      $composableBuilder(column: $table.dayIndex, builder: (column) => column);

  GeneratedColumn<int> get exercisesCompleted => $composableBuilder(
    column: $table.exercisesCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get exercisesTotal => $composableBuilder(
    column: $table.exercisesTotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$SessionLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionLogsTable,
          SessionLog,
          $$SessionLogsTableFilterComposer,
          $$SessionLogsTableOrderingComposer,
          $$SessionLogsTableAnnotationComposer,
          $$SessionLogsTableCreateCompanionBuilder,
          $$SessionLogsTableUpdateCompanionBuilder,
          (
            SessionLog,
            BaseReferences<_$AppDatabase, $SessionLogsTable, SessionLog>,
          ),
          SessionLog,
          PrefetchHooks Function()
        > {
  $$SessionLogsTableTableManager(_$AppDatabase db, $SessionLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> planId = const Value.absent(),
                Value<String> planType = const Value.absent(),
                Value<String> planTitle = const Value.absent(),
                Value<String> dayId = const Value.absent(),
                Value<String> dayTitle = const Value.absent(),
                Value<String> dayLevel = const Value.absent(),
                Value<int> dayIndex = const Value.absent(),
                Value<int> exercisesCompleted = const Value.absent(),
                Value<int> exercisesTotal = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<String> thumbnailUrl = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
              }) => SessionLogsCompanion(
                id: id,
                planId: planId,
                planType: planType,
                planTitle: planTitle,
                dayId: dayId,
                dayTitle: dayTitle,
                dayLevel: dayLevel,
                dayIndex: dayIndex,
                exercisesCompleted: exercisesCompleted,
                exercisesTotal: exercisesTotal,
                durationSeconds: durationSeconds,
                calories: calories,
                completed: completed,
                thumbnailUrl: thumbnailUrl,
                startedAt: startedAt,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String planId,
                required String planType,
                required String planTitle,
                required String dayId,
                required String dayTitle,
                Value<String> dayLevel = const Value.absent(),
                Value<int> dayIndex = const Value.absent(),
                Value<int> exercisesCompleted = const Value.absent(),
                Value<int> exercisesTotal = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<String> thumbnailUrl = const Value.absent(),
                required DateTime startedAt,
                required DateTime completedAt,
              }) => SessionLogsCompanion.insert(
                id: id,
                planId: planId,
                planType: planType,
                planTitle: planTitle,
                dayId: dayId,
                dayTitle: dayTitle,
                dayLevel: dayLevel,
                dayIndex: dayIndex,
                exercisesCompleted: exercisesCompleted,
                exercisesTotal: exercisesTotal,
                durationSeconds: durationSeconds,
                calories: calories,
                completed: completed,
                thumbnailUrl: thumbnailUrl,
                startedAt: startedAt,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionLogsTable,
      SessionLog,
      $$SessionLogsTableFilterComposer,
      $$SessionLogsTableOrderingComposer,
      $$SessionLogsTableAnnotationComposer,
      $$SessionLogsTableCreateCompanionBuilder,
      $$SessionLogsTableUpdateCompanionBuilder,
      (
        SessionLog,
        BaseReferences<_$AppDatabase, $SessionLogsTable, SessionLog>,
      ),
      SessionLog,
      PrefetchHooks Function()
    >;
typedef $$ExerciseLogsTableCreateCompanionBuilder =
    ExerciseLogsCompanion Function({
      Value<int> id,
      Value<int?> sessionLogId,
      required String exerciseId,
      required String title,
      Value<int> durationSeconds,
      Value<int> calories,
      Value<String> thumbnailUrl,
      required DateTime completedAt,
    });
typedef $$ExerciseLogsTableUpdateCompanionBuilder =
    ExerciseLogsCompanion Function({
      Value<int> id,
      Value<int?> sessionLogId,
      Value<String> exerciseId,
      Value<String> title,
      Value<int> durationSeconds,
      Value<int> calories,
      Value<String> thumbnailUrl,
      Value<DateTime> completedAt,
    });

class $$ExerciseLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseLogsTable> {
  $$ExerciseLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionLogId => $composableBuilder(
    column: $table.sessionLogId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExerciseLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseLogsTable> {
  $$ExerciseLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionLogId => $composableBuilder(
    column: $table.sessionLogId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExerciseLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseLogsTable> {
  $$ExerciseLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sessionLogId => $composableBuilder(
    column: $table.sessionLogId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$ExerciseLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseLogsTable,
          ExerciseLog,
          $$ExerciseLogsTableFilterComposer,
          $$ExerciseLogsTableOrderingComposer,
          $$ExerciseLogsTableAnnotationComposer,
          $$ExerciseLogsTableCreateCompanionBuilder,
          $$ExerciseLogsTableUpdateCompanionBuilder,
          (
            ExerciseLog,
            BaseReferences<_$AppDatabase, $ExerciseLogsTable, ExerciseLog>,
          ),
          ExerciseLog,
          PrefetchHooks Function()
        > {
  $$ExerciseLogsTableTableManager(_$AppDatabase db, $ExerciseLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> sessionLogId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<String> thumbnailUrl = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
              }) => ExerciseLogsCompanion(
                id: id,
                sessionLogId: sessionLogId,
                exerciseId: exerciseId,
                title: title,
                durationSeconds: durationSeconds,
                calories: calories,
                thumbnailUrl: thumbnailUrl,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> sessionLogId = const Value.absent(),
                required String exerciseId,
                required String title,
                Value<int> durationSeconds = const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<String> thumbnailUrl = const Value.absent(),
                required DateTime completedAt,
              }) => ExerciseLogsCompanion.insert(
                id: id,
                sessionLogId: sessionLogId,
                exerciseId: exerciseId,
                title: title,
                durationSeconds: durationSeconds,
                calories: calories,
                thumbnailUrl: thumbnailUrl,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExerciseLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseLogsTable,
      ExerciseLog,
      $$ExerciseLogsTableFilterComposer,
      $$ExerciseLogsTableOrderingComposer,
      $$ExerciseLogsTableAnnotationComposer,
      $$ExerciseLogsTableCreateCompanionBuilder,
      $$ExerciseLogsTableUpdateCompanionBuilder,
      (
        ExerciseLog,
        BaseReferences<_$AppDatabase, $ExerciseLogsTable, ExerciseLog>,
      ),
      ExerciseLog,
      PrefetchHooks Function()
    >;
typedef $$ExercisePreferencesTableCreateCompanionBuilder =
    ExercisePreferencesCompanion Function({
      required String exerciseId,
      required int durationSeconds,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$ExercisePreferencesTableUpdateCompanionBuilder =
    ExercisePreferencesCompanion Function({
      Value<String> exerciseId,
      Value<int> durationSeconds,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$ExercisePreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisePreferencesTable> {
  $$ExercisePreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExercisePreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisePreferencesTable> {
  $$ExercisePreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExercisePreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisePreferencesTable> {
  $$ExercisePreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ExercisePreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisePreferencesTable,
          ExercisePreference,
          $$ExercisePreferencesTableFilterComposer,
          $$ExercisePreferencesTableOrderingComposer,
          $$ExercisePreferencesTableAnnotationComposer,
          $$ExercisePreferencesTableCreateCompanionBuilder,
          $$ExercisePreferencesTableUpdateCompanionBuilder,
          (
            ExercisePreference,
            BaseReferences<
              _$AppDatabase,
              $ExercisePreferencesTable,
              ExercisePreference
            >,
          ),
          ExercisePreference,
          PrefetchHooks Function()
        > {
  $$ExercisePreferencesTableTableManager(
    _$AppDatabase db,
    $ExercisePreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisePreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisePreferencesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ExercisePreferencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> exerciseId = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisePreferencesCompanion(
                exerciseId: exerciseId,
                durationSeconds: durationSeconds,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String exerciseId,
                required int durationSeconds,
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisePreferencesCompanion.insert(
                exerciseId: exerciseId,
                durationSeconds: durationSeconds,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExercisePreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisePreferencesTable,
      ExercisePreference,
      $$ExercisePreferencesTableFilterComposer,
      $$ExercisePreferencesTableOrderingComposer,
      $$ExercisePreferencesTableAnnotationComposer,
      $$ExercisePreferencesTableCreateCompanionBuilder,
      $$ExercisePreferencesTableUpdateCompanionBuilder,
      (
        ExercisePreference,
        BaseReferences<
          _$AppDatabase,
          $ExercisePreferencesTable,
          ExercisePreference
        >,
      ),
      ExercisePreference,
      PrefetchHooks Function()
    >;
typedef $$ActiveSessionsTableCreateCompanionBuilder =
    ActiveSessionsCompanion Function({
      required String planId,
      required String dayId,
      required String planType,
      required String planTitle,
      required String dayTitle,
      Value<String> dayLevel,
      Value<int> dayIndex,
      Value<int> totalDays,
      Value<String> completedExerciseIdsJson,
      Value<int> elapsedSeconds,
      required DateTime startedAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ActiveSessionsTableUpdateCompanionBuilder =
    ActiveSessionsCompanion Function({
      Value<String> planId,
      Value<String> dayId,
      Value<String> planType,
      Value<String> planTitle,
      Value<String> dayTitle,
      Value<String> dayLevel,
      Value<int> dayIndex,
      Value<int> totalDays,
      Value<String> completedExerciseIdsJson,
      Value<int> elapsedSeconds,
      Value<DateTime> startedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ActiveSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ActiveSessionsTable> {
  $$ActiveSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planType => $composableBuilder(
    column: $table.planType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planTitle => $composableBuilder(
    column: $table.planTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayTitle => $composableBuilder(
    column: $table.dayTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayLevel => $composableBuilder(
    column: $table.dayLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDays => $composableBuilder(
    column: $table.totalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedExerciseIdsJson => $composableBuilder(
    column: $table.completedExerciseIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActiveSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActiveSessionsTable> {
  $$ActiveSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planType => $composableBuilder(
    column: $table.planType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planTitle => $composableBuilder(
    column: $table.planTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayTitle => $composableBuilder(
    column: $table.dayTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayLevel => $composableBuilder(
    column: $table.dayLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDays => $composableBuilder(
    column: $table.totalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedExerciseIdsJson => $composableBuilder(
    column: $table.completedExerciseIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActiveSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActiveSessionsTable> {
  $$ActiveSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<String> get dayId =>
      $composableBuilder(column: $table.dayId, builder: (column) => column);

  GeneratedColumn<String> get planType =>
      $composableBuilder(column: $table.planType, builder: (column) => column);

  GeneratedColumn<String> get planTitle =>
      $composableBuilder(column: $table.planTitle, builder: (column) => column);

  GeneratedColumn<String> get dayTitle =>
      $composableBuilder(column: $table.dayTitle, builder: (column) => column);

  GeneratedColumn<String> get dayLevel =>
      $composableBuilder(column: $table.dayLevel, builder: (column) => column);

  GeneratedColumn<int> get dayIndex =>
      $composableBuilder(column: $table.dayIndex, builder: (column) => column);

  GeneratedColumn<int> get totalDays =>
      $composableBuilder(column: $table.totalDays, builder: (column) => column);

  GeneratedColumn<String> get completedExerciseIdsJson => $composableBuilder(
    column: $table.completedExerciseIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ActiveSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActiveSessionsTable,
          ActiveSession,
          $$ActiveSessionsTableFilterComposer,
          $$ActiveSessionsTableOrderingComposer,
          $$ActiveSessionsTableAnnotationComposer,
          $$ActiveSessionsTableCreateCompanionBuilder,
          $$ActiveSessionsTableUpdateCompanionBuilder,
          (
            ActiveSession,
            BaseReferences<_$AppDatabase, $ActiveSessionsTable, ActiveSession>,
          ),
          ActiveSession,
          PrefetchHooks Function()
        > {
  $$ActiveSessionsTableTableManager(
    _$AppDatabase db,
    $ActiveSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActiveSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActiveSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> planId = const Value.absent(),
                Value<String> dayId = const Value.absent(),
                Value<String> planType = const Value.absent(),
                Value<String> planTitle = const Value.absent(),
                Value<String> dayTitle = const Value.absent(),
                Value<String> dayLevel = const Value.absent(),
                Value<int> dayIndex = const Value.absent(),
                Value<int> totalDays = const Value.absent(),
                Value<String> completedExerciseIdsJson = const Value.absent(),
                Value<int> elapsedSeconds = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActiveSessionsCompanion(
                planId: planId,
                dayId: dayId,
                planType: planType,
                planTitle: planTitle,
                dayTitle: dayTitle,
                dayLevel: dayLevel,
                dayIndex: dayIndex,
                totalDays: totalDays,
                completedExerciseIdsJson: completedExerciseIdsJson,
                elapsedSeconds: elapsedSeconds,
                startedAt: startedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String planId,
                required String dayId,
                required String planType,
                required String planTitle,
                required String dayTitle,
                Value<String> dayLevel = const Value.absent(),
                Value<int> dayIndex = const Value.absent(),
                Value<int> totalDays = const Value.absent(),
                Value<String> completedExerciseIdsJson = const Value.absent(),
                Value<int> elapsedSeconds = const Value.absent(),
                required DateTime startedAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ActiveSessionsCompanion.insert(
                planId: planId,
                dayId: dayId,
                planType: planType,
                planTitle: planTitle,
                dayTitle: dayTitle,
                dayLevel: dayLevel,
                dayIndex: dayIndex,
                totalDays: totalDays,
                completedExerciseIdsJson: completedExerciseIdsJson,
                elapsedSeconds: elapsedSeconds,
                startedAt: startedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActiveSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActiveSessionsTable,
      ActiveSession,
      $$ActiveSessionsTableFilterComposer,
      $$ActiveSessionsTableOrderingComposer,
      $$ActiveSessionsTableAnnotationComposer,
      $$ActiveSessionsTableCreateCompanionBuilder,
      $$ActiveSessionsTableUpdateCompanionBuilder,
      (
        ActiveSession,
        BaseReferences<_$AppDatabase, $ActiveSessionsTable, ActiveSession>,
      ),
      ActiveSession,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$WorkoutSettingsRowsTableTableManager get workoutSettingsRows =>
      $$WorkoutSettingsRowsTableTableManager(_db, _db.workoutSettingsRows);
  $$PlanProgressRowsTableTableManager get planProgressRows =>
      $$PlanProgressRowsTableTableManager(_db, _db.planProgressRows);
  $$SessionLogsTableTableManager get sessionLogs =>
      $$SessionLogsTableTableManager(_db, _db.sessionLogs);
  $$ExerciseLogsTableTableManager get exerciseLogs =>
      $$ExerciseLogsTableTableManager(_db, _db.exerciseLogs);
  $$ExercisePreferencesTableTableManager get exercisePreferences =>
      $$ExercisePreferencesTableTableManager(_db, _db.exercisePreferences);
  $$ActiveSessionsTableTableManager get activeSessions =>
      $$ActiveSessionsTableTableManager(_db, _db.activeSessions);
}
