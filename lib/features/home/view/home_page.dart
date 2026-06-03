// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// import '../controller/home_controller.dart';
// import '../model/home_model.dart';

// class HomePage extends GetView<HomeController> {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Force portrait + immersive (no status / nav bar)
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Obx(() {
//         if (controller.isLoading.value) return const _ShimmerLoader();

//         if (controller.videos.isEmpty) return const _EmptyState();

//         return Stack(
//           children: [
//             // ── Vertical feed ──────────────────────────────────────────────
//             PageView.builder(
//               scrollDirection: Axis.vertical,
//               physics: const BouncingScrollPhysics(),
//               itemCount: controller.videos.length,
//               onPageChanged: controller.onPageChanged,
//               itemBuilder: (context, index) {
//                 final video = controller.videos[index];
//                 return _VideoPage(video: video, index: index);
//               },
//             ),

//             // ── Progress dots (top-right) ──────────────────────────────────
//             Positioned(
//               top: MediaQuery.of(context).padding.top + 12,
//               right: 16,
//               child: _ProgressDots(
//                 total: controller.videos.length,
//                 currentIndex: controller.currentIndex,
//               ),
//             ),

//             // ── App logo / header ──────────────────────────────────────────
//             Positioned(
//               top: MediaQuery.of(context).padding.top + 8,
//               left: 16,
//               child: const _AppHeader(),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Single video page
// // ─────────────────────────────────────────────────────────────────────────────

// class _VideoPage extends GetView<HomeController> {
//   final VideoModel video;
//   final int index;

//   const _VideoPage({required this.video, required this.index});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return GetBuilder<HomeController>(
//       id: 'player_controllers',
//       builder: (_) {
//         final playerCtrl = controller.controllerFor(video.id);

//         return Stack(
//           fit: StackFit.expand,
//           children: [
//             // ── Black background ─────────────────────────────────────────
//             Container(color: Colors.black),

//             // ── YouTube player (full-width, centred) ─────────────────────
//             if (playerCtrl != null)
//               Positioned.fill(
//                 child: YoutubePlayerBuilder(
//                   player: YoutubePlayer(
//                     controller: playerCtrl,
//                     showVideoProgressIndicator: false,
//                     progressColors: const ProgressBarColors(
//                       playedColor: Color(0xFFFF2D55),
//                       handleColor: Color(0xFFFF2D55),
//                       bufferedColor: Colors.white24,
//                       backgroundColor: Colors.white12,
//                     ),
//                   ),

//                   builder: (ctx, player) {
//                     return Center(
//                       child: AspectRatio(aspectRatio: 16 / 9, child: player),
//                     );
//                   },
//                 ),
//               )
//             else
//               // Placeholder while controller initialises
//               const Center(
//                 child: SizedBox(
//                   width: 36,
//                   height: 36,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Color(0xFFFF2D55),
//                   ),
//                 ),
//               ),

//             // ── Cinematic gradient overlay ────────────────────────────────
//             Positioned.fill(
//               child: DecoratedBox(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     stops: [0.0, 0.35, 0.65, 1.0],
//                     colors: [
//                       Color(0xCC000000),
//                       Colors.transparent,
//                       Colors.transparent,
//                       Color(0xEE000000),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // ── Right-side action bar ─────────────────────────────────────
//             Positioned(
//               right: 12,
//               bottom: 100,
//               child: _ActionBar(video: video, playerCtrl: playerCtrl),
//             ),

//             // ── Bottom info panel ─────────────────────────────────────────
//             Positioned(
//               left: 0,
//               right: 72, // leave room for action bar
//               bottom: 0,
//               child: _BottomInfo(video: video, index: index),
//             ),

//             // ── Tap to play / pause ───────────────────────────────────────
//             if (playerCtrl != null)
//               Positioned.fill(child: _TapToToggle(playerCtrl: playerCtrl)),
//           ],
//         );
//       },
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Tap-to-toggle play/pause with animated icon flash
// // ─────────────────────────────────────────────────────────────────────────────

// class _TapToToggle extends StatefulWidget {
//   final YoutubePlayerController playerCtrl;
//   const _TapToToggle({required this.playerCtrl});

//   @override
//   State<_TapToToggle> createState() => _TapToToggleState();
// }

// class _TapToToggleState extends State<_TapToToggle>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _anim;
//   late final Animation<double> _scale;
//   late final Animation<double> _opacity;
//   bool _showIcon = false;
//   bool _isPlaying = true;

//   @override
//   void initState() {
//     super.initState();
//     _anim = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//     _scale = Tween<double>(
//       begin: 0.5,
//       end: 1.3,
//     ).animate(CurvedAnimation(parent: _anim, curve: Curves.elasticOut));
//     _opacity = Tween<double>(begin: 1, end: 0).animate(
//       CurvedAnimation(
//         parent: _anim,
//         curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
//       ),
//     );
//     _anim.addStatusListener((s) {
//       if (s == AnimationStatus.completed) {
//         setState(() => _showIcon = false);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _anim.dispose();
//     super.dispose();
//   }

//   void _onTap() {
//     final ctrl = widget.playerCtrl;
//     if (ctrl.value.playerState == PlayerState.playing) {
//       ctrl.pause();
//       _isPlaying = false;
//     } else {
//       ctrl.play();
//       _isPlaying = true;
//     }
//     setState(() => _showIcon = true);
//     _anim.forward(from: 0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _onTap,
//       behavior: HitTestBehavior.translucent,
//       child: _showIcon
//           ? Center(
//               child: AnimatedBuilder(
//                 animation: _anim,
//                 builder: (_, __) => Opacity(
//                   opacity: _opacity.value,
//                   child: Transform.scale(
//                     scale: _scale.value,
//                     child: Container(
//                       width: 72,
//                       height: 72,
//                       decoration: BoxDecoration(
//                         color: Colors.black54,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white24, width: 1.5),
//                       ),
//                       child: Icon(
//                         _isPlaying
//                             ? Icons.play_arrow_rounded
//                             : Icons.pause_rounded,
//                         color: Colors.white,
//                         size: 36,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           : const SizedBox.shrink(),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Right-side action bar (like, share, mute)
// // ─────────────────────────────────────────────────────────────────────────────

// class _ActionBar extends StatefulWidget {
//   final VideoModel video;
//   final YoutubePlayerController? playerCtrl;

//   const _ActionBar({required this.video, required this.playerCtrl});

//   @override
//   State<_ActionBar> createState() => _ActionBarState();
// }

// class _ActionBarState extends State<_ActionBar> {
//   bool _liked = false;
//   bool _muted = false;
//   int _likeCount = 0;

//   void _toggleLike() {
//     setState(() {
//       _liked = !_liked;
//       _likeCount += _liked ? 1 : -1;
//     });
//     HapticFeedback.lightImpact();
//   }

//   void _toggleMute() {
//     final ctrl = widget.playerCtrl;
//     if (ctrl == null) return;
//     setState(() {
//       _muted = !_muted;
//       ctrl.setVolume(_muted ? 0 : 100);
//     });
//     HapticFeedback.selectionClick();
//   }

//   void _share() {
//     HapticFeedback.mediumImpact();
//     Get.snackbar(
//       'Share',
//       widget.video.link,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.white10,
//       colorText: Colors.white,
//       borderRadius: 12,
//       margin: const EdgeInsets.all(12),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Like
//         _ActionButton(
//           icon: _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
//           iconColor: _liked ? const Color(0xFFFF2D55) : Colors.white,
//           label: _likeCount > 0 ? '$_likeCount' : 'Like',
//           onTap: _toggleLike,
//           animated: true,
//         ),

//         const SizedBox(height: 24),

//         // Share
//         _ActionButton(
//           icon: Icons.reply_rounded,
//           iconColor: Colors.white,
//           label: 'Share',
//           onTap: _share,
//           flipH: true,
//         ),

//         const SizedBox(height: 24),

//         // Mute
//         _ActionButton(
//           icon: _muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
//           iconColor: Colors.white,
//           label: _muted ? 'Unmute' : 'Mute',
//           onTap: _toggleMute,
//         ),

//         const SizedBox(height: 24),

//         // Vinyl / disc avatar
//         _SpinningDisc(),
//       ],
//     );
//   }
// }

// class _ActionButton extends StatefulWidget {
//   final IconData icon;
//   final Color iconColor;
//   final String label;
//   final VoidCallback onTap;
//   final bool animated;
//   final bool flipH;

//   const _ActionButton({
//     required this.icon,
//     required this.iconColor,
//     required this.label,
//     required this.onTap,
//     this.animated = false,
//     this.flipH = false,
//   });

//   @override
//   State<_ActionButton> createState() => _ActionButtonState();
// }

// class _ActionButtonState extends State<_ActionButton>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _anim;
//   late final Animation<double> _scale;

//   @override
//   void initState() {
//     super.initState();
//     _anim = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 200),
//       lowerBound: 0.85,
//       upperBound: 1.0,
//       value: 1.0,
//     );
//     _scale = _anim;
//   }

//   @override
//   void dispose() {
//     _anim.dispose();
//     super.dispose();
//   }

//   void _onTap() {
//     if (widget.animated) {
//       _anim.reverse().then((_) => _anim.forward());
//     }
//     widget.onTap();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _onTap,
//       child: Column(
//         children: [
//           ScaleTransition(
//             scale: _scale,
//             child: Transform(
//               alignment: Alignment.center,
//               transform: Matrix4.identity()
//                 ..scale(widget.flipH ? -1.0 : 1.0, 1.0),
//               child: Icon(widget.icon, color: widget.iconColor, size: 32),
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             widget.label,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 11,
//               fontWeight: FontWeight.w500,
//               letterSpacing: 0.2,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Spinning vinyl disc avatar at the bottom of the action bar
// // ─────────────────────────────────────────────────────────────────────────────

// class _SpinningDisc extends StatefulWidget {
//   @override
//   State<_SpinningDisc> createState() => _SpinningDiscState();
// }

// class _SpinningDiscState extends State<_SpinningDisc>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _rot;

//   @override
//   void initState() {
//     super.initState();
//     _rot = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 4),
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _rot.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RotationTransition(
//       turns: _rot,
//       child: Container(
//         width: 44,
//         height: 44,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           gradient: const RadialGradient(
//             colors: [Color(0xFFFF2D55), Color(0xFF1A1A1A)],
//             stops: [0.3, 1.0],
//           ),
//           border: Border.all(color: Colors.white24, width: 2),
//         ),
//         child: const Center(
//           child: CircleAvatar(radius: 6, backgroundColor: Colors.white),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Bottom info: title + progress bar + scroll hint
// // ─────────────────────────────────────────────────────────────────────────────

// class _BottomInfo extends GetView<HomeController> {
//   final VideoModel video;
//   final int index;

//   const _BottomInfo({required this.video, required this.index});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Title
//           Text(
//             video.title,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               height: 1.3,
//               shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
//             ),
//           ),

//           const SizedBox(height: 8),

//           // Video index badge
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFFF2D55).withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                     color: const Color(0xFFFF2D55).withOpacity(0.4),
//                   ),
//                 ),
//                 child: Obx(
//                   () => Text(
//                     '${controller.currentIndex.value + 1} / ${controller.videos.length}',
//                     style: const TextStyle(
//                       color: Color(0xFFFF2D55),
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(width: 10),

//               // Scroll hint
//               const Row(
//                 children: [
//                   Icon(
//                     Icons.keyboard_arrow_up_rounded,
//                     color: Colors.white54,
//                     size: 16,
//                   ),
//                   Text(
//                     'Swipe for next',
//                     style: TextStyle(color: Colors.white54, fontSize: 12),
//                   ),
//                 ],
//               ),
//             ],
//           ),

//           const SizedBox(height: 12),

//           // YouTube progress bar proxy (thin accent line)
//           _ProgressLine(
//             playerCtrl: Get.find<HomeController>().controllerFor(video.id),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Thin animated progress bar driven by YoutubePlayerController
// // ─────────────────────────────────────────────────────────────────────────────

// class _ProgressLine extends StatelessWidget {
//   final YoutubePlayerController? playerCtrl;
//   const _ProgressLine({required this.playerCtrl});

//   @override
//   Widget build(BuildContext context) {
//     if (playerCtrl == null) {
//       return const SizedBox(height: 3);
//     }

//     // YoutubePlayerController extends ValueNotifier<YoutubePlayerValue>,
//     // so we can listen to it directly with ValueListenableBuilder.
//     return ValueListenableBuilder<YoutubePlayerValue>(
//       valueListenable: playerCtrl!,
//       builder: (context, value, _) {
//         final duration = value.metaData.duration.inMilliseconds;
//         final position = value.position.inMilliseconds;
//         final progress = (duration > 0)
//             ? (position / duration).clamp(0.0, 1.0)
//             : 0.0;

//         return ClipRRect(
//           borderRadius: BorderRadius.circular(2),
//           child: LinearProgressIndicator(
//             value: progress.toDouble(),
//             minHeight: 3,
//             backgroundColor: Colors.white12,
//             valueColor: const AlwaysStoppedAnimation(Color(0xFFFF2D55)),
//           ),
//         );
//       },
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Top-right scroll progress dots
// // ─────────────────────────────────────────────────────────────────────────────

// class _ProgressDots extends StatelessWidget {
//   final int total;
//   final RxInt currentIndex;

//   const _ProgressDots({required this.total, required this.currentIndex});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final cur = currentIndex.value;
//       return Column(
//         mainAxisSize: MainAxisSize.min,
//         children: List.generate(total, (i) {
//           final active = i == cur;
//           return AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut,
//             margin: const EdgeInsets.symmetric(vertical: 3),
//             width: active ? 8 : 5,
//             height: active ? 20 : 5,
//             decoration: BoxDecoration(
//               color: active ? const Color(0xFFFF2D55) : Colors.white38,
//               borderRadius: BorderRadius.circular(4),
//             ),
//           );
//         }),
//       );
//     });
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // App header / logo
// // ─────────────────────────────────────────────────────────────────────────────

// class _AppHeader extends StatelessWidget {
//   const _AppHeader();

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(6),
//           decoration: BoxDecoration(
//             color: const Color(0xFFFF2D55),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: const Icon(
//             Icons.play_arrow_rounded,
//             color: Colors.white,
//             size: 18,
//           ),
//         ),
//         const SizedBox(width: 8),
//         const Text(
//           'Reels',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.w800,
//             letterSpacing: -0.5,
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Shimmer loading state
// // ─────────────────────────────────────────────────────────────────────────────

// class _ShimmerLoader extends StatefulWidget {
//   const _ShimmerLoader();

//   @override
//   State<_ShimmerLoader> createState() => _ShimmerLoaderState();
// }

// class _ShimmerLoaderState extends State<_ShimmerLoader>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _anim;
//   late final Animation<double> _shimmer;

//   @override
//   void initState() {
//     super.initState();
//     _anim = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1400),
//     )..repeat();
//     _shimmer = Tween<double>(
//       begin: -2,
//       end: 2,
//     ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeInOut));
//   }

//   @override
//   void dispose() {
//     _anim.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return AnimatedBuilder(
//       animation: _shimmer,
//       builder: (_, __) {
//         return Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment(_shimmer.value - 1, 0),
//               end: Alignment(_shimmer.value, 0),
//               colors: const [
//                 Color(0xFF111111),
//                 Color(0xFF2A2A2A),
//                 Color(0xFF111111),
//               ],
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.play_circle_outline_rounded,
//                 color: Color(0xFFFF2D55),
//                 size: 64,
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Loading Videos…',
//                 style: TextStyle(
//                   color: Colors.white54,
//                   fontSize: 14,
//                   letterSpacing: 1.2,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Empty state
// // ─────────────────────────────────────────────────────────────────────────────

// class _EmptyState extends StatelessWidget {
//   const _EmptyState();

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(
//             Icons.video_library_outlined,
//             color: Colors.white30,
//             size: 72,
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'No Videos Found',
//             style: TextStyle(
//               color: Colors.white54,
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 8),
//           TextButton.icon(
//             onPressed: () => Get.find<HomeController>().fetchVideos(),
//             icon: const Icon(Icons.refresh_rounded, color: Color(0xFFFF2D55)),
//             label: const Text(
//               'Retry',
//               style: TextStyle(color: Color(0xFFFF2D55)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omni_video_player/omni_video_player.dart';

import '../controller/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0D0A14),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.videos.isEmpty) {
          return const Center(
            child: Text(
              'No Videos Found',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: controller.videos.length,
          onPageChanged: controller.onPageChanged,
          itemBuilder: (context, index) => _VideoPage(
            index: index,
            title: controller.videos[index].title,
            videoUrl: controller.videos[index].link,
            videoNumber: index + 1,
            totalVideos: controller.videos.length,
          ),
        );
      }),
    );
  }
}

