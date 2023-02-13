import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../const.dart';
import '../../../../../domain/entities/event/event_entity.dart';
import '../../../../../domain/entities/user/user_entity.dart';

import '../../../../cubits/event/event_cubit.dart';
import '../detail_event/detail_event_bottom_sheet_page.dart';

class SingleEventWidget extends StatefulWidget {
  final EventEntity eventEntity;
  final UserEntity currentUser;

  const SingleEventWidget({
    super.key,
    required this.eventEntity,
    required this.currentUser,
  });

  @override
  State<SingleEventWidget> createState() => _SingleEventWidgetState();
}

class _SingleEventWidgetState extends State<SingleEventWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(5, 10),
              blurRadius: 10,
              color: AppColor.gradientSecond.withOpacity(0.3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // [Row]: Row of Type event, Date, Total participant.
              Row(
                children: [
                  // Type Event
                  Container(
                    decoration: BoxDecoration(
                      color: _eventTypeColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Text(
                        "${widget.eventEntity.type}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.036,
                        ),
                      ),
                    ),
                  ),

                  // Date Event
                  AppSize.sizeHor(6),
                  Text(
                    DateFormat("EEE MMM d'rd' • ")
                            .format(widget.eventEntity.date!.toDate()) +
                        DateFormat("HH:mm a")
                            .format(widget.eventEntity.time!.toDate()),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: size.width * 0.036,
                    ),
                  ),

                  // Total Participant Event
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          Icon(
                            Icons.people,
                            color: Colors.white,
                            size: size.width * 0.05,
                          ),
                          AppSize.sizeHor(2),
                          Text(
                            "${widget.eventEntity.totalInterested}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.04,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // [Column]: Column of Title, Description, Location, Link.
              AppSize.sizeVer(8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Description (onTap)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          builder: (_) {
                            return DetailEventBottomSheetPage(
                              eventEntity: widget.eventEntity,
                              userEntity: widget.currentUser,
                            );
                          },
                        );
                      },
                      child: Ink(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title Event
                            Text(
                              "${widget.eventEntity.title}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.06,
                              ),
                            ),

                            // Description Event
                            AppSize.sizeVer(6),
                            Text(
                              widget.eventEntity.description!.length > 150
                                  ? "${widget.eventEntity.description!.substring(0, 150)}..."
                                  : widget.eventEntity.description!,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: size.width * 0.045,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Location Event
                  AppSize.sizeVer(6),
                  widget.eventEntity.location != ""
                      ? Row(
                          children: [
                            Icon(
                              Icons.place,
                              size: size.width * 0.065,
                              color: Colors.red,
                            ),
                            AppSize.sizeHor(5),
                            Text(
                              "${widget.eventEntity.location}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: size.width * 0.045,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),

                  // Link Event
                  AppSize.sizeVer(6),
                  widget.eventEntity.link != ""
                      ? Row(
                          children: [
                            Icon(
                              Icons.link,
                              size: size.width * 0.065,
                              color: Colors.blue,
                            ),
                            AppSize.sizeHor(5),
                            RichText(
                              text: TextSpan(
                                text: "${widget.eventEntity.link}",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.width * 0.045,
                                  color: Colors.blue,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    openUrl('${widget.eventEntity.link}');
                                  },
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),

              // [Button]: Interested.
              AppSize.sizeVer(8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Material(
                  child: InkWell(
                    onTap: _interestedEvent,
                    child: Ink(
                      width: double.infinity,
                      color: widget.eventEntity.interested!
                              .contains(widget.currentUser.uid)
                          ? Colors.grey
                          : Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Center(
                          child: Text(
                            widget.eventEntity.interested!
                                    .contains(widget.currentUser.uid)
                                ? "Cancel"
                                : "Interested",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.05,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Interested Event Button.
  void _interestedEvent() {
    BlocProvider.of<EventCubit>(context).interestedEvent(
      eventEntity: EventEntity(
        eventId: widget.eventEntity.eventId,
      ),
    );
  }

  /// Custome event type color.
  Color _eventTypeColor() {
    if (widget.eventEntity.type == "Meeting") {
      return Colors.green;
    }
    if (widget.eventEntity.type == "On-Meeting") {
      return Colors.amber;
    }
    if (widget.eventEntity.type == "Gather") {
      return Colors.redAccent;
    }
    if (widget.eventEntity.type == "Training") {
      return Colors.deepPurple;
    }
    return Colors.blue;
  }
}
