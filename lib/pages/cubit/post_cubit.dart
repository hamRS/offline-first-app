import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:meta/meta.dart';
import 'package:posts_offline_first/domain/comment/models/post_model.dart';
import 'package:posts_offline_first/services/local_posts_repo.dart';
import 'package:posts_offline_first/services/remote_post_repo.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final RemotePostRepository remotePostRepository;
  final LocalPostsRepository localPostsRepository;
  Connectivity connectivity;

  PostCubit(
      this.remotePostRepository, this.localPostsRepository, this.connectivity)
      : super(PostInitial());

  Future<void> getPostList() async {
    final connectivityStatus = await connectivity.checkConnectivity();
    print(connectivityStatus);
    if (connectivityStatus == ConnectivityResult.none) {
      getLocalPostList();
    } else {
      getRemotePostList();
    }
  }

  Future<void> getLocalPostList() async {
    try {
      emit(PostLoading());
      await Future.delayed(Duration(milliseconds: 500));
      final result = await localPostsRepository.getAllPosts();
      print(result);
      emit(LocalPostLoaded(postList: result));
    } catch (error) {
      print(error);
      emit(PostError());
    }
  }

  Future<void> getRemotePostList() async {
    try {
      emit(PostLoading());
      await Future.delayed(Duration(milliseconds: 500));
      var result = await remotePostRepository.getAllPosts();
      await Future.delayed(Duration(milliseconds: 500));
      emit(RemotePostLoaded(postList: result));
    } catch (error) {
      emit(PostError());
    }
  }

  Future<void> updateLocalPostDatabase(List<Post> postList) async {
    try {
      await localPostsRepository.updateLocalPostDatatable(postList);
      emit(LocalPostSync());
    } catch (error) {
      emit(PostError());
    }
  }
}
