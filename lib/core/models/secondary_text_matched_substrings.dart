class SecondaryTextMatchedSubstrings {
  int? length;
  int? offset;

  SecondaryTextMatchedSubstrings({this.length, this.offset});

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'offset': offset,
    };
  }

  factory SecondaryTextMatchedSubstrings.fromJson(Map<String, dynamic> map) {
    return SecondaryTextMatchedSubstrings(
      length: map['length'] as int,
      offset: map['offset'] as int,
    );
  }
}
