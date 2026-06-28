import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotificationModel {
  const AppNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isSeen,
    required this.category,
    required this.createdAt,
    this.subscriptionId,
  });

  final String id;
  final String title;
  final String body;
  final String type;
  final String category;
  final bool isSeen;
  final DateTime createdAt;
  final String? subscriptionId;

  factory AppNotificationModel.fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    return AppNotificationModel(
      id: doc.id,
      title: data['title'] ?? 'Notification',
      body: data['body'] ?? '',
      category: data['category'] ?? 'Others',
      type: data['type'] ?? 'general',
      isSeen: data['isSeen'] ?? false,
      createdAt: _readTimestamp(data['createdAt']),
      subscriptionId: data['subscriptionId'],
    );
  }

  static DateTime _readTimestamp(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }
}
