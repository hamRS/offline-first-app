part of 'post_cubit.dart';

@immutable
abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class RemotePostLoading extends PostState {}

class RemotePostLoaded extends PostState {
  final List<Post> postList;
  RemotePostLoaded({required this.postList});
}

class LocalPostLoaded extends PostState {
  final List<Post> postList;
  LocalPostLoaded({required this.postList});
}

class LocalPostSync extends PostState {}

class PostError extends PostState {}
