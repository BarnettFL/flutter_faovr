import Flutter
import UIKit
import FavorX

public class FlutterFavorPlugin: NSObject, FlutterPlugin {
  var node : FavorX.MobileNode?;
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_favor", binaryMessenger: registrar.messenger())
    let instance = FlutterFavorPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "version":
      result(FavorX.MobileVersion())
      break
    case "start":
      let s = call.arguments as! String
      let jsonData = s.data(using: .utf8)!
      
      var optionsObj :Options!
      do {
          let decoder = JSONDecoder()
          optionsObj = try decoder.decode(Options.self, from: jsonData)
          start(o: optionsObj, result: result)
      } catch  {
          result(FlutterError.init(code: "500",
                                   message: error.localizedDescription,
                                   details: nil))
          break
      }
      break
    case "stop":
      self.stop(result: result)
      break
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func stop(result: FlutterResult) {
      if node != nil {
          do {
              try node!.stop()
              node = nil
          } catch {
              result(FlutterError.init(code: "500",
                                       message: error.localizedDescription,
                                       details: nil))
              return
          }
      }
      result(nil)
  }
  
  struct Group: Decodable {
      let name: String
      let type: Int
      let keepConnectedPeers: Int
      let nodes: Array<String>
      
      enum CodingKeys: String, CodingKey {
          case name = "name"
          case type = "type"
          case keepConnectedPeers = "keep-connected-peers"
          case nodes = "nodes"
      }
      
      init(from decoder: Decoder) throws {
              let container = try decoder.container(keyedBy: CodingKeys.self)
          nodes = try container.decode(Array<String>.self, forKey: .nodes)
          name = try container.decode(String.self, forKey: .name)
          type = try container.decode(Int.self, forKey: .type)
          keepConnectedPeers = try container.decode(Int.self, forKey: .keepConnectedPeers)
      }
  }
  
  struct Options: Decodable {
      let apiPort: Int
      let debugApiPort: Int
      let wsPort: Int
      let debugApiEnable: Bool
      let proxyEnable: Bool
      let proxyGroup: String
      let proxyPort: Int
      let groups: Array<Group>
      let networkId: Int64
      let p2pPort: Int
      let welcomeMsg: String
      let binMaxPeers: Int
      let lightMaxPeers: Int
      let cacheCapacity: Int64
      let bootNodes: String
      let devMode: Bool
      let fullNode: Bool
      let chainEndpoint: String
      let oracleContractAddr: String
      let traffic: Bool
      let trafficContractAddr: String
      let verbosity: String
      let enableTLS: Bool
      let password: String
      let dataPath: String
      
      enum CodingKeys: String, CodingKey {
          case apiPort = "api-port"
          case debugApiPort = "debug-api-port"
          case wsPort = "ws-port"
          case debugApiEnable = "debug-api-enable"
          case proxyEnable = "proxy-enable"
          case proxyGroup = "proxy-group"
          case proxyPort = "proxy-port"
          case groups = "groups"
          case networkId = "network-id"
          case p2pPort = "p2p-port"
          case welcomeMsg = "welcome-message"
          case binMaxPeers = "bin-max-peers"
          case lightMaxPeers = "light-max-peers"
          case cacheCapacity = "cache-capacity"
          case bootNodes = "boot-nodes"
          case devMode = "dev-mode"
          case fullNode = "full-node"
          case chainEndpoint = "chain-endpoint"
          case oracleContractAddr = "oracle-contract-addr"
          case traffic = "traffic"
          case trafficContractAddr = "traffic-contract-addr"
          case verbosity = "verbosity"
          case enableTLS = "enable-tls"
          case password = "password"
          case dataPath = "data-dir"
      }
      
      init(from decoder: Decoder) throws {
              let container = try decoder.container(keyedBy: CodingKeys.self)
          apiPort = try container.decode(Int.self, forKey: .apiPort)
          debugApiPort = try container.decode(Int.self, forKey: .debugApiPort)
          wsPort = try container.decode(Int.self, forKey: .wsPort)
          debugApiEnable = try container.decode(Bool.self, forKey: .debugApiEnable)
          proxyEnable = try container.decode(Bool.self, forKey: .proxyEnable)
          proxyGroup = try container.decode(String.self, forKey: .proxyGroup)
          proxyPort = try container.decode(Int.self, forKey: .proxyPort)
          groups = try container.decode(Array<Group>.self, forKey: .groups)
          networkId =  try container.decode(Int64.self, forKey: .networkId)
          p2pPort =  try container.decode(Int.self, forKey: .p2pPort)
          welcomeMsg =  try container.decode(String.self, forKey: .welcomeMsg)
          binMaxPeers =  try container.decode(Int.self, forKey: .binMaxPeers)
          lightMaxPeers =  try container.decode(Int.self, forKey: .lightMaxPeers)
          cacheCapacity =  try container.decode(Int64.self, forKey: .cacheCapacity)
          bootNodes =  try container.decode(String.self, forKey: .bootNodes)
          devMode =  try container.decode(Bool.self, forKey: .devMode)
          fullNode =  try container.decode(Bool.self, forKey: .fullNode)
          chainEndpoint = try container.decode(String.self, forKey: .chainEndpoint)
          oracleContractAddr = try container.decode(String.self, forKey: .oracleContractAddr)
          traffic = try container.decode(Bool.self, forKey: .traffic)
          trafficContractAddr = try container.decode(String.self, forKey: .trafficContractAddr)
          verbosity = try container.decode(String.self, forKey: .verbosity)
          enableTLS = try container.decode(Bool.self, forKey: .enableTLS)
          password = try container.decode(String.self, forKey: .password)
          dataPath = try container.decode(String.self, forKey: .dataPath)
      }
  }
  

  private func start(o: Options, result: FlutterResult) {
      let options = MobileOptions()
      // api setting
      options.apiPort = o.apiPort
      options.debugAPIPort = o.debugApiPort
      options.websocketPort = o.wsPort
      options.enableDebugAPI = o.debugApiEnable
      
      // proxy setting
      options.proxyEnable = o.proxyEnable
      options.proxyGroupName = o.proxyGroup
      options.proxyPort = o.proxyPort
      
      // group setting
      do {
          let data: Data = try JSONSerialization.data(withJSONObject: o.groups)
          options.group = String(data: data, encoding: String.Encoding.utf8)!
      }catch {
          result(FlutterError.init(code: "500",
                                   message: error.localizedDescription,
                                   details: nil))
          return
      }
      
      // p2p setup
      options.networkID = o.networkId
      options.p2PPort = o.p2pPort
      options.welcomeMessage = o.welcomeMsg
      
      // kademlia
      options.binMaxPeers = o.binMaxPeers
      options.lightMaxPeers = o.lightMaxPeers
      
      // cache size
      options.cacheCapacity = o.cacheCapacity
      
      // node bootstrap
      options.bootNodes = o.bootNodes
      options.enableDevNode = o.devMode
      options.enableFullNode = o.fullNode
      
      // chain setting
      options.chainEndpoint = o.chainEndpoint
      options.oracleContract = o.oracleContractAddr
      
      // traffic stat
      options.enableFlowStat = o.traffic
      options.flowContract = o.trafficContractAddr
      
      // security
      options.password = o.password
      options.dataPath = o.dataPath
      
      // misc
      options.verbosity = o.verbosity
      options.enableTLS = o.enableTLS
      
      var error: NSError?
      node = FavorX.MobileNewNode(options, &error)
      if error != nil {
          result(FlutterError.init(code: "500",
                                   message: error!.localizedDescription,
                                   details: nil))
      }
      result(nil)
  }
}
