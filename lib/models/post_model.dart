class PostModel {
  const PostModel({
    required this.postId,
    required this.userId,
    required this.title,
    required this.description,
    required this.symptoms,
    required this.suggestedCaseType,
    required this.isAlreadyAssessed,
    required this.contactInfo,
    this.isClosed = false,
    this.createdAt,
    this.closedAt,
  });

  final String postId;
  final String userId;
  final String title;
  final String description;
  final List<String> symptoms;
  final String suggestedCaseType;
  final bool isAlreadyAssessed;
  final String contactInfo;
  final bool isClosed;
  final DateTime? createdAt;
  final DateTime? closedAt;

  PostModel copyWith({
    String? postId,
    String? userId,
    String? title,
    String? description,
    List<String>? symptoms,
    String? suggestedCaseType,
    bool? isAlreadyAssessed,
    String? contactInfo,
    bool? isClosed,
    DateTime? createdAt,
    DateTime? closedAt,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      symptoms: symptoms ?? this.symptoms,
      suggestedCaseType: suggestedCaseType ?? this.suggestedCaseType,
      isAlreadyAssessed: isAlreadyAssessed ?? this.isAlreadyAssessed,
      contactInfo: contactInfo ?? this.contactInfo,
      isClosed: isClosed ?? this.isClosed,
      createdAt: createdAt ?? this.createdAt,
      closedAt: closedAt ?? this.closedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'title': title,
      'description': description,
      'symptoms': symptoms,
      'suggestedCaseType': suggestedCaseType,
      'isAlreadyAssessed': isAlreadyAssessed,
      'contactInfo': contactInfo,
      'isClosed': isClosed,
      'createdAt': createdAt?.toIso8601String(),
      'closedAt': closedAt?.toIso8601String(),
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      symptoms: List<String>.from(map['symptoms'] as List? ?? const []),
      suggestedCaseType: map['suggestedCaseType'] as String? ?? '',
      isAlreadyAssessed: map['isAlreadyAssessed'] as bool? ?? false,
      contactInfo: map['contactInfo'] as String? ?? '',
      isClosed: map['isClosed'] as bool? ?? false,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? ''),
      closedAt: DateTime.tryParse(map['closedAt'] as String? ?? ''),
    );
  }
}
