// lib/features/control/presentation/widgets/esp_mjpeg_webview.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:mower_bot/features/control/presentation/bloc/camera_cubit.dart';
import 'package:mower_bot/features/control/presentation/bloc/camera_state.dart';

class EspMjpegWebView extends StatefulWidget {
  const EspMjpegWebView({super.key});

  @override
  State<EspMjpegWebView> createState() => _EspMjpegWebViewState();
}

class _EspMjpegWebViewState extends State<EspMjpegWebView>
    with WidgetsBindingObserver {
  InAppWebViewController? _controller;
  late final CameraCubit _cameraCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cameraCubit = context.read<CameraCubit>();
    _cameraCubit.refresh();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _cameraCubit.refresh();
    }
    if (state == AppLifecycleState.resumed && _controller != null) {
      // Re-apply last URL if we were using the /stream shell
      _controller!.reload();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        final videoStreamUrl = state.streamUrl;

        if (videoStreamUrl == null || videoStreamUrl.isEmpty) {
          return const Center(child: Text('No video stream'));
        }

        return SafeArea(
          child: InAppWebView(
            key: ValueKey(videoStreamUrl),
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
              await controller.evaluateJavascript(
                source: '''
              (function(){
                try {
                  // Start video stream
                  const startBtn = document.querySelector('#toggle-stream');
                  if (startBtn && startBtn.textContent && startBtn.textContent.toLowerCase().includes('start')) {
                       startBtn.click();
                  }
                  
                  // Ensure V-Flip is ON by default
                  const vflip = document.querySelector('#vflip');
                  //if (vflip && !vflip.checked) {
                       // click triggers the default-action change listener
                       vflip.click();
                  //}
                  
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
              ''',
              );
            },
            onReceivedError: (controller, request, error) async {
              final desc = (error.description).toString();
              if (kDebugMode) {
                debugPrint('WebView error: $desc');
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
