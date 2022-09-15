import 'package:posts_offline_first/domain/comment/models/post_model.dart';
import 'package:posts_offline_first/domain/helper/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class LocalPostsRepository {
  var databaseFuture = DataBaseHelper.db.database;
  static const POST_TABLE_NAME = 'post';

  Future<List<Post>> getAllPosts() async {
    late final List<Post> postsList;
    final Database database = await databaseFuture;

    final postsMap = await database.query(POST_TABLE_NAME);
    postsList = postsMap.map((post) => Post.fromJson(post)).toList();
    print(postsList);
    return postsList;
  }

  Future<void> updateLocalPostDatatable(List<Post> postList) async {
    final Database database = await databaseFuture;
    Batch batch = database.batch();
    postList.forEach((post) async {
      batch.insert(
        POST_TABLE_NAME,
        post.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    batch.commit();
    print('db updated!');
  }
}
