import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../const.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Material(
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      PageConst.createEventPage,
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
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // [Row]: Row of Type event, Date, Total participant.
                    Row(
                      children: [
                        // Type Event
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Text(
                              'Gather',
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
                          "Fri Feb 14rd • 11:45 PM",
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
                                  "0",
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
                        // Title Event
                        Text(
                          "Title Event",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.06,
                          ),
                        ),

                        // Description Event
                        AppSize.sizeVer(6),
                        Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: size.width * 0.045,
                            color: Colors.black87,
                          ),
                        ),

                        // Location Event
                        AppSize.sizeVer(6),
                        Row(
                          children: [
                            Icon(
                              Icons.place,
                              size: size.width * 0.065,
                              color: Colors.red,
                            ),
                            AppSize.sizeHor(5),
                            Text(
                              "Jl. jalan aja deh",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: size.width * 0.045,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        // Link Event
                        AppSize.sizeVer(6),
                        Row(
                          children: [
                            Icon(
                              Icons.link,
                              size: size.width * 0.065,
                              color: Colors.blue,
                            ),
                            AppSize.sizeHor(5),
                            RichText(
                              text: TextSpan(
                                text: "Link Testing...",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.width * 0.045,
                                  color: Colors.blue,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // [Button]: Follow,
                    AppSize.sizeVer(8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Material(
                        child: InkWell(
                          onTap: () {},
                          child: Ink(
                            width: double.infinity,
                            color: Colors.blue,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Center(
                                child: Text(
                                  "Follow",
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
          ),
        ],
      ),
    );
  }

  Widget _noEventsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: 130,
              height: 130,
              child: Stack(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Icon(
                      FontAwesomeIcons.solidSun,
                      color: Colors.yellow,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        FontAwesomeIcons.calendar,
                        color: Colors.black,
                        size: 50,
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      FontAwesomeIcons.solidMoon,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppSize.sizeVer(25),
          const Text(
            "There are no upcoming events.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              // color: ,
            ),
          ),
          AppSize.sizeVer(15),
          const Text(
            "There is no events at this time, \nplease come back later.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
