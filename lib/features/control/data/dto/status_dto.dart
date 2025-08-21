class StatusDto {
  final String? status;
  final String? message;

  StatusDto({this.status, this.message});

  factory StatusDto.fromJson(Map<String, dynamic> json) {
    return StatusDto(
      status: json['status'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'StatusDto(status: $status, message: $message)';
  }
}