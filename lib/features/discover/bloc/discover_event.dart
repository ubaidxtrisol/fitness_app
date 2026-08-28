part of 'discover_bloc.dart';

sealed class DiscoverEvent extends Equatable {
  const DiscoverEvent();

  @override
  List<Object?> get props => [];
}

/// Fired once when the screen first mounts. Cheap to re-fire — the
/// repository's `ETag` short-circuit means a redundant call costs a 304, not
/// a full re-download.
class DiscoverCategoriesRequested extends DiscoverEvent {
  const DiscoverCategoriesRequested();
}

/// Pull-to-refresh — skips the `ETag` short-circuit so a real edit on the
/// backend is picked up immediately instead of waiting out a 304.
class DiscoverCategoriesRefreshed extends DiscoverEvent {
  const DiscoverCategoriesRefreshed();
}
