import 'dart:async';
import 'dart:io';

import 'package:bonsoir/bonsoir.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fontkeep_app/core/services/logger_service.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/nearby_device.dart';

class DiscoveryRepository {
  BonsoirBroadcast? _broadcast;
  BonsoirDiscovery? _discovery;
  final String _serviceType = '_fontkeep._tcp';
  final int _port = 53317;

  String? _myUuid;

  final StreamController<List<NearbyDevice>> _devicesController =
      StreamController.broadcast();
  final Map<String, NearbyDevice> _foundDevices = {};

  Stream<List<NearbyDevice>> get nearbyDevices => _devicesController.stream;

  Future<void> start(LoggerService logger) async {
    _myUuid ??= const Uuid().v4();
    await _startBroadcast();
    await _startDiscovery(logger);
  }

  Future<void> stop() async {
    await _broadcast?.stop();
    await _discovery?.stop();
    _foundDevices.clear();
    _devicesController.add([]);
  }

  Future<void> _startBroadcast() async {
    final deviceInfo = DeviceInfoPlugin();
    String name = "FontKeep User";
    String os = Platform.operatingSystem;

    if (Platform.isWindows) {
      final info = await deviceInfo.windowsInfo;
      name = info.computerName;
    } else if (Platform.isMacOS) {
      final info = await deviceInfo.macOsInfo;
      name = info.computerName;
    } else if (Platform.isLinux) {
      final info = await deviceInfo.linuxInfo;
      name = info.name;
    }

    final uuid = _myUuid ?? const Uuid().v4();

    BonsoirService service = BonsoirService(
      name: 'fontkeep-$uuid',
      type: _serviceType,
      port: _port,
      attributes: {'uuid': uuid, 'name': name, 'os': os},
    );

    _broadcast = BonsoirBroadcast(service: service);

    await _broadcast!.initialize();
    await _broadcast!.start();
  }

  Future<void> _startDiscovery(LoggerService logger) async {
    _discovery = BonsoirDiscovery(type: _serviceType);
    await _discovery!.initialize();
    await _discovery!.start();

    _discovery!.eventStream!.listen((event) {
      if (event.service == null) return;

      if (event is BonsoirDiscoveryServiceFoundEvent) {
        event.service.resolve(_discovery!.serviceResolver);
      } else if (event is BonsoirDiscoveryServiceResolvedEvent) {
        _addDevice(event.service, logger);
      } else if (event is BonsoirDiscoveryServiceLostEvent) {
        _removeDevice(event.service);
      }
    });
  }

  Future<void> _addDevice(BonsoirService service, LoggerService logger) async {
    if (service.port == -1) return;

    final remoteUuid = service.attributes['uuid'];
    if (remoteUuid == _myUuid) {
      return;
    }

    if (service.host != null) {
      try {
        final interfaces = await NetworkInterface.list();
        final myIps = interfaces
            .expand((i) => i.addresses.map((a) => a.address))
            .toSet();

        if (myIps.contains(service.host)) {
          return;
        }
      } catch (e) {
        logger.error(e);
      }
    }

    final attrs = service.attributes;
    final device = NearbyDevice.fromService(
      attrs,
      service.host ?? 'unknown',
      service.port,
    );

    _foundDevices[device.id] = device;
    _devicesController.add(_foundDevices.values.toList());
  }

  void _removeDevice(BonsoirService service) {
    final uuid = service.attributes['uuid'];
    if (uuid != null) {
      _foundDevices.remove(uuid);
      _devicesController.add(_foundDevices.values.toList());
    }
  }
}
