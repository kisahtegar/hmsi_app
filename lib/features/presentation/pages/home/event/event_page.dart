import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../const.dart';
import '../../../../../injection_container.dart' as di;
import '../../../../domain/entities/event/event_entity.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../../cubits/event/event_cubit.dart';
import '../../../widgets/no_page_widget.dart';
import 'widget/single_event_widget.dart';

class EventPage extends StatelessWidget {
  final UserEntity currentUser;
  const EventPage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    debugPrint("EventPage[build]: Building!!");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        titleSpacing: 2,
        title: Text(
          "Events",
          style: TextStyle(
            color: AppColor.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.close, size: 32, color: AppColor.primaryColor),
        ),
        actions: [
          currentUser.role == "admin"
              ? Padding(
                  padding:
                      const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            PageConst.createEventPage,
                            arguments: currentUser,
                          );
                        },
                        child: Ink(
                          color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Create Event",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
      body: BlocProvider<EventCubit>(
        create: (context) =>
            di.sl<EventCubit>()..getEvents(eventEntity: const EventEntity()),
        child: BlocBuilder<EventCubit, EventState>(
          builder: (context, eventState) {
            if (eventState is EventLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            }
            if (eventState is EventFailure) {
              toast("Some failure occured while creating the article");
            }
            if (eventState is EventLoaded) {
              return eventState.events.isEmpty
                  ? noPageWidget(
                      // TODO: NEED TO CHECK SIZING
                      title: "There are no upcoming events.",
                      titleSize: size.width * 0.05,
                      description:
                          "There is no events at this time, \nplease come back later.",
                      descriptionSize: 15,
                      icon: Icons.people,
                    )
                  : ListView.builder(
                      itemCount: eventState.events.length,
                      itemBuilder: (context, index) {
                        final event = eventState.events[index];
                        return SingleEventWidget(
                          eventEntity: event,
                          currentUser: currentUser,
                        );
                      },
                    );
            }
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          },
        ),
      ),
    );
  }
}
