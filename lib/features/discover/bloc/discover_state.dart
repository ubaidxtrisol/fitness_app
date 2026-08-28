part of 'discover_bloc.dart';

enum DiscoverStatus {
  /// Nothing loaded yet, no request in flight.
  initial,

  /// First load — [DiscoverState.categories] is empty, show the skeleton.
  loading,

  /// Pull-to-refresh — [DiscoverState.categories] already has the previous
  /// list, keep showing it under the refresh spinner.
  refreshing,
  success,
  failure,
}

class DiscoverState extends Equatable {
  final DiscoverStatus status;
  final List<CategoryModel> categories;
  final DiscoverDataSource source;

  /// Non-fatal context shown as a small banner — set when [source] isn't
  /// network (offline cache / bundled fallback).
  final String? notice;

  /// Set only on [DiscoverStatus.failure] with nothing to show at all.
  final String? errorMessage;

  const DiscoverState({
    this.status = DiscoverStatus.initial,
    this.categories = const [],
    this.source = DiscoverDataSource.network,
    this.notice,
    this.errorMessage,
  });

  DiscoverState copyWith({
    DiscoverStatus? status,
    List<CategoryModel>? categories,
    DiscoverDataSource? source,
    String? notice,
    bool clearNotice = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DiscoverState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      source: source ?? this.source,
      notice: clearNotice ? null : (notice ?? this.notice),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, categories, source, notice, errorMessage];
}
