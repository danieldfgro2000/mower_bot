// lib/features/control/presentation/widgets/esp_mjpeg_webview.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:mower_bot/features/control/presentation/bloc/control_bloc.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_event.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_state.dart';

class EspMjpegWebView extends StatefulWidget {
  const EspMjpegWebView({super.key});

  @override
  State<EspMjpegWebView> createState() => _EspMjpegWebViewState();
}

class _EspMjpegWebViewState extends State<EspMjpegWebView>
    with WidgetsBindingObserver {
  InAppWebViewController? _controller;
  late final ControlBloc _bloc;

  // Minimal HTML shell: no crossorigin, no query params, gentle reconnect.
  static const _htmlTemplate = r'''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no">
<style>
  html, body { margin:0; padding:0; background:#000; height:100%; overflow:hidden; }
  #wrap { position:fixed; inset:0; display:flex; align-items:center; justify-content:center; }
  img { width:100vw; height:100vh; object-fit:cover; background:#000; }
  #overlay { position:fixed; left:0; right:0; bottom:0; padding:6px 10px; color:#fff;
             font-family:system-ui,-apple-system,Roboto,Arial; font-size:12px; opacity:0.55; }
</style>
</head>
<body>
  <div id="wrap">
    <img id="mjpeg" alt="stream"/>
  </div>
  <div id="overlay"></div>
<script>
(function(){
  const img = document.getElementById('mjpeg');
  const overlay = document.getElementById('overlay');
  let url = '';

  function setStatus(t){ overlay.textContent = t || ''; }

  function start(){
    if(!url) return;
    setStatus('connecting…');
    // Assign the URL directly (no cache-busting, no crossorigin)
    img.src = url;
  }

  img.addEventListener('load', function(){ setStatus(''); });

  img.addEventListener('error', function(){
    // If socket breaks (e.g., server restarts), retry after a short delay
    setStatus('reconnecting…');
    setTimeout(start, 200);
  });

  // Some Android WebViews may stall on long-lived sockets; nudge periodically.
  setInterval(function(){
    if(!url) return;
    const cur = img.src;
    if(!cur) return;
    img.src = '';
    img.src = cur;
  }, 15000);

  // Called from Flutter to set/update the stream URL.
  window.setMjpegUrl = function(u){
    url = u || '';
    start();
  };

  // If page becomes visible again, ensure the image is pointed at the URL.
  document.addEventListener('visibilitychange', function(){
    if(document.visibilityState === 'visible' && url){
      const cur = img.src;
      if(!cur){ img.src = url; }
    }
  });
})();
</script>
</body>
</html>
''';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc = context.read<ControlBloc>();
    _bloc.add(StartVideoStream());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _bloc.add(StopVideoStream());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Nudge the page to reconnect when returning to foreground.
    if (state == AppLifecycleState.resumed && _controller != null) {
      _controller!.evaluateJavascript(
          source: 'if(window.setMjpegUrl && window._lastUrl){ window.setMjpegUrl(window._lastUrl); }'
      );
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ControlBloc, ControlState>(
      buildWhen: (prev, next) =>
      prev.mjpegUrl != next.mjpegUrl || prev.isVideoEnabled != next.isVideoEnabled,
      builder: (context, state) {
        if (!(state.isVideoEnabled==true) || (state.mjpegUrl == null || state.mjpegUrl!.isEmpty)) {
          return const Center(child: Text('No video stream'));
        }

        final mjpegUrl = state.mjpegUrl!;
        return InAppWebView(
          // Keep settings simple & robust for MJPEG
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            supportZoom: false,
            transparentBackground: true,
            clearCache: false,
            disableContextMenu: true,
            // Allow http content inside https page (Android)
            mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
          ),
          initialData: InAppWebViewInitialData(data: _htmlTemplate),
          onWebViewCreated: (controller) async {
            _controller = controller;
            await controller.evaluateJavascript(
                source: "window._lastUrl = ${_jsString(mjpegUrl)}; if (window.setMjpegUrl) window.setMjpegUrl(window._lastUrl);"
            );
          },
          onLoadStop: (controller, _) async {
            // Re-apply after reloads
            await controller.evaluateJavascript(
                source: "window._lastUrl = ${_jsString(mjpegUrl)}; if (window.setMjpegUrl) window.setMjpegUrl(window._lastUrl);"
            );
          },
          onReceivedHttpError: (controller, request, errorResponse) async {
            // Optional: Kinda noisy; leave empty or add logging if needed.
          },
          onReceivedError: (controller, request, error) async {
            // Optional: Also noisy on flaky Wi-Fi; HTML handles reconnection.
          },
        );
      },
    );
  }

  String _jsString(String value) {
    // Escape backslashes and single quotes for safe JS string literal
    final escaped = value.replaceAll(r'\', r'\\').replaceAll("'", r"\'");
    return "'$escaped'";
  }
}
