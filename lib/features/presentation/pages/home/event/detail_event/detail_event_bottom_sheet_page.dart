import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../const.dart';
import '../../../../../../injection_container.dart' as di;
import '../../../../../domain/entities/event/event_entity.dart';
import '../../../../../domain/entities/user/user_entity.dart';
import '../../../../cubits/event/event_cubit.dart';
import '../../../../cubits/event/get_single_event/get_single_event_cubit.dart';
import '../../../../widgets/custom_tab_bar_widget.dart';
import 'event_info_page.dart';
import 'interested_page.dart';

class DetailEventBottomSheetPage extends StatefulWidget {
  final EventEntity eventEntity;
  final UserEntity userEntity;

  const DetailEventBottomSheetPage({
    super.key,
    required this.eventEntity,
    required this.userEntity,
  });

  @override
  State<DetailEventBottomSheetPage> createState() =>
      _DetailEventBottomSheetPageState();
}

class _DetailEventBottomSheetPageState
    extends State<DetailEventBottomSheetPage> {
  int _currentPageIndex = 0;
  final PageController _pageViewController = PageController(initialPage: 0);

  List<Widget> get _pages => [
        EventInfoPage(
          eventEntity: widget.eventEntity,
          userEntity: widget.userEntity,
        ),
        InterestedPage(
          eventEntity: widget.eventEntity,
        ),
      ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag trigger bottomsheet
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

          // [Row]: Detail Event title and close Detail Event.
          AppSize.sizeVer(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Detail Event",
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

          // [CostumTabBar]: Costum tab bar to change pageview.
          CustomTabBar(index: _currentPageIndex),

          // [PageView]: Page View
          SizedBox(
            width: double.infinity,
            height: 500,
            child: PageView.builder(
              itemCount: _pages.length,
              controller: _pageViewController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemBuilder: (_, index) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<EventCubit>(
                      create: (context) => di.sl<EventCubit>(),
                    ),
                    BlocProvider<GetSingleEventCubit>(
                      create: (context) => di.sl<GetSingleEventCubit>(),
                    ),
                  ],
                  child: _pages[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
