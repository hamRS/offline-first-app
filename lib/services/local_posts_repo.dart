import 'package:posts_offline_first/domain/comment/models/post_model.dart';
import 'package:posts_offline_first/domain/helper/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class LocalPostsRepository {
  var db = DataBaseConnect();
  static const POST_TABLE_NAME = 'post';

  Future<List<Post>> getAllPosts() async {
    late final List<Post> postsList;

    final postsMap = await db.getAllPosts();
    postsList = postsMap.map((post) => Post.fromJson(post)).toList();
    return postsList;
  }

  Future<void> updateLocalPostDatatable(List<Post> postList) async {
    final database = await db.database;
    Batch batch = database.batch();
    postList.forEach((post) async {
      print(post.id);
      batch.insert(
        POST_TABLE_NAME,
        post.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    batch.commit();
    database.close();
    print('db updated!');
  }
}
