import 'package:meediary/data_models/post.dart';

class PostService{
  List<Post> posts = [];

  void post(Post post){
    posts.insert(0, post);
  }
}