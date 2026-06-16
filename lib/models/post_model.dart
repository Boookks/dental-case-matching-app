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
    this.createdAt,
  });

  final String postId;
  final String userId;
  final String title;
  final String description;
  final List<String> symptoms;
  final String suggestedCaseType;
  final bool isAlreadyAssessed;
  final String contactInfo;
  final DateTime? createdAt;

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
      'createdAt': createdAt?.toIso8601String(),
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
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? ''),
    );
  }
}
