import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmsi_app/features/domain/entities/app_entity.dart';
import 'package:hmsi_app/features/domain/entities/reply/reply_entity.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../../const.dart';
import '../../../../../../domain/entities/comment/comment_entity.dart';
import '../../../../../../domain/entities/user/user_entity.dart';
import '../../../../../cubits/comment/comment_cubit.dart';
import '../../../../../cubits/reply/reply_cubit.dart';
import '../../../../../cubits/user/get_single_user/get_single_user_cubit.dart';
import '../../../../../widgets/more_menu_button_widget.dart';
import '../../../../../widgets/profile_widget.dart';
import 'package:hmsi_app/injection_container.dart' as di;

import 'single_comment_widget.dart';

class CommentBottomSheet extends StatefulWidget {
  final AppEntity appEntity;
  final BuildContext context;

  const CommentBottomSheet(
      {super.key, required this.appEntity, required this.context});

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();
  bool _isReply = false;
  late CommentEntity _singleComment;
  late FocusNode _textFieldFocus;

  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(uid: widget.appEntity.uid!);
    BlocProvider.of<CommentCubit>(context)
        .getComments(articleId: widget.appEntity.articleId!);
    _replyController.addListener(() {
      setState(() {});
    });
    _commentController.addListener(() {
      setState(() {});
    });
    _textFieldFocus = FocusNode();
    _singleComment = const CommentEntity();
    super.initState();
  }

  @override
  void dispose() {
    _textFieldFocus.dispose();
    _commentController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("_singleComment: $_singleComment");
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, singleUserState) {
        if (singleUserState is GetSingleUserLoaded) {
          final singleUser = singleUserState.user;
          return BlocBuilder<CommentCubit, CommentState>(
            builder: (context, commentState) {
              if (commentState is CommentLoaded) {
                final commentArticle = commentState.comments;
                return Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(widget.context).padding.top,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // [Row]: Comment title and close comment.
                      AppSize.sizeVer(15),
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      AppSize.sizeVer(10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Comment",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColor.primaryColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.close,
                                size: 28,
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppSize.sizeVer(9),
                      const Divider(thickness: 1),

                      // [List]: Comment output.
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: commentArticle.length,
                          itemBuilder: (context, index) {
                            final singleComment = commentArticle[index];
                            return SingleCommentWidget(
                              comment: singleComment,
                              currentUser: singleUser,
                              onLikeClickListener: () =>
                                  _likeComment(comment: singleComment),
                              onMoreClickListener: () =>
                                  _showModalBottomSheetMore(
                                context: context,
                                comment: singleComment,
                              ),
                              onReplyClickListener: () {
                                setState(() {
                                  _singleComment = singleComment;
                                  _isReply = true;
                                });
                                _textFieldFocus.requestFocus();
                              },
                            );
                          },
                        ),
                      ),

                      // [Container]: Card for closing reply selection.
                      _isReply
                          ? Container(
                              width: double.infinity,
                              color: Colors.grey,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Reply to ${_singleComment.username}",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _isReply = false;
                                          _commentController.clear();
                                          _replyController.clear();
                                          // _singleComment.
                                        });
                                      },
                                      child: const Icon(
                                        Icons.close,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(),

                      // [TextField]: Comment form.
                      const Divider(thickness: 1, height: 0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 31,
                              height: 31,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: profileWidget(
                                  imageUrl: singleUser.profileUrl,
                                ),
                              ),
                            ),
                            AppSize.sizeHor(15),
                            Expanded(
                              child: TextFormField(
                                controller: _isReply
                                    ? _replyController
                                    : _commentController,
                                focusNode: _textFieldFocus,
                                decoration: InputDecoration(
                                  hintText:
                                      _isReply ? "Add reply" : "Add comments",
                                  border: InputBorder.none,
                                  suffixIcon: _isReply
                                      ? _replyController.text.isNotEmpty
                                          ? InkWell(
                                              onTap: () {
                                                _createReply(
                                                  currentUser: singleUser,
                                                  comment: _singleComment,
                                                );
                                              },
                                              child: const Icon(
                                                Icons.send,
                                                color: Colors.blue,
                                              ),
                                            )
                                          : null
                                      : _commentController.text.isNotEmpty
                                          ? InkWell(
                                              onTap: () {
                                                _createComment(singleUser);
                                              },
                                              child: const Icon(
                                                Icons.send,
                                                color: Colors.blue,
                                              ),
                                            )
                                          : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
          );
        }
        return Container();
      },
    );
  }

  // [Comment Features]
  _createComment(UserEntity currentUser) {
    BlocProvider.of<CommentCubit>(context)
        .createComment(
      commentEntity: CommentEntity(
        commentId: const Uuid().v1(),
        articleId: widget.appEntity.articleId,
        creatorUid: currentUser.uid,
        description: _commentController.text,
        username: currentUser.username,
        userProfileUrl: currentUser.profileUrl,
        createAt: Timestamp.now(),
        likes: const [],
        totalLikes: 0,
        totalReply: 0,
      ),
    )
        .then((value) {
      setState(() {
        _commentController.clear();
        FocusScope.of(context).unfocus();
      });
    });
  }

  _likeComment({required CommentEntity comment}) {
    BlocProvider.of<CommentCubit>(context).likeComment(
      commentEntity: CommentEntity(
        articleId: comment.articleId,
        commentId: comment.commentId,
      ),
    );
  }

  _deleteComment({required CommentEntity comment}) {
    BlocProvider.of<CommentCubit>(context)
        .deleteComment(
          commentEntity: CommentEntity(
            articleId: comment.articleId,
            commentId: comment.commentId,
          ),
        )
        .then((_) => Navigator.pop(context));
  }

  // [Reply Features]
  _createReply(
      {required UserEntity currentUser, required CommentEntity comment}) {
    BlocProvider.of<ReplyCubit>(context)
        .createReply(
      replyEntity: ReplyEntity(
        replyId: const Uuid().v1(),
        commentId: comment.commentId,
        articleId: comment.articleId,
        creatorUid: currentUser.uid,
        description: _replyController.text,
        username: currentUser.username,
        userProfileUrl: currentUser.profileUrl,
        createAt: Timestamp.now(),
        likes: const [],
        totalLikes: 0,
      ),
    )
        .then((value) {
      setState(() {
        _replyController.clear();
        _isReply = false;
      });
    });
  }

  void _showModalBottomSheetMore(
      {required BuildContext context, required CommentEntity comment}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Wrap(children: [
          Column(
            children: [
              AppSize.sizeVer(15),
              Text(
                "Comment Options",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColor.primaryColor,
                ),
              ),
              AppSize.sizeVer(9),
              const Divider(thickness: 1),
              MoreMenuButtonWidget(
                onTap: () {
                  _deleteComment(comment: comment);
                },
                icon: Icons.delete,
                text: "Delete Comment",
                iconColor: Colors.red,
                textColor: Colors.red,
              ),
            ],
          ),
        ]);
      },
    );
  }
}
