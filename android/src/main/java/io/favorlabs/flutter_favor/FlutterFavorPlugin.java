package io.favorlabs.flutter_favor;

import androidx.annotation.NonNull;

import org.json.JSONObject;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import mobile.Mobile;
import mobile.Node;
import mobile.Options;

/** FlutterFavorPlugin */
public class FlutterFavorPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private static volatile Node node = null;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_favor");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "version":
        result.success(Mobile.version());
        break;
      case "start":
        try {
          start(call.arguments.toString());
          result.success(null);
        } catch (Exception e) {
          result.error("500", "FavorX start failure", e);
        }
        break;
      case "stop":
        try {
          stop();
          result.success(null);
        } catch (Exception e) {
          result.error("500", "FavorX stop failure", e);
        }
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  private void start(String config) throws Exception {
    JSONObject params = new JSONObject(config);
    Options options = new Options();

    // api setting
    options.setApiPort(params.getInt("api-port"));
    options.setDebugAPIPort(params.getInt("debug-api-port"));
    options.setWebsocketPort(params.getInt("ws-port"));
    options.setEnableDebugAPI(params.getBoolean("debug-api-enable"));

    // proxy setting
    options.setProxyEnable(params.getBoolean("proxy-enable"));
    options.setProxyGroupName(params.getString("proxy-group"));
    options.setProxyPort(params.getInt("proxy-port"));

    // group setting
    options.setGroup(params.getJSONArray("groups").toString());

    // p2p setup
    options.setNetworkID(params.getInt("network-id"));
    options.setP2PPort(params.getInt("p2p-port"));
    options.setWelcomeMessage(params.getString("welcome-message"));

    // kademlia
    options.setBinMaxPeers(params.getInt("bin-max-peers"));
    options.setLightMaxPeers(params.getInt("light-max-peers"));

    // cache size
    options.setCacheCapacity(params.getLong("cache-capacity"));

    // node bootstrap
    options.setBootNodes(params.getString("boot-nodes"));
    options.setEnableDevNode(params.getBoolean("dev-mode"));
    options.setEnableFullNode(params.getBoolean("full-node"));

    // chain setting
    options.setChainEndpoint(params.getString("chain-endpoint"));
    options.setOracleContract(params.getString("oracle-contract-addr"));

    // traffic stat
    options.setEnableFlowStat(params.getBoolean("traffic"));
    options.setFlowContract(params.getString("traffic-contract-addr"));

    // security
    options.setPassword(params.getString("password"));
    options.setDataPath(params.getString("data-dir"));

    // misc
    options.setVerbosity(params.getString("verbosity"));
    options.setEnableTLS(params.getBoolean("enable-tls"));

    node = Mobile.newNode(options);
  }

  private void stop() throws Exception {
    if (node != null) {
      node.stop();
      node = null;
    }
  }
}
