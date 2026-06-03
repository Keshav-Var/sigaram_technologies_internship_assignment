// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sigaram_technologies_internship_assignment/core/constants.dart';
// import 'package:sigaram_technologies_internship_assignment/core/firestore_service.dart';
// import 'package:sigaram_technologies_internship_assignment/features/home/model/home_model.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class HomeController extends GetxController {
//   final FirestoreService _firestore = Get.find<FirestoreService>();

//   final RxBool isLoading = false.obs;
//   final RxInt currentIndex = 0.obs;
//   final RxList<VideoModel> videos = <VideoModel>[].obs;

//   // Only keep controllers for current ± [_windowSize] videos alive
//   final Map<String, YoutubePlayerController> _playerControllers = {};

//   // How many neighbours (each side) to keep initialised
//   static const int _windowSize = 1;

//   // Expose a read-only view so the UI doesn't mutate the map directly
//   Map<String, YoutubePlayerController> get playerControllers =>
//       Map.unmodifiable(_playerControllers);

//   @override
//   void onInit() {
//     super.onInit();
//     fetchVideos();
//   }

//   // ─── Data fetching ────────────────────────────────────────────────────────

//   Future<void> fetchVideos() async {
//     try {
//       isLoading.value = true;

//       final response = await _firestore.getVideos(
//         FirestoreConstants.videoLinks,
//       );

//       final loadedVideos = response
//           .map((e) => VideoModel.fromFirestore(e['id'], e))
//           .toList();

//       videos.assignAll(loadedVideos);

//       // Initialise players only for the first window
//       _updatePlayerWindow(0);
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         e.toString(),
//         backgroundColor: Colors.red.withOpacity(0.8),
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // ─── Player window management ─────────────────────────────────────────────

//   /// Called whenever the visible page changes.
//   void onPageChanged(int index) {
//     final previous = currentIndex.value;
//     currentIndex.value = index;

//     // Pause the video that just scrolled away
//     _pauseAt(previous);

//     // Grow / shrink the active window around the new index
//     _updatePlayerWindow(index);

//     // Auto-play the new current video
//     _playAt(index);
//   }

//   /// Ensures controllers exist for [center ± _windowSize] and disposes the rest.
//   void _updatePlayerWindow(int center) {
//     final keepRange = _rangeAround(center, _windowSize);

//     // --- Dispose out-of-window controllers ---
//     final toDispose = _playerControllers.keys.where((id) {
//       final videoIndex = videos.indexWhere((v) => v.id == id);
//       return videoIndex == -1 || !keepRange.contains(videoIndex);
//     }).toList();

//     for (final id in toDispose) {
//       _playerControllers[id]?.dispose();
//       _playerControllers.remove(id);
//     }

//     // --- Initialise new in-window controllers ---
//     for (final i in keepRange) {
//       if (i < 0 || i >= videos.length) continue;
//       final video = videos[i];
//       if (_playerControllers.containsKey(video.id)) continue;

//       final videoId = YoutubePlayer.convertUrlToId(video.link) ?? '';
//       _playerControllers[video.id] = YoutubePlayerController(
//         initialVideoId: videoId,
//         flags: YoutubePlayerFlags(
//           autoPlay: i == center, // only auto-play current
//           mute: false,
//           hideControls: true, // we use our own overlay controls
//           controlsVisibleAtStart: false,
//           disableDragSeek: false,
//           loop: false,
//           isLive: false,
//           forceHD: false,
//           enableCaption: false,
//         ),
//       );
//     }

//     // Keep the UI updated (RxMap replacement trick)
//     update(['player_controllers']);
//   }

//   /// Convenience: pause the video at [index] if its controller exists.
//   void _pauseAt(int index) {
//     if (index < 0 || index >= videos.length) return;
//     _playerControllers[videos[index].id]?.pause();
//   }

//   /// Convenience: play the video at [index] if its controller exists.
//   void _playAt(int index) {
//     if (index < 0 || index >= videos.length) return;
//     _playerControllers[videos[index].id]?.play();
//   }

//   /// Returns an inclusive set of indices centred on [center] with radius [r].
//   Set<int> _rangeAround(int center, int r) {
//     return {for (int i = center - r; i <= center + r; i++) i};
//   }

//   // ─── UI helpers ───────────────────────────────────────────────────────────

//   YoutubePlayerController? controllerFor(String videoId) =>
//       _playerControllers[videoId];

//   void toggleMute(String videoId) {
//     final ctrl = _playerControllers[videoId];
//     if (ctrl == null) return;
//     ctrl.value.isFullScreen
//         ? null // ignore in fullscreen
//         : ctrl.value.playerState == PlayerState.playing
//         ? ctrl.setVolume(ctrl.value.volume == 0 ? 100 : 0)
//         : null;
//   }

//   // ─── Lifecycle ───────────────────────────────────────────────────────────

//   @override
//   void onClose() {
//     for (final ctrl in _playerControllers.values) {
//       ctrl.dispose();
//     }
//     _playerControllers.clear();
//     super.onClose();
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sigaram_technologies_internship_assignment/core/constants.dart';
// import 'package:sigaram_technologies_internship_assignment/core/firestore_service.dart';
// import 'package:sigaram_technologies_internship_assignment/features/home/model/home_model.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';

