class Terms {
  int? offset;
  String? value;

  Terms({this.offset, this.value});

  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'value': value,
    };
  }

  factory Terms.fromJson(Map<String, dynamic> map) {
    return Terms(
      offset: map['offset'] as int,
      value: map['value'] as String,
    );
  }
}
