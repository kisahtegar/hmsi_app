import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../../const.dart';
import '../../../../../../domain/entities/event/event_entity.dart';
import '../../../../../cubits/event/event_cubit.dart';
import '../../../../profile/widget/form_edit_widget.dart';

class EditEventMainWidget extends StatefulWidget {
  final EventEntity event;
  const EditEventMainWidget({super.key, required this.event});

  @override
  State<EditEventMainWidget> createState() => _EditEventMainWidgetState();
}

class _EditEventMainWidgetState extends State<EditEventMainWidget> {
  final _formKey = GlobalKey<FormState>();
  final _typeEvent = ['Gather', 'Meeting', 'On-Meeting', 'Training'];
  String? _typeSelected;
  DateTime? _dateTimeSelected = DateTime.now();
  TimeOfDay? _timeSelected = TimeOfDay.now();
  DateTime? _timeSelectedToDateTime;
  TextEditingController? _titleController;
  TextEditingController? _descriptionController;
  TextEditingController? _locationController;
  TextEditingController? _linkController;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  bool _isUpdating = false;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _locationController = TextEditingController(text: widget.event.location);
    _linkController = TextEditingController(text: widget.event.link);
    _typeSelected = widget.event.type;
    _dateTimeSelected = DateTime.fromMicrosecondsSinceEpoch(
        widget.event.date!.microsecondsSinceEpoch);
    _timeSelected = TimeOfDay.fromDateTime(DateTime.fromMicrosecondsSinceEpoch(
        widget.event.time!.microsecondsSinceEpoch));

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
    debugPrint(_dateTimeSelected.toString());
    debugPrint(_timeSelectedToDateTime.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.backGroundColor,
        title: Text(
          "Edit Event",
          style: TextStyle(color: AppColor.primaryColor),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.close, size: 32, color: AppColor.primaryColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: _isUpdating == false
                ? GestureDetector(
                    onTap: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        _updateEvent();
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

  /// DropdownMenuItem for Type Event.
  DropdownMenuItem<String> _buildMenuType(String type) => DropdownMenuItem(
        value: type,
        child: Text(type),
      );

  /// Converting DateTime to Timestamp for Firebase.
  Timestamp _dateTimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromMicrosecondsSinceEpoch(
      dateTime.microsecondsSinceEpoch,
    );
  }

  /// This method will updating event.
  void _updateEvent() {
    setState(() => _isUpdating = true);
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please wait...')),
    );
    BlocProvider.of<EventCubit>(context)
        .updateEvent(
      eventEntity: EventEntity(
        eventId: widget.event.eventId,
        title: _titleController!.text,
        description: _descriptionController!.text,
        date: _dateTimeToTimestamp(_dateTimeSelected!),
        time: _dateTimeToTimestamp(_timeSelectedToDateTime!),
        type: _typeSelected,
        location: _locationController!.text,
        link: _linkController!.text,
      ),
    )
        .then((_) {
      setState(() {
        _isUpdating = false;
        _titleController!.clear();
        _descriptionController!.clear();
        _dateController.clear();
        _timeController.clear();
        _locationController!.clear();
        _linkController!.clear();
      });
      Navigator.pop(context);
    });
  }
}
