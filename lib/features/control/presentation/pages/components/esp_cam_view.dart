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

  // Build a small HTML shell that displays the MJPEG stream directly
  String _buildFallbackStreamHtml(String baseUrl) {
    final streamUrl = '$baseUrl/stream';
    final vflipUrl = '$baseUrl/control?var=vflip&val=1';
    return '''
<!doctype html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
  html, body { margin:0; padding:0; height:100%; background:#000; }
  #wrap { position:fixed; inset:0; display:flex; align-items:center; justify-content:center; }
  #stream { max-width:100%; max-height:100%; }
</style>
<script>
  (function(){
    try {
      // Fire-and-forget V-Flip ON
      fetch('$vflipUrl').catch(function(){});
    } catch(e) {}
    function start(){
      var img = document.getElementById('stream');
      if (img) img.src = '$streamUrl';
    }
    document.addEventListener('DOMContentLoaded', start);
  })();
</script>
</head>
<body>
  <div id="wrap">
    <img id="stream" alt="stream" />
  </div>
</body>
</html>
''';
  }

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
      _controller!.reload();
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
            onLoadStop: (controller, url) async {
              // Hide toggle menu and start video stream after page loads
              await controller.evaluateJavascript(source: '''
              (function(){
                try {
                  // Start video stream
                  const startBtn = document.querySelector('#toggle-stream');
                  if (startBtn && startBtn.textContent && startBtn.textContent.toLowerCase().includes('start')) {
                       startBtn.click();
                  }
                  
                  // Ensure V-Flip is ON by default
                  const vflip = document.querySelector('#vflip');
                  if (vflip && !vflip.checked) {
                       // click triggers the default-action change listener
                       vflip.click();
                  }
                  
                  // Close settings panel if it's open
                  const settingsMenu = document.querySelector('#menu');
                  const toggleBtn = document.querySelector('#nav-toggle');
                  if (settingsMenu && toggleBtn) {
                       const isVisible = getComputedStyle(settingsMenu).display !== 'none';
                       if (isVisible) toggleBtn.click();
                  }
                } catch (e) {
                  // swallow errors to avoid console spam on transient pages
                }
              })();
              ''');
            },
            onReceivedError: (controller, request, error) async {
              // If the main index fails to decode (common with compressed index pages),
              // fall back to a simple HTML that embeds the MJPEG stream directly.
              final baseUrl = context.read<ControlBloc>().state.videoStreamUrl;
              final desc = (error.description ?? '').toString();
              if (baseUrl != null && baseUrl.isNotEmpty && desc.contains('ERR_CONTENT_DECODING_FAILED')) {
                final html = _buildFallbackStreamHtml(baseUrl);
                await controller.loadData(data: html, mimeType: 'text/html', encoding: 'utf-8', baseUrl: WebUri(baseUrl));
              }
            },
          ),
        );
      },
    );
  }
    @override
    void dispose() {
      WidgetsBinding.instance.removeObserver(this);
      super.dispose();
    }
  }