class _VideoPage extends GetView<HomeController> {
  final int index;
  final String title;
  final String videoUrl;
  final int videoNumber;
  final int totalVideos;

  const _VideoPage({
    required this.index,
    required this.title,
    required this.videoUrl,
    required this.videoNumber,
    required this.totalVideos,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ── BACKGROUND ──
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff1A1325), Color(0xff0D0A14)],
            ),
          ),
        ),

        // ── MAIN CONTENT (title + player + counter) ──
        Column(
          children: [
            // Top safe area spacer
            const SizedBox(height: 56),

            // ── APP BAR ROW ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.play_circle_fill,
                    color: Color(0xff8B5CF6),
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Video Hub',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const Spacer(),
                  // // Video counter badge
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 10,
                  //     vertical: 4,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: const Color(0xff8B5CF6).withValues(alpha: 0.2),
                  //     borderRadius: BorderRadius.circular(20),
                  //     border: Border.all(
                  //       color: const Color(0xff8B5CF6).withValues(alpha: 0.4),
                  //     ),
                  //   ),
                  //   child: Text(
                  //     '$videoNumber / $totalVideos',
                  //     style: const TextStyle(
                  //       color: Color(0xff8B5CF6),
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── VIDEO TITLE (above the player) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ── VIDEO PLAYER ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(color: Color(0x887C3AED), blurRadius: 24),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: OmniVideoPlayer(
                      callbacks: VideoPlayerCallbacks(
                        onControllerCreated: (ctrl) {
                          controller.registerController(index, ctrl);
                        },
                      ),
                      configuration: VideoPlayerConfiguration(
                        videoSourceConfiguration:
                            VideoSourceConfiguration.youtube(
                              videoUrl: Uri.parse(videoUrl),
                              preferredQualities: [
                                OmniVideoQuality.high720,
                                OmniVideoQuality.medium480,
                                OmniVideoQuality.medium360,
                                OmniVideoQuality.low240,
                              ],
                              availableQualities: [
                                OmniVideoQuality.high1080,
                                OmniVideoQuality.high720,
                                OmniVideoQuality.medium480,
                                OmniVideoQuality.medium360,
                                OmniVideoQuality.low240,
                                OmniVideoQuality.low144,
                              ],
                              enableYoutubeWebViewFallback: true,
                              forceYoutubeWebViewOnly: false,
                            ).copyWith(
                              autoPlay: false,
                              initialVolume: 1.0,
                              autoMuteOnStart: false,
                              allowSeeking: true,
                              availablePlaybackSpeed: [
                                0.5,
                                0.75,
                                1.0,
                                1.25,
                                1.5,
                                2.0,
                              ],
                              initialPlaybackSpeed: 1.0,
                            ),
                        // ── ENABLE ALL THE FEATURES YOU WANT ──
                        playerUIVisibilityOptions: PlayerUIVisibilityOptions()
                            .copyWith(
                              // Controls bar at bottom of player
                              showVideoBottomControlsBar: true,
                              showGradientBottomControl: true,

                              // Seek bar + time
                              showSeekBar: true,
                              showCurrentTime: true,
                              showRemainingTime: true, // remaining time shown
                              showDurationTime:
                                  false, // hide total duration to avoid clutter
                              // Playback speed button
                              showPlaybackSpeedButton: true,

                              // Quality switcher
                              showSwitchVideoQuality: true,
                              showSwitchWhenOnlyAuto: true,

                              // Fullscreen button
                              showFullScreenButton: true,
                              enableOrientationLock: true,
                              enableExitFullscreenOnVerticalSwipe: true,
                              showBottomControlsBarOnEndedFullscreen: true,

                              // Play/pause & mute in controls bar
                              showPlayPauseReplayButton: false,
                              showMuteUnMuteButton: false,

                              // Misc
                              showThumbnailAtStart: false,
                              showLoadingWidget: true,
                              showErrorPlaceholder: true,
                              showReplayButton: true,
                              showLiveIndicator: false,
                              useSafeAreaForBottomControls: true,

                              // Double-tap seek gestures
                              enableForwardGesture: true,
                              enableBackwardGesture: true,

                              controlsPersistenceDuration: const Duration(
                                seconds: 3,
                              ),
                            ),
                        // Purple-themed controls to match your UI
                        playerTheme: OmniVideoPlayerThemeData().copyWith(
                          overlays: VideoPlayerOverlayTheme().copyWith(
                            backgroundColor: Colors.black,
                            alpha: 60,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── BOTTOM: mute + play buttons only ──
            Padding(
              padding: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    return _iconButton(
                      icon: controller.isMuted.value
                          ? Icons.volume_off
                          : Icons.volume_up,
                      label: 'Mute',
                      onTap: controller.muteUnMute,
                    );
                  }),
                  const SizedBox(width: 32),
                  Obx(() {
                    return _iconButton(
                      icon: controller.isPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow,
                      label: 'Play',
                      onTap: controller.playPause,
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _iconButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(icon, color: const Color(0xff8B5CF6), size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
