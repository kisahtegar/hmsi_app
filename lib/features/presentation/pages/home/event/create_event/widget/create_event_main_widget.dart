import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../../const.dart';
import '../../../../../../domain/entities/event/event_entity.dart';
import '../../../../../../domain/entities/user/user_entity.dart';
import '../../../../../cubits/event/event_cubit.dart';
import '../../../../profile/widget/form_edit_widget.dart';

class CreateEventMainWidget extends StatefulWidget {
  final UserEntity currentUser;
  const CreateEventMainWidget({super.key, required this.currentUser});

  @override
  State<CreateEventMainWidget> createState() => _CreateEventMainWidgetState();
}

class _CreateEventMainWidgetState extends State<CreateEventMainWidget> {
  final _formKey = GlobalKey<FormState>();
  final _typeEvent = ['Gather', 'Meeting', 'On-Meeting', 'Training'];
  String? _typeSelected = 'Gather';
  DateTime? _dateTimeSelected = DateTime.now();
  TimeOfDay? _timeSelected = TimeOfDay.now();
  DateTime? _timeSelectedToDateTime;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  bool _isUploading = false;

  @override
  void initState() {
    _dateController.text =
        "${_dateTimeSelected!.year}-${_dateTimeSelected!.month.toString().padLeft(2, '0')}-${_dateTimeSelected!.day.toString().padLeft(2, '0')}";
    _timeController.text =
        "${_timeSelected!.hour.toString().padLeft(2, '0')}:${_timeSelected!.minute.toString().padLeft(2, '0')}";

    _timeSelectedToDateTime = DateTime(
      _dateTimeSelected!.year,
      _dateTimeSelected!.month,
      _dateTimeSelected!.day,
      _timeSelected!.hour,
      _timeSelected!.minute,
    );
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("CreateEventPage[build]: Building!!");
    debugPrint("CreateEventPage[build]: _typeSelected = $_typeSelected");
    debugPrint(
        "CreateEventPage[build]: _dateTimeSelected = $_dateTimeSelected");
    debugPrint("CreateEventPage[build]: _timeSelected = $_timeSelected");
    debugPrint(
        "CreateEventPage[build]: _timeSelectedToDateTime = $_timeSelectedToDateTime");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        titleSpacing: 2,
        title: Text(
          "Create Event",
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
            padding: const EdgeInsets.only(right: 10.0),
            child: _isUploading == false
                ? GestureDetector(
                    onTap: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        _submitArticle();
                      }
                    },
                    child: Icon(Icons.done,
                        color: AppColor.primaryColor, size: 32),
                  )
                : const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // [Text]: Title Event.
                FormEditWidget(
                  controller: _titleController,
                  title: "Title *",
                  maxLength: 100,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),

                // [Text]: Description Event.
                AppSize.sizeVer(10),
                FormEditWidget(
                  controller: _descriptionController,
                  title: "Description *",
                  maxLength: 1000,
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),

                // [DateTime]: Date Event.
                AppSize.sizeVer(10),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date Event *",
                        style: TextStyle(
                          color: AppColor.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today),
                          hintText: "Enter Date*",
                          iconColor: Colors.black,
                          labelStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              _dateController.text = formattedDate;
                              _dateTimeSelected = pickedDate;

                              // Convert TimeOfDay to DateTime
                              _timeSelectedToDateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                _timeSelected!.hour,
                                _timeSelected!.minute,
                              );
                            });
                          } else {}
                        },
                      ),
                    ],
                  ),
                ),

                // [TimeOfDay]: Time Event.
                AppSize.sizeVer(25),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Time Event *",
                        style: TextStyle(
                          color: AppColor.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: _timeController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.timer),
                          hintText: "Enter Time*",
                          iconColor: Colors.black,
                          labelStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: _timeSelected!,
                          );

                          if (pickedTime != null) {
                            setState(() {
                              _timeController.text =
                                  "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                              _timeSelected = pickedTime;

                              // Convert TimeOfDay to DateTime
                              _timeSelectedToDateTime = DateTime(
                                _dateTimeSelected!.year,
                                _dateTimeSelected!.month,
                                _dateTimeSelected!.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          } else {}
                        },
                      ),
                    ],
                  ),
                ),

                // [DropdownButton]: List of Type Event.
                AppSize.sizeVer(25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Type Event *",
                      style: TextStyle(
                        color: AppColor.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButton(
                      isExpanded: true,
                      value: _typeSelected,
                      items: _typeEvent.map(_buildMenuType).toList(),
                      onChanged: (value) => setState(() {
                        _typeSelected = value;
                      }),
                    ),
                  ],
                ),

                // [Text]: Location Event.
                AppSize.sizeVer(20),
                FormEditWidget(
                  controller: _locationController,
                  title: "Location",
                ),

                // [Text]: Link Event.
                AppSize.sizeVer(20),
                FormEditWidget(
                  controller: _linkController,
                  title: "Link",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// DropdownMenuItem for Type Event
  DropdownMenuItem<String> _buildMenuType(String type) => DropdownMenuItem(
        value: type,
        child: Text(type),
      );

  Timestamp _dateTimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromMicrosecondsSinceEpoch(
      dateTime.microsecondsSinceEpoch,
    );
  }

  void _submitArticle() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please wait...')),
    );
    BlocProvider.of<EventCubit>(context)
        .createEvent(
      eventEntity: EventEntity(
        eventId: const Uuid().v1(),
        creatorUid: widget.currentUser.uid,
        username: widget.currentUser.username,
        name: widget.currentUser.name,
        userProfileUrl: widget.currentUser.profileUrl,
        type: _typeSelected,
        title: _titleController.text,
        description: _descriptionController.text,
        location: _locationController.text,
        link: _linkController.text,
        interested: const [],
        totalInterested: 0,
        date: _dateTimeToTimestamp(_dateTimeSelected!),
        time: _dateTimeToTimestamp(_timeSelectedToDateTime!),
        createAt: Timestamp.now(),
      ),
    )
        .then((_) {
      setState(() {
        _isUploading = false;
        _titleController.clear();
        _descriptionController.clear();
        _locationController.clear();
        _linkController.clear();
        _dateController.clear();
      });
      Navigator.pop(context);
    });
  }
}
