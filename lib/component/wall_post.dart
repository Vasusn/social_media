import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/component/comment.dart';
import 'package:social_media/component/comment_button.dart';
import 'package:social_media/component/like_button.dart';

import '../helper/helper_method.dart';
import 'delete_button.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;

  const WallPost(
      {super.key,
      required this.message,
      required this.user,
      required this.postId,
      required this.likes,
      required this.time});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

//toggle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    //Access the document is firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  //add comment
  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now()
    });
  }

//show a diloug box
  void showCommentDialog() {
    showDialog(
        context: context,
        builder: (contect) => AlertDialog(
              title: const Text("Add Comment"),
              content: TextField(
                controller: _commentTextController,
                decoration:
                    const InputDecoration(hintText: "write a comment..."),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _commentTextController.clear();
                    },
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () {
                      addComment(_commentTextController.text);

                      Navigator.pop(context);
                      _commentTextController.clear();
                    },
                    child: const Text("Post")),
              ],
            ));
  }

  //delete post
  void deletePost() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete Post'),
              content: const Text("Are you sure you want to delete this post?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () async {
                      final commentData = await FirebaseFirestore.instance
                          .collection("User Posts")
                          .doc(widget.postId)
                          .collection("Comments")
                          .get();

                      for (var doc in commentData.docs) {
                        await FirebaseFirestore.instance
                            .collection("User Posts")
                            .doc(widget.postId)
                            .collection("Comments")
                            .doc(doc.id)
                            .delete();
                      }
                      await FirebaseFirestore.instance
                          .collection("User Posts")
                          .doc(widget.postId)
                          .delete()
                          .then((value) => print("delete"));

                      Navigator.pop(context);
                    },
                    child: const Text("Delete")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //wallpost
          Row(
            children: [
              //group of text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.message),
                  const SizedBox(
                    height: 5,
                  ),

                  //user
                  SizedBox(
                    width: 236,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user,
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 15),
                          ),
                          Text(
                            " • ",
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 13),
                          ),
                          Text(
                            widget.time,
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),

              //delete button
              if (widget.user == currentUser.email)
                DeleteButton(onTap: deletePost)
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          //button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //like
              Column(
                children: [
                  //like button
                  LikeButton(isLiked: isLiked, onTap: toggleLike),

                  const SizedBox(
                    height: 5,
                  ),
                  //like count
                  Text(
                    widget.likes.length.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(
                width: 10,
              ),

              //comment
              Column(
                children: [
                  //comment button
                  CommentButton(onTap: showCommentDialog),

                  const SizedBox(
                    height: 5,
                  ),
                  //like count
                  const Text(
                    "0",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          //comment under post
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("User Posts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy('CommentTime', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  final commentData = doc.data() as Map<String, dynamic>;
                  return Comment(
                      text: commentData['CommentText'],
                      user: commentData['CommentedBy'],
                      time: formatDate(commentData['CommentTime']));
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}
