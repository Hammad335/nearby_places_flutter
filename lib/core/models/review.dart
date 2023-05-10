class Review {
  String profilePhotoUrl;
  String authorName;
  int rating;
  String text;

  Review({
    required this.profilePhotoUrl,
    required this.authorName,
    required this.rating,
    required this.text,
  });

  Map<String, dynamic> toJson() {
    return {
      'profilePhotoUrl': profilePhotoUrl,
      'authorName': authorName,
      'rating': rating,
      'text': text,
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      profilePhotoUrl: json['profilePhotoUrl'] as String,
      authorName: json['authorName'] as String,
      rating: json['rating'] as int,
      text: json['text'] as String,
    );
  }
}
