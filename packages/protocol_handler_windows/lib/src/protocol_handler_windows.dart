import 'dart:io';

import 'package:protocol_handler_platform_interface/protocol_handler_platform_interface.dart';
import 'package:win32_registry/win32_registry.dart';

class ProtocolHandlerWindows extends MethodChannelProtocolHandler {
  /// The [ProtocolHandlerWindows] constructor.
  ProtocolHandlerWindows() : super();

  /// Registers this class as the default instance of [ProtocolHandlerWindows].
  static void registerWith() {
    ProtocolHandlerPlatform.instance = ProtocolHandlerWindows();
  }

  @override
  Future<void> register(String scheme) async {
    final appPath = Platform.resolvedExecutable;

    final protocolKey = CURRENT_USER.create('Software\\Classes\\$scheme');
    try {
      protocolKey.setValue('URL Protocol', const RegistryValue.string(''));

      final cmdKey = protocolKey.create('shell\\open\\command');
      try {
        cmdKey.setValue('', RegistryValue.string('$appPath "%1"'));
      } finally {
        cmdKey.close();
      }
    } finally {
      protocolKey.close();
    }
  }
}
