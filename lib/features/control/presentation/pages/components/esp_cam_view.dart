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

  // Minimal shell for /stream only
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
    img.src = url; // must be the /stream endpoint
  }

  img.addEventListener('load', function(){ setStatus(''); });

  img.addEventListener('error', function(){
    setStatus('reconnecting…');
    setTimeout(start, 300);
  });

  // Nudge some Android WebViews
  setInterval(function(){
    if(!url) return;
    const cur = img.src;
    if(!cur) return;
    img.src = '';
    img.src = cur;
  }, 15000);

  window.setMjpegUrl = function(u){
    url = u || '';
    start();
  };

  document.addEventListener('visibilitychange', function(){
    if(document.visibilityState === 'visible' && url){
      if(!img.src){ img.src = url; }
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
    if (state == AppLifecycleState.resumed && _controller != null) {
      // Re-apply last URL if we were using the /stream shell
      _controller!.evaluateJavascript(
          source: 'if(window.setMjpegUrl && window._lastUrl){ window.setMjpegUrl(window._lastUrl); }'
      );
    }
    super.didChangeAppLifecycleState(state);
  }

  bool _looksLikeStreamUrl(String u) {
    final lower = u.toLowerCase();
    return lower.contains('/stream'); // covers /stream and /stream?...
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ControlBloc, ControlState>(
      buildWhen: (prev, next) =>
      prev.mjpegUrl != next.mjpegUrl || prev.isVideoEnabled != next.isVideoEnabled,
      builder: (context, state) {
        final mjpegUrl = state.mjpegUrl;

        if (state.isVideoEnabled != true || mjpegUrl == null || mjpegUrl.isEmpty) {
          return const Center(child: Text('No video stream'));
        }

        final isStreamOnly = _looksLikeStreamUrl(mjpegUrl);

        if (!isStreamOnly) {
          // Load the ESP32-CAM CameraWebServer HTML as the MAIN PAGE to avoid ORB.
          return SafeArea(
            child: InAppWebView(
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                domStorageEnabled: true,
                mediaPlaybackRequiresUserGesture: false,
                allowsInlineMediaPlayback: true,
                supportZoom: true,
                transparentBackground: true,
                clearCache: false,
                disableContextMenu: true,
                mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                useWideViewPort: true,
                javaScriptCanOpenWindowsAutomatically: false,
                // Optional, but helps with modern JS in that page:
                userAgent:
                'Mozilla/5.0 (Linux; Android 11) AppleWebKit/537.36 (KHTML, like Gecko) Chrome Mobile Safari/537.36',
              ),
              initialUrlRequest: URLRequest(url: WebUri(mjpegUrl)),
              onWebViewCreated: (c) => _controller = c,
              onLoadError: (c, url, code, msg) {
                // The ESP might reboot or Wi-Fi could flap; the page has its own retry logic.
              },
              onReceivedError: (c, req, err) {},
            ),
          );
        }

        // Stream-only mode via <img src=".../stream">
        return InAppWebView(
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            supportZoom: false,
            transparentBackground: true,
            clearCache: false,
            disableContextMenu: true,
            mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
          ),
          initialData: InAppWebViewInitialData(data: _htmlTemplate),
          onWebViewCreated: (controller) async {
            _controller = controller;
            await controller.evaluateJavascript(
                source:
                "window._lastUrl = ${_jsString(mjpegUrl)}; if (window.setMjpegUrl) window.setMjpegUrl(window._lastUrl);"
            );
          },
          onLoadStop: (controller, _) async {
            await controller.evaluateJavascript(
                source:
                "window._lastUrl = ${_jsString(mjpegUrl)}; if (window.setMjpegUrl) window.setMjpegUrl(window._lastUrl);"
            );
          },
        );
      },
    );
  }

  String _jsString(String value) {
    final escaped = value.replaceAll(r'\', r'\\').replaceAll("'", r"\'");
    return "'$escaped'";
  }
}
