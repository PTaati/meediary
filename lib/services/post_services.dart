import 'package:meediary/data_models/post.dart';
import 'package:meediary/objectbox.g.dart';

class PostService{
  PostService(this.postBox, this.posts);

  Box<Post> postBox;
  List<Post> posts = [];

  void post(Post post){
    postBox.put(post);
    posts.insert(0, post);
  }
}