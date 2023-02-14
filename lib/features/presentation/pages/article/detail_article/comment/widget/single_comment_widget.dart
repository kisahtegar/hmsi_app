import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../../const.dart';
import '../../../../../../../injection_container.dart' as di;
import '../../../../../../domain/entities/comment/comment_entity.dart';
import '../../../../../../domain/entities/reply/reply_entity.dart';
import '../../../../../../domain/entities/user/user_entity.dart';
import '../../../../../../domain/usecases/user/get_current_uid_usecase.dart';
import '../../../../../cubits/reply/reply_cubit.dart';
import '../../../../../widgets/more_menu_button_widget.dart';
import '../../../../../widgets/profile_widget.dart';
import 'single_reply_widget.dart';

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final UserEntity? currentUser;
  final VoidCallback? onMoreClickListener;
  final VoidCallback? onLikeClickListener;
  final VoidCallback? onReplyClickListener;

  const SingleCommentWidget({
    Key? key,
    required this.comment,
    this.currentUser,
    this.onMoreClickListener,
    this.onLikeClickListener,
    this.onReplyClickListener,
  }) : super(key: key);

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  String _currentUid = "";
  bool _isViewReplys = false;

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      if (mounted) {
        setState(() {
          _currentUid = value;
        });
      }
    });
    BlocProvider.of<ReplyCubit>(context).getReplys(
      replyEntity: ReplyEntity(
        articleId: widget.comment.articleId,
        commentId: widget.comment.commentId,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // [SizedBox]: Image profile
          SizedBox(
            width: 30,
            height: 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: profileWidget(
                imageUrl: widget.comment.userProfileUrl,
              ),
            ),
          ),

          // [Column]: username, description, likes, totalLikes, reply, total reply.
          AppSize.sizeHor(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username & Date
                Row(
                  children: [
                    Text(
                      "${widget.comment.username} • ",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      DateFormat("dd/MMM/yyy")
                          .format(widget.comment.createAt!.toDate()),
                    ),
                  ],
                ),
                AppSize.sizeVer(2),

                // Description
                Text(
                  // NOTE: Maximum comment length 500
                  "${widget.comment.description}",
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                AppSize.sizeVer(10),

                // like, totalLikes, reply
                Row(
                  children: [
                    InkWell(
                      onTap: widget.onLikeClickListener,
                      child: Icon(
                        widget.comment.likes!.contains(_currentUid)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: widget.comment.likes!.contains(_currentUid)
                            ? Colors.red
                            : AppColor.primaryColor,
                      ),
                    ),
                    AppSize.sizeHor(5),
                    widget.comment.totalLikes != 0
                        ? Text("${widget.comment.totalLikes}")
                        : const SizedBox(),
                    AppSize.sizeHor(15),
                    InkWell(
                      onTap: widget.onReplyClickListener,
                      child: const Text("Reply"),
                    ),
                  ],
                ),

                // view reply
                widget.comment.totalReply != 0
                    ? AppSize.sizeVer(10)
                    : const SizedBox(),
                widget.comment.totalReply != 0
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            _isViewReplys = !_isViewReplys;
                          });
                          BlocProvider.of<ReplyCubit>(context).getReplys(
                            replyEntity: ReplyEntity(
                              articleId: widget.comment.articleId,
                              commentId: widget.comment.commentId,
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 1,
                              width: 30,
                              color: Colors.blue,
                            ),
                            Text(
                              _isViewReplys
                                  ? " Close view replys"
                                  : " View ${widget.comment.totalReply} replys",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),

                // [Container]: Reply section
                _isViewReplys ? AppSize.sizeVer(10) : const SizedBox(),
                _isViewReplys
                    ? BlocBuilder<ReplyCubit, ReplyState>(
                        builder: (context, replyState) {
                          if (replyState is ReplyLoaded) {
                            final replys = replyState.replys
                                .where((element) =>
                                    element.commentId ==
                                    widget.comment.commentId)
                                .toList();

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: replys.length,
                              itemBuilder: (context, index) {
                                return SingleReplyWidget(
                                  reply: replys[index],
                                  currentUid: _currentUid,
                                  onLikeClickListener: () {
                                    _likeReply(reply: replys[index]);
                                  },
                                  onMoreClickListener: () {
                                    _showModalBottomSheetMore(
                                      context: context,
                                      reply: replys[index],
                                    );
                                  },
                                );
                              },
                            );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      )
                    : const SizedBox(),
                // _isViewReplys ? SingleReplyWidget() : const SizedBox(),
              ],
            ),
          ),

          // [Button]: more button
          AppSize.sizeHor(10),
          InkWell(
            onTap: widget.onMoreClickListener,
            child: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }

  _likeReply({required ReplyEntity reply}) {
    BlocProvider.of<ReplyCubit>(context).likeReply(
      replyEntity: ReplyEntity(
        articleId: reply.articleId,
        commentId: reply.commentId,
        replyId: reply.replyId,
      ),
    );
  }

  _deleteReply({required ReplyEntity reply}) {
    BlocProvider.of<ReplyCubit>(context)
        .deleteReply(
          replyEntity: ReplyEntity(
            articleId: reply.articleId,
            commentId: reply.commentId,
            replyId: reply.replyId,
          ),
        )
        .then((_) => Navigator.pop(context));
  }

  void _showModalBottomSheetMore(
      {required BuildContext context, required ReplyEntity reply}) {
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
                  _deleteReply(reply: reply);
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
