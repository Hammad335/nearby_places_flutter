class MainTextMatchedSubstrings {
  int? length;
  int? offset;

  MainTextMatchedSubstrings({this.length, this.offset});

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'offset': offset,
    };
  }

  factory MainTextMatchedSubstrings.fromJson(Map<String, dynamic> map) {
    return MainTextMatchedSubstrings(
      length: map['length'] as int,
      offset: map['offset'] as int,
    );
  }
}
