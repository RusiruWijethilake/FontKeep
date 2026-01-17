class NearbyDevice {
  final String id;
  final String name;
  final String ip;
  final int port;
  final String os;

  NearbyDevice({
    required this.id,
    required this.name,
    required this.ip,
    required this.port,
    required this.os,
  });

  factory NearbyDevice.fromService(Map<String, dynamic> attributes, String ip, int port) {
    return NearbyDevice(
      id: attributes['uuid'] ?? 'unknown',
      name: attributes['name'] ?? 'Unknown Device',
      os: attributes['os'] ?? 'unknown',
      ip: ip,
      port: port,
    );
  }
}