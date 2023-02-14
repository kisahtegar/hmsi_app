import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../injection_container.dart' as di;
import '../../../../../domain/entities/event/event_entity.dart';
import '../../../../cubits/event/event_cubit.dart';
import 'widget/edit_event_main_widget.dart';

class EditEventPage extends StatelessWidget {
  final EventEntity event;
  const EditEventPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventCubit>.value(
      value: di.sl<EventCubit>(),
      child: EditEventMainWidget(event: event),
    );
  }
}
