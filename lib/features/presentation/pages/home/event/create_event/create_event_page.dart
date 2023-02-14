import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../injection_container.dart' as di;
import '../../../../../domain/entities/user/user_entity.dart';
import '../../../../cubits/event/event_cubit.dart';
import 'widget/create_event_main_widget.dart';

class CreateEventPage extends StatelessWidget {
  final UserEntity currentUser;
  const CreateEventPage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventCubit>(
      create: (context) => di.sl<EventCubit>(),
      child: CreateEventMainWidget(currentUser: currentUser),
    );
  }
}
