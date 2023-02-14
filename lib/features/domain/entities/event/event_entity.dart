import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final String? eventId;
  final String? creatorUid;
  final String? username;
  final String? name;
  final String? userProfileUrl;
  final String? type;
  final String? title;
  final String? description;
  final String? location;
  final String? link;
  final List<String>? interested;
  final num? totalInterested;
  final Timestamp? date;
  final Timestamp? time;
  final Timestamp? createAt;

  const EventEntity({
    this.eventId,
    this.creatorUid,
    this.username,
    this.name,
    this.userProfileUrl,
    this.type,
    this.title,
    this.description,
    this.location,
    this.link,
    this.interested,
    this.totalInterested,
    this.date,
    this.time,
    this.createAt,
  });

  @override
  List<Object?> get props => [
        eventId,
        creatorUid,
        username,
        name,
        userProfileUrl,
        type,
        title,
        description,
        location,
        link,
        interested,
        totalInterested,
        date,
        time,
        createAt,
      ];
}
