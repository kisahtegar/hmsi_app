import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../const.dart';
import '../../../../../../injection_container.dart' as di;
import '../../../../../domain/entities/event/event_entity.dart';
import '../../../../../domain/entities/user/user_entity.dart';
import '../../../../../domain/usecases/user/get_single_user_usecase.dart';
import '../../../../cubits/event/get_single_event/get_single_event_cubit.dart';
import '../../../../widgets/no_page_widget.dart';
import '../../../../widgets/profile_widget.dart';

class InterestedPage extends StatefulWidget {
  final EventEntity eventEntity;
  const InterestedPage({
    super.key,
    required this.eventEntity,
  });

  @override
  State<InterestedPage> createState() => _InterestedPageState();
}

class _InterestedPageState extends State<InterestedPage> {
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
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: singleEvent.interested!.isEmpty
                ? noPageWidget(
                    title: "No one's interested in this event yet.",
                    titleSize: size.width * 0.05,
                    icon: Icons.people,
                  )
                : ListView.builder(
                    itemCount: singleEvent.interested!.length,
                    itemBuilder: (context, index) {
                      return StreamBuilder<List<UserEntity>>(
                        stream: di
                            .sl<GetSingleUserUseCase>()
                            .call(singleEvent.interested?[index] ?? ''),
                        builder: (context, snapshot) {
                          if (snapshot.hasData == false) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.data!.isEmpty) {
                            return noPageWidget(
                              title: "No one's interested in this event yet.",
                              titleSize: size.width * 0.05,
                              icon: Icons.people,
                            );
                          }
                          return ListTile(
                            leading: SizedBox(
                              width: size.width * 0.09,
                              height: size.width * 0.09,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: profileWidget(
                                  imageUrl:
                                      snapshot.data?.first.profileUrl ?? '',
                                ),
                              ),
                            ),
                            title: Text(
                              snapshot.data?.first.name ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: size.width * 0.045,
                                color: Colors.black87,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          );
        }
        return loadingIndicator();
      },
    );
  }
}
