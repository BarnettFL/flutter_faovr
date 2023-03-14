import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_favor_platform_interface.dart';

class FlutterFavor {
  late num? apiPort = 2633;
  late num? debugApiPort = 2635;
  late num? wsPort = 2637;
  late bool? debugApiEnable = false;
  late bool? proxyEnable = false;
  late String? proxyGroup;
  late num? proxyPort = 2639;
  late List<Group>? groups;
  late num networkId = 19;
  late num? p2pPort = 2634;
  late String? welcomeMessage = "flutter node($defaultTargetPlatform)";
  late num? binMaxPeers = 50;
  late num? lightMaxPeers = 100;
  late num? cacheCapacity = 4 * 1024;
  late List<String> bootNodes;
  late bool? devMode = false;
  late bool? fullNode = false;
  late String chainEndpoint;
  late String oracleContractAddress;
  late bool? traffic = false;
  late String? trafficContractAddress;
  late String? verbosity = "silent";
  late bool? enableTLS = false;
  late String? password = "123456";
  late String dataPath;

  FlutterFavor(
      {this.apiPort,
      this.debugApiPort,
      this.wsPort,
      this.debugApiEnable,
      this.proxyEnable,
      this.proxyGroup,
      this.proxyPort,
      this.groups,
      required this.networkId,
      this.p2pPort,
      this.welcomeMessage,
      this.binMaxPeers,
      this.lightMaxPeers,
      this.cacheCapacity,
      required this.bootNodes,
      this.devMode,
      this.fullNode,
      required this.chainEndpoint,
      required this.oracleContractAddress,
      this.traffic,
      this.trafficContractAddress,
      this.verbosity,
      this.enableTLS,
      this.password,
      required this.dataPath});

  FlutterFavor.fromJson(Map<String, dynamic> json)
      : apiPort = json['api-port'],
        debugApiPort = json['debug-api-port'],
        wsPort = json['ws-port'],
        debugApiEnable = json['debug-api-enable'],
        proxyEnable = json['proxy-enable'],
        proxyGroup = json['proxy-group'],
        proxyPort = json['proxy-port'],
        groups = json['groups'],
        networkId = json['network-id'],
        p2pPort = json['p2p-port'],
        welcomeMessage = json['welcome-message'],
        binMaxPeers = json['bin-max-peers'],
        lightMaxPeers = json['light-max-peers'],
        cacheCapacity = json['cache-capacity'],
        bootNodes = json['boot-nodes'],
        devMode = json['dev-mode'],
        fullNode = json['full-node'],
        chainEndpoint = json['chain-endpoint'],
        oracleContractAddress = json['oracle-contract-addr'],
        traffic = json['traffic'],
        trafficContractAddress = json['traffic-contract-addr'],
        verbosity = json['verbosity'],
        enableTLS = json['enable-tls'],
        password = json['password'],
        dataPath = json['data-dir'];

  Map<String, dynamic> toJson() => {
        'api-port': apiPort,
        'debug-api-port': debugApiPort,
        'ws-port': wsPort,
        'debug-api-enable': debugApiPort,
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

  Future<String?> version() {
    return Future.value(FlutterFavorPlatform.instance.version());
  }

  Future<Error?> start() async {
    if (enableTLS == true) {
      await readAdnWriteTLS();
    }
    String jsonString = jsonEncode(toJson());
    return Future.value(FlutterFavorPlatform.instance.start(jsonString));
  }

  Future<Error?> stop() {
    return Future.value(FlutterFavorPlatform.instance.stop());
  }

  Future readAdnWriteTLS() async {
    String dir = "$dataPath/cert";

    String ca = await rootBundle.loadString("assets/cert/ca.pem");
    String key = await rootBundle.loadString("assets/cert/ca_key.pem");

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
  final Array nodes;

  Group(this.name, this.type, this.keptConnectedPeers, this.nodes);

  Group.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        type = json["type"],
        keptConnectedPeers = json["keep-connected-peers"],
        nodes = json["nodes"];

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'keep-connected-peers': keptConnectedPeers,
        'nodes': nodes,
      };
}
