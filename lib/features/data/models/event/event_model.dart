import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/event/event_entity.dart';

class EventModel extends EventEntity {
  const EventModel({
    String? eventId,
    String? creatorUid,
    String? username,
    String? name,
    String? userProfileUrl,
    String? type,
    String? title,
    String? description,
    String? location,
    String? link,
    List<String>? interested,
    num? totalInterested,
    Timestamp? date,
    Timestamp? time,
    Timestamp? createAt,
  }) : super(
          eventId: eventId,
          creatorUid: creatorUid,
          username: username,
          name: name,
          userProfileUrl: userProfileUrl,
          type: type,
          title: title,
          description: description,
          location: location,
          link: link,
          interested: interested,
          totalInterested: totalInterested,
          date: date,
          time: time,
          createAt: createAt,
        );

  factory EventModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return EventModel(
      eventId: snapshot['eventId'],
      creatorUid: snapshot['creatorUid'],
      username: snapshot['username'],
      name: snapshot['name'],
      userProfileUrl: snapshot['userProfileUrl'],
      type: snapshot['type'],
      title: snapshot['title'],
      description: snapshot['description'],
      location: snapshot['location'],
      link: snapshot['link'],
      interested: List.from(snap.get("interested")),
      totalInterested: snapshot['totalInterested'],
      date: snapshot['date'],
      time: snapshot['time'],
      createAt: snapshot['createAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        "eventId": eventId,
        "creatorUid": creatorUid,
        "username": username,
        "name": name,
        "userProfileUrl": userProfileUrl,
        "type": type,
        "title": title,
        "description": description,
        "location": location,
        "link": link,
        "interested": interested,
        "totalInterested": totalInterested,
        "date": date,
        "time": time,
        "createAt": createAt,
      };
}
