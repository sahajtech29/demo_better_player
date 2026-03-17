import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController();

  final videoUrls = [
    // 'https://d17doq1am2ww0u.cloudfront.net/shuffal/1773666003_17e2a09e-a608-475d-87f3-9c2f4a54940b.mp4',
    // 'https://d17doq1am2ww0u.cloudfront.net/shuffal/1772709028_e17deaa7-985f-4370-86c6-3184797ef924.mp4',
    // 'https://d17doq1am2ww0u.cloudfront.net/shuffal/1764148851_VID-20251103-WA0001.mp4',
    // 'https://d17doq1am2ww0u.cloudfront.net/shuffal/1765608026_1000066810.mp4',
    // 'https://d17doq1am2ww0u.cloudfront.net/shuffal/17518924151000065862.mp4',
    // 'https://d17doq1am2ww0u.cloudfront.net/shuffal/17585350471000000781.mp4',
    // 'https://d17doq1am2ww0u.cloudfront.net/shuffal/1760604730_1000203526.mp4',
    ///////////////-----------------///////////////
    'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
    'https://diceyk6a7voy4.cloudfront.net/e78752a1-2e83-43fa-85ae-3d508be29366/hls/fitfest-sample-1_Ott_Hls_Ts_Avc_Aac_16x9_1280x720p_30Hz_6.0Mbps_qvbr.m3u8',
    'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8',
    'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
    'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: videoUrls.length,
        itemBuilder: (context, index) {
          return ReelBetterPlayer(
            index: index,
            url: videoUrls[index],
            videoUrls: videoUrls,
          );
        },
      ),
    );
  }
}

class ReelBetterPlayer extends StatefulWidget {
  final int index;
  final String url;
  final List<String> videoUrls;
  const ReelBetterPlayer({
    super.key,
    required this.index,
    required this.url,
    required this.videoUrls,
  });

  @override
  State<ReelBetterPlayer> createState() => _ReelBetterPlayerState();
}

class _ReelBetterPlayerState extends State<ReelBetterPlayer> {
  late BetterPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.url,
      videoFormat: BetterPlayerVideoFormat.hls,
      cacheConfiguration: const BetterPlayerCacheConfiguration(
        useCache: true,
        maxCacheSize: 300 * 1024 * 1024,
        maxCacheFileSize: 50 * 1024 * 1024,
      ),
    );

    _controller = BetterPlayerController(
      const BetterPlayerConfiguration(
        autoPlay: true,
        looping: true,
        fit: BoxFit.cover,
        fullScreenByDefault: false,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        deviceOrientationsOnFullScreen: [DeviceOrientation.portraitUp],
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: false,
        ),
        handleLifecycle: true,
      ),
      betterPlayerDataSource: dataSource,
    );

    _preCacheNextVideos();
  }

  /// 🔥 Preload next 2 videos for smooth scroll
  void _preCacheNextVideos() {
    for (int i = 1; i <= 2; i++) {
      int nextIndex = widget.index + i;

      if (nextIndex < widget.videoUrls.length) {
        final nextDataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          widget.videoUrls[nextIndex],
        );

        _controller.preCache(nextDataSource);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.url),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.6) {
          _controller.play();
        } else {
          _controller.pause();
        }
      },
      child: GestureDetector(
        onTap: () {
          if (_controller.isPlaying() ?? false) {
            _controller.pause();
          } else {
            _controller.play();
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [BetterPlayer(controller: _controller)],
        ),
      ),
    );
  }
}

// final List<String> videoUrls = [
//   'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
//   'https://diceyk6a7voy4.cloudfront.net/e78752a1-2e83-43fa-85ae-3d508be29366/hls/fitfest-sample-1_Ott_Hls_Ts_Avc_Aac_16x9_1280x720p_30Hz_6.0Mbps_qvbr.m3u8',
//   'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8',
//   'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
//   'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8',
// ];
