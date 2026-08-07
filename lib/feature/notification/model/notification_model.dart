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
      title: data['title'] as String? ?? 'Notification',
      body: data['body'] as String? ?? '',
      category: data['category'] as String? ?? 'Others',
      type: data['type'] as String? ?? 'general',
      isSeen: data['isSeen'] as bool? ?? false,
      createdAt: _readTimestamp(data['createdAt']),
      subscriptionId: data['subscriptionId'] as String?,
    );
  }

  AppNotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    String? category,
    bool? isSeen,
    DateTime? createdAt,
    String? subscriptionId,
  }) {
    return AppNotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      category: category ?? this.category,
      isSeen: isSeen ?? this.isSeen,
      createdAt: createdAt ?? this.createdAt,
      subscriptionId: subscriptionId ?? this.subscriptionId,
    );
  }

  static DateTime _readTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.now();
  }
}