// class HomeController extends GetxController {
//   final FirestoreService _firestore = Get.find<FirestoreService>();

//   final RxBool isLoading = false.obs;
//   final RxInt currentIndex = 0.obs;
//   final RxList<VideoModel> videos = <VideoModel>[].obs;

//   // Map to hold one controller per video index
//   final Map<int, YoutubePlayerController> _playerControllers = {};

//   YoutubePlayerController? get currentPlayerController =>
//       _playerControllers[currentIndex.value];

//   @override
//   void onInit() {
//     super.onInit();
//     fetchVideos();
//   }

//   Future<void> fetchVideos() async {
//     try {
//       isLoading.value = true;

//       final response = await _firestore.getVideos(
//         FirestoreConstants.videoLinks,
//       );

//       final loadedVideos = response
//           .map((e) => VideoModel.fromFirestore(e['id'], e))
//           .toList();

//       videos.assignAll(loadedVideos);

//       if (videos.isNotEmpty) {
//         // Pre-load first two controllers
//         _initController(0);
//         if (videos.length > 1) _initController(1);
//       }
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   YoutubePlayerController _initController(int index) {
//     if (_playerControllers.containsKey(index)) {
//       return _playerControllers[index]!;
//     }

//     final videoId =
//         YoutubePlayerController.convertUrlToId(videos[index].link) ?? '';

//     debugPrint('Initializing player for index $index, videoId: $videoId');

//     final controller = YoutubePlayerController(
//       params: const YoutubePlayerParams(
//         showControls: true, // ← show controls to help debug
//         showFullscreenButton: false,
//         strictRelatedVideos: false, // ← false fixes some embed blocks
//         mute: false,
//         loop: true,
//         enableCaption: false,
//       ),
//     );

//     // Load with a small delay to let the widget mount first
//     Future.delayed(const Duration(milliseconds: 300), () {
//       controller.loadVideoById(videoId: videoId);
//     });

//     _playerControllers[index] = controller;
//     return controller;
//   }

//   YoutubePlayerController getControllerForIndex(int index) {
//     return _playerControllers[index] ?? _initController(index);
//   }

//   void onPageChanged(int index) {
//     // Pause previous video
//     _playerControllers[currentIndex.value]?.pauseVideo();

//     currentIndex.value = index;

//     // Pre-load next video controller
//     if (index + 1 < videos.length) {
//       _initController(index + 1);
//     }

//     // Play current
//     _playerControllers[index]?.playVideo();

//     update();
//   }

//   Future<void> playPause() async {
//     final ctrl = currentPlayerController;
//     if (ctrl == null) return;

//     final state = await ctrl.playerState;
//     if (state == PlayerState.playing) {
//       ctrl.pauseVideo();
//     } else {
//       ctrl.playVideo();
//     }
//     update();
//   }

//   Future<void> muteUnMute() async {
//     final ctrl = currentPlayerController;
//     if (ctrl == null) return;

//     final volume = await ctrl.volume;
//     if (volume == 0) {
//       ctrl.setVolume(100);
//     } else {
//       ctrl.setVolume(0);
//     }
//     update();
//   }

//   @override
//   void onClose() {
//     for (final ctrl in _playerControllers.values) {
//       ctrl.close();
//     }
//     _playerControllers.clear();
//     super.onClose();
//   }
// }

import 'package:get/get.dart';
import 'package:omni_video_player/omni_video_player.dart';
import 'package:sigaram_technologies_internship_assignment/core/constants.dart';
import 'package:sigaram_technologies_internship_assignment/core/firestore_service.dart';
import 'package:sigaram_technologies_internship_assignment/features/home/model/home_model.dart';

class HomeController extends GetxController {
  final FirestoreService _firestore = Get.find<FirestoreService>();

  final RxBool isLoading = false.obs;
  final RxInt currentIndex = 0.obs;
  final RxList<VideoModel> videos = <VideoModel>[].obs;

  // Correct type from the actual package
  final Map<int, OmniPlaybackController> _controllers = {};

  OmniPlaybackController? getController(int index) => _controllers[index];

  void registerController(int index, OmniPlaybackController ctrl) {
    _controllers[index] = ctrl;
    if (index == currentIndex.value) ctrl.play();
  }

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    try {
      isLoading.value = true;
      final response = await _firestore.getVideos(
        FirestoreConstants.videoLinks,
      );
      final loadedVideos = response
          .map((e) => VideoModel.fromFirestore(e['id'], e))
          .toList();
      videos.assignAll(loadedVideos);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void onPageChanged(int index) {
    // Pause previous
    _controllers[currentIndex.value]?.pause();
    currentIndex.value = index;
    // Play current
    _controllers[index]?.play();
    update();
  }

  void playPause() {
    final ctrl = _controllers[currentIndex.value];
    if (ctrl == null) return;
    if (ctrl.isPlaying) {
      ctrl.pause();
    } else {
      ctrl.play();
    }
  }

  void muteUnMute() {
    final ctrl = _controllers[currentIndex.value];
    if (ctrl == null) return;
    // toggle mute via volume
    ctrl.isMuted ? ctrl.unMute() : ctrl.mute();
  }

  @override
  void onClose() {
    for (final ctrl in _controllers.values) {
      ctrl.removeListener(() {});
    }
    _controllers.clear();
    super.onClose();
  }
}
