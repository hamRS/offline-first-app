import 'dart:async';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_offline_first/domain/comment/models/post_model.dart';
import 'package:posts_offline_first/pages/cubit/post_cubit.dart';
import 'package:posts_offline_first/services/local_posts_repo.dart';
import 'package:posts_offline_first/services/remote_post_repo.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final PostCubit postCubit;
  late final RemotePostRepository _remotePostRepository;
  late final LocalPostsRepository _localPostsRepository;
  late Connectivity _connectivity;

  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  initState() {
    _remotePostRepository = RemotePostRepository();
    _localPostsRepository = LocalPostsRepository();
    _connectivity = Connectivity();

    postCubit = PostCubit(
      _remotePostRepository,
      _localPostsRepository,
      _connectivity,
    );
    getConnectionStatus();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  Future<void> getConnectionStatus() async {
    _connectivityResult = await _connectivity.checkConnectivity();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.mobile &&
            _connectivityResult == ConnectivityResult.wifi ||
        _connectivityResult == ConnectivityResult.mobile &&
            result == ConnectivityResult.wifi) {
      _connectivityResult = result;
      postCubit.connectivity = Connectivity();
    } else {
      postCubit.getPostList();
      _connectivityResult = result;
      postCubit.connectivity = Connectivity();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post List'),
      ),
      body: Container(
        child: BlocConsumer(
          bloc: postCubit,
          listener: (context, state) async {
            if (state is RemotePostLoaded) {
              print('hello there');
              _localPostsRepository.updateLocalPostDatatable(state.postList);
            }
          },
          builder: (context, state) {
            if (state is PostLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is LocalPostLoaded) {
              return HomePageBody(
                postList: state.postList,
                isOffline: true,
              );
            }

            if (state is RemotePostLoaded) {
              return HomePageBody(
                postList: state.postList,
              );
            }

            if (state is PostError) {
              return Center(
                child: Text('Error!'),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }

  @override
  dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }
}

class HomePageBody extends StatelessWidget {
  final List<Post> postList;
  bool isOffline;
  HomePageBody({required this.postList, this.isOffline = false});

  @override
  Widget build(BuildContext context) {
    if (postList.length == 0) {
      return Center(
        child: Text('No hay comentarios'),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: postList.length,
            itemBuilder: (context, index) {
              final post = postList[index];
              return Container(
                padding: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color.fromARGB(255, 226, 154, 149),
                      ),
                      child: Center(
                        child: Text(post.id.toString()),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            post.body,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
