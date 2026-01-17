class SyncConfig {
  final String? clientId;
  final String? clientSecret;
  final bool isEnabled;
  final String? userName;
  final String? userEmail;

  const SyncConfig({
    this.clientId,
    this.clientSecret,
    this.isEnabled = false,
    this.userName,
    this.userEmail,
  });

  SyncConfig copyWith({
    String? clientId,
    String? clientSecret,
    bool? isEnabled,
    String? userName,
    String? userEmail,
  }) {
    return SyncConfig(
      clientId: clientId ?? this.clientId,
      clientSecret: clientSecret ?? this.clientSecret,
      isEnabled: isEnabled ?? this.isEnabled,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}