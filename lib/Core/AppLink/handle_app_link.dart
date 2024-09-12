import 'dart:developer';
import 'package:app_links/app_links.dart';
import '../../main.dart';

final class DynamicLinkHandler {
  DynamicLinkHandler._();

  static final instance = DynamicLinkHandler._();

  final _appLinks = AppLinks();

  String? _lastHandledPostId; // Store the last handled post ID
  bool _hasHandledInitialLink = false; // Track whether the initial link has been handled

  /// Initializes the [DynamicLinkHandler].
  Future<void> initialize() async {
    _appLinks.uriLinkStream.listen((uri) {
      _handleLinkData(uri, isInitialLink: false);
    });
    await _checkInitialLink();
  }

  // dono toh call nhi hogya jab app close tha

  /// Handle navigation if initial link is found on app start.
  Future<void> _checkInitialLink() async {
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleLinkData(initialLink, isInitialLink: true); // Mark as initial link
    }
  }

  /// Handles the dynamic link navigation.
  void _handleLinkData(Uri data, {required bool isInitialLink}) {
    final Map<String, String> queryParams = data.queryParameters;
    final String? postId = queryParams['id'];
    if (postId != null) {
      if (isInitialLink) {
        if (_hasHandledInitialLink && postId == _lastHandledPostId) {
          log('Initial link already handled, ignoring.',
              name: 'Dynamic Link Handler');
          return;
        }
        _hasHandledInitialLink = true;
      }
      _hasHandledInitialLink = true;
      pathStreamController.sink.add(postId);
      _lastHandledPostId = postId;
      isPathStreamControllerListened=postId;
    } else {
      log('Invalid post ID', name: 'Dynamic Link Handler');
    }
  }

  /// Provides the short URL for your dynamic link.
  Future<String> createProductLink({
    required String id,
  }) async {
    return 'https://z-alpha-brains.web.app/post?id=$id';
  }
}
