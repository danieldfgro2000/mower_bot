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
    _bloc.add(GetVideoStreamUrl());
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ControlBloc, ControlState>(
      buildWhen: (prev, next) =>
      prev.videoStreamUrl != next.videoStreamUrl,
      builder: (context, state) {
        final videoStreamUrl = state.videoStreamUrl;

        if (videoStreamUrl == null || videoStreamUrl.isEmpty) {
          return const Center(child: Text('No video stream'));
        }
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
              ),
              initialUrlRequest: URLRequest(url: WebUri(videoStreamUrl)),
              onWebViewCreated: (c) => _controller = c,
              onReceivedError: (c, req, err) {},
            ),
          );
        }

    );
  }
}
