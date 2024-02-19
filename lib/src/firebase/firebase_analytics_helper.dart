import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class FirebaseAnalyticsHelper {
  static final FirebaseAnalytics _analyticsInstance = FirebaseAnalytics.instance;

  static FirebaseAnalyticsObserver get getFirebaseAnalyticsObserver => FirebaseAnalyticsObserver(analytics: _analyticsInstance);

  void logEvent(String name, {Map<String, dynamic>? parameters}) => _analyticsInstance.logEvent(name: name, parameters: parameters);
}
