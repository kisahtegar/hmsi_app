import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../const.dart';
import '../../../../../domain/entities/event/event_entity.dart';
import '../../../../../domain/entities/user/user_entity.dart';
import '../../../../cubits/event/event_cubit.dart';
import '../../../../cubits/event/get_single_event/get_single_event_cubit.dart';
import '../../../../widgets/more_menu_button_widget.dart';
import '../../../../widgets/profile_widget.dart';

class EventInfoPage extends StatefulWidget {
  final EventEntity eventEntity;
  final UserEntity userEntity;
  const EventInfoPage({
    super.key,
    required this.eventEntity,
    required this.userEntity,
  });

  @override
  State<EventInfoPage> createState() => _EventInfoPageState();
}

class _EventInfoPageState extends State<EventInfoPage> {
  @override
  void initState() {
    BlocProvider.of<GetSingleEventCubit>(context)
        .getSingleEvent(eventId: widget.eventEntity.eventId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<GetSingleEventCubit, GetSingleEventState>(
      builder: (context, singleEventState) {
        if (singleEventState is GetSingleEventLoaded) {
          final singleEvent = singleEventState.event;
          return _bodyWidget(size, singleEvent);
        }
        return loadingIndicator();
      },
    );
  }

  /// This widget is body page
  Widget _bodyWidget(Size size, EventEntity event) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            // [Row]: Row of Type event, Date, modal bottom sheet.
            Row(
              children: [
                // Type Event
                Container(
                  decoration: BoxDecoration(
                    color: _eventTypeColor(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Text(
                      "${event.type}",
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
                  DateFormat("EEE MMM d'rd' • ").format(event.date!.toDate()) +
                      DateFormat("HH:mm a").format(event.time!.toDate()),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.036,
                  ),
                ),

                // Show modal bottom sheet
                const Spacer(),
                widget.eventEntity.creatorUid == widget.userEntity.uid
                    ? GestureDetector(
                        onTap: () =>
                            _showModalBottomSheetOptions(context, event),
                        child: Icon(
                          Icons.more_vert,
                          color: AppColor.primaryColor,
                          size: size.width * 0.06,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),

            // [Column]: Column of Title, Total Interested, Created by, Location, Link, Description.
            AppSize.sizeVer(8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Event
                Text(
                  "${event.title}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.06,
                  ),
                ),
                AppSize.sizeVer(15),

                // Location Event
                event.location != ""
                    ? Row(
                        children: [
                          Icon(
                            Icons.place,
                            size: size.width * 0.065,
                            color: Colors.red,
                          ),
                          AppSize.sizeHor(5),
                          Text(
                            "${event.location}",
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
                event.location != "" ? AppSize.sizeVer(6) : const SizedBox(),
                event.link != ""
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
                              text: "${event.link}",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                                fontSize: size.width * 0.045,
                                color: Colors.blue,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  openUrl('${event.link}');
                                },
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),

                // Total Interested
                event.location != ""
                    ? AppSize.sizeVer(6)
                    : event.link != ""
                        ? AppSize.sizeVer(6)
                        : const SizedBox(),
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: size.width * 0.065,
                      color: AppColor.primaryColor,
                    ),
                    AppSize.sizeHor(5),
                    Text(
                      event.totalInterested == 0
                          ? "${event.totalInterested} person are interested"
                          : "${event.totalInterested} person is interested",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: size.width * 0.045,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ],
                ),

                // Created By
                AppSize.sizeVer(6),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.065,
                      height: size.width * 0.065,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: profileWidget(imageUrl: event.userProfileUrl),
                      ),
                    ),
                    AppSize.sizeHor(5),
                    RichText(
                      text: TextSpan(
                        text: "Created by ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: size.width * 0.045,
                          color: AppColor.primaryColor,
                        ),
                        children: [
                          TextSpan(
                            text: "${event.name}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: size.width * 0.045,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Description Event
                AppSize.sizeVer(15),
                Text(
                  "${event.description}",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: size.width * 0.045,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            // [Button]: Interested.
            AppSize.sizeVer(15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Material(
                child: InkWell(
                  onTap: _interestedEvent,
                  child: Ink(
                    width: double.infinity,
                    color: event.interested!.contains(widget.userEntity.uid)
                        ? Colors.grey
                        : Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Center(
                        child: Text(
                          event.interested!.contains(widget.userEntity.uid)
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

  /// Custome event type color
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

  /// Showing modal bottom sheet for options
  void _showModalBottomSheetOptions(BuildContext context, EventEntity event) {
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
                "More Options",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColor.primaryColor,
                ),
              ),
              AppSize.sizeVer(9),
              const Divider(thickness: 1),

              // Edit Event button.
              MoreMenuButtonWidget(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    PageConst.editEventPage,
                    arguments: event,
                  );
                },
                icon: Icons.edit,
                text: "Edit Event",
                iconColor: AppColor.primaryColor,
                textColor: AppColor.primaryColor,
              ),

              // Delete Event button.
              MoreMenuButtonWidget(
                onTap: () {
                  _deleteEvent(eventEntity: event);
                },
                icon: Icons.delete,
                text: "Delete Event",
                iconColor: Colors.red,
                textColor: Colors.red,
              ),
            ],
          ),
        ]);
      },
    );
  }

  /// Delete Event
  _deleteEvent({required EventEntity eventEntity}) {
    Navigator.pop(context);
    BlocProvider.of<EventCubit>(context)
        .deleteEvent(
          eventEntity: EventEntity(
            eventId: eventEntity.eventId,
          ),
        )
        .then((_) => Navigator.pop(context));
  }
}
