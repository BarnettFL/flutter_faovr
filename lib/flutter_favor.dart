import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_favor_platform_interface.dart';

class FlutterFavor {
  late num apiPort = 2633;
  late num debugApiPort = 2635;
  late num wsPort = 2637;
  late bool debugApiEnable = false;
  late bool proxyEnable = false;
  late String proxyGroup = "";
  late num proxyPort = 2639;
  late List<Group> groups = [];
  late num networkId;
  late num p2pPort = 2634;
  late String welcomeMessage = "flutter node($defaultTargetPlatform)";
  late num binMaxPeers = 50;
  late num lightMaxPeers = 100;
  late num cacheCapacity = 4 * 1024;
  late String bootNodes;
  late bool devMode = false;
  late bool fullNode = false;
  late String chainEndpoint;
  late String oracleContractAddress;
  late bool traffic = false;
  late String trafficContractAddress = "";
  late String verbosity = "silent";
  late bool enableTLS = false;
  late String password = "123456";
  late String dataPath;

  FlutterFavor();

  Map<String, dynamic> toJson() => {
        'api-port': apiPort,
        'debug-api-port': debugApiPort,
        'ws-port': wsPort,
        'debug-api-enable': debugApiEnable,
        'proxy-enable': proxyEnable,
        'proxy-group': proxyGroup,
        'proxy-port': proxyPort,
        'groups': groups,
        'network-id': networkId,
        'p2p-port': p2pPort,
        'welcome-message': welcomeMessage,
        'bin-max-peers': binMaxPeers,
        'light-max-peers': lightMaxPeers,
        'cache-capacity': cacheCapacity,
        'boot-nodes': bootNodes,
        'dev-mode': devMode,
        'full-node': fullNode,
        'chain-endpoint': chainEndpoint,
        'oracle-contract-addr': oracleContractAddress,
        'traffic': traffic,
        'traffic-contract-addr': trafficContractAddress,
        'verbosity': verbosity,
        'enable-tls': enableTLS,
        'password': password,
        'data-dir': dataPath,
      };

  Future<String> version() async {
    String version = await FlutterFavorPlatform.instance.version();
    return Future.value(version);
  }

  Future start() async {
    if (enableTLS == true) {
      await readAdnWriteTLS();
    }
    String jsonString = jsonEncode(toJson());
    await FlutterFavorPlatform.instance.start(jsonString);
  }

  Future stop() async {
    await FlutterFavorPlatform.instance.stop();
  }

  Future readAdnWriteTLS() async {
    String dir = "$dataPath/cert";

    String ca = await rootBundle.loadString("packages/flutter_favor/cert/ca.pem");
    String key = await rootBundle.loadString("packages/flutter_favor/cert/ca_key.pem");

    if (!Directory(dir).existsSync()) {
      await Directory(dir).create(recursive: true);
    }
    await (File("$dir/rootCA.pem")).writeAsString(ca, mode: FileMode.write);
    await File("$dir/rootCA-key.pem").writeAsString(key, mode: FileMode.write);
  }
}

class Group {
  final String name;
  final num type;
  final num keptConnectedPeers;
  final List<String> nodes;

  Group(this.name, this.type, this.keptConnectedPeers, this.nodes);

  Group.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        type = json["type"],
        keptConnectedPeers = json["keep-connected-peers"],
        nodes = json["nodes"].cast<String>();

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'keep-connected-peers': keptConnectedPeers,
        'nodes': nodes,
      };
}
