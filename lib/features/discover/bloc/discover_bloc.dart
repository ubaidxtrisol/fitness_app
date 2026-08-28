import 'package:equatable/equatable.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:fitness_app/features/discover/services/discover_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'discover_event.dart';
part 'discover_state.dart';

/// Owns the Discover catalogue's load/refresh state so the screen never
/// needs `setState` — [DiscoverRepository] does the actual network/cache/
/// bundled-asset work, this just turns its result (or its exceptions) into
/// [DiscoverState].
class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  DiscoverBloc({DiscoverRepository? repository})
    : _repository = repository ?? DiscoverRepository(),
      super(const DiscoverState()) {
    on<DiscoverCategoriesRequested>(_onRequested);
    on<DiscoverCategoriesRefreshed>(_onRefreshed);
  }

  final DiscoverRepository _repository;

  Future<void> _onRequested(
    DiscoverCategoriesRequested event,
    Emitter<DiscoverState> emit,
  ) async {
    // A previous successful load is still good to show while this one is in
    // flight — only show the empty-state skeleton when there's nothing yet.
    emit(state.copyWith(status: DiscoverStatus.loading));
    await _load(forceRefresh: false, emit: emit);
  }

  Future<void> _onRefreshed(
    DiscoverCategoriesRefreshed event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(state.copyWith(status: DiscoverStatus.refreshing));
    await _load(forceRefresh: true, emit: emit);
  }

  Future<void> _load({
    required bool forceRefresh,
    required Emitter<DiscoverState> emit,
  }) async {
    try {
      final result = await _repository.getCategories(forceRefresh: forceRefresh);
      emit(
        state.copyWith(
          status: DiscoverStatus.success,
          categories: result.categories,
          source: result.source,
          notice: result.notice,
          clearNotice: result.notice == null,
          clearError: true,
        ),
      );
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          status: DiscoverStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: DiscoverStatus.failure,
          errorMessage: const UnknownApiException().message,
        ),
      );
    }
  }
}
