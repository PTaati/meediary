import 'package:flutter/material.dart';
import 'package:meediary/data_models/post.dart';
import 'package:meediary/objectbox.g.dart';

class PostService with ChangeNotifier{
  PostService(this.postBox, this.posts);

  Box<Post> postBox;
  List<Post> posts = [];

  void post(Post post){
    postBox.put(post);
    posts.insert(0, post);
    notifyListeners();
  }

  void updatePost(Post post) {
    postBox.put(post);
    notifyListeners();
  }

  void deletePost(Post post) {
    postBox.remove(post.id);
    posts = postBox.getAll().reversed.toList();
    notifyListeners();
  }
}