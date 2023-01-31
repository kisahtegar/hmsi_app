import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../const.dart';
import '../../../profile/widget/form_edit_widget.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _typeEvent = ['Gather', 'Meeting', 'On-Meeting', 'Training'];
  String? value;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  bool _isUploading = false;

  @override
  void initState() {
    _dateController.text = "";
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      // if (_formKey.currentState!.validate()) {
                      //   _submitArticle();
                      // }
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // [Text]: Title Event.
              FormEditWidget(
                controller: _titleController,
                title: "Title*",
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
                // focusNode: _focusNode,
                title: "Description*",
                maxLength: 200,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),

              // [TextField]: Date Event.
              AppSize.sizeVer(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Date *",
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
                      labelText: "Enter Date*",
                      iconColor: Colors.black,
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2023),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        debugPrint("$pickedDate"); // 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        debugPrint(formattedDate); // 2021-03-16
                        setState(() {
                          _dateController.text = formattedDate;
                        });
                      } else {}
                    },
                  ),
                ],
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
                    value: value,
                    items: _typeEvent.map(_buildMenuType).toList(),
                    onChanged: (value) => setState(() {
                      this.value = value;
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
    );
  }

  DropdownMenuItem<String> _buildMenuType(String type) => DropdownMenuItem(
        value: type,
        child: Text(type),
      );

  Timestamp _dateTimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromMillisecondsSinceEpoch(
        dateTime.millisecondsSinceEpoch);
  }
}
