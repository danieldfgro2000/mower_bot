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
              onReceivedError: (c, req, err) {},
            ),
          );
        }

    );
  }
}
