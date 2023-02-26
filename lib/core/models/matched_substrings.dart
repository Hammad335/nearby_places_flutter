class MatchedSubstrings {
  int? length;
  int? offset;

  MatchedSubstrings({this.length, this.offset});

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'offset': offset,
    };
  }

  factory MatchedSubstrings.fromJson(Map<String, dynamic> map) {
    return MatchedSubstrings(
      length: map['length'] as int,
      offset: map['offset'] as int,
    );
  }
}
