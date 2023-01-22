import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../../const.dart';
import '../../../../../../domain/entities/reply/reply_entity.dart';
import '../../../../../widgets/profile_widget.dart';

class SingleReplyWidget extends StatefulWidget {
  final ReplyEntity reply;
  final String currentUid;
  final VoidCallback? onLikeClickListener;
  final VoidCallback? onMoreClickListener;

  const SingleReplyWidget({
    Key? key,
    required this.reply,
    required this.currentUid,
    this.onLikeClickListener,
    this.onMoreClickListener,
  }) : super(key: key);

  @override
  State<SingleReplyWidget> createState() => _SingleReplyWidgetState();
}

class _SingleReplyWidgetState extends State<SingleReplyWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // [SizedBox]: Image profile
        SizedBox(
          width: 30,
          height: 30,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: profileWidget(
              imageUrl: widget.reply.userProfileUrl,
            ),
          ),
        ),

        // [Column]: username, description, likes, totalLikes,
        AppSize.sizeHor(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Username & Date
              Row(
                children: [
                  Text(
                    "${widget.reply.username} • ",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    DateFormat("dd/MMM/yyy")
                        .format(widget.reply.createAt!.toDate()),
                    // "01/Jan/2000",
                  ),
                ],
              ),
              AppSize.sizeVer(2),

              // Description
              Text(
                // NOTE: Maximum comment length 500
                "${widget.reply.description}",
                style: TextStyle(
                  color: AppColor.primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              AppSize.sizeVer(10),

              // Like, totalLikes
              Row(
                children: [
                  InkWell(
                    onTap: widget.onLikeClickListener,
                    child: Icon(
                      widget.reply.likes!.contains(widget.currentUid)
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      color: widget.reply.likes!.contains(widget.currentUid)
                          ? Colors.red
                          : AppColor.primaryColor,
                    ),
                  ),
                  AppSize.sizeHor(5),
                  widget.reply.totalLikes != 0
                      ? Text("${widget.reply.totalLikes}")
                      : const SizedBox(),
                ],
              ),
              AppSize.sizeVer(10),
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
    );
  }
}
