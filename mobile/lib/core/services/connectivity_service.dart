import 'package:connectivity_plus/connectivity_plus.dart';
import '../network/network_info.dart';

/// Live Connectivity Service broadcasting network state streams.
class ConnectivityService {
  final NetworkInfo _networkInfo;

  ConnectivityService(this._networkInfo);

  Future<bool> get isConnected => _networkInfo.isConnected;

  Stream<bool> get onConnectivityChanged {
    return _networkInfo.onConnectivityChanged.map(
      (results) => !results.contains(ConnectivityResult.none),
    );
  }
}
