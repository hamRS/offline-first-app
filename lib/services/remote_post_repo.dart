import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:posts_offline_first/domain/helper/db_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../domain/comment/models/post_model.dart';

class RemotePostRepository {
  final client = http.Client();
  var databaseFuture = DataBaseHelper.db.database;
  static const POST_TABLE_NAME = 'post';
  static const POST_API_URL = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<Post>> getAllPosts() async {
    late final List<Post> postList;
    final Database database = await databaseFuture;

    final Uri uri = Uri.parse(POST_API_URL);
    Response res = await client.get(uri);
    if (res.statusCode == 200) {
      var json = res.body;
      postList = postFromJson(json);
    } else {
      //fetch local repo
      final PostJson = await database.query(POST_TABLE_NAME);
      postList = PostJson.map((post) => Post.fromJson(post)).toList();
    }

    return postList;
  }
}
