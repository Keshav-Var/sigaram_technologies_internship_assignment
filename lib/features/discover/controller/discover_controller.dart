import 'dart:collection';

import 'package:get/get.dart';

class DiscoverController extends GetxController {
  static const int totalBoxes = 25;
  static const int maxSelectedBoxes = 3;

  final RxSet<int> selectedBoxes = <int>{}.obs;

  final Queue<int> selectionOrder = Queue<int>();

  void onBoxTap(int index) {
    if (selectedBoxes.contains(index)) {
      return;
    }

    if (selectionOrder.length >= maxSelectedBoxes) {
      final oldestIndex = selectionOrder.removeFirst();
      selectedBoxes.remove(oldestIndex);
    }

    selectionOrder.addLast(index);
    selectedBoxes.add(index);

    selectedBoxes.refresh();
  }

  void resetGame() {
    selectedBoxes.clear();
    selectionOrder.clear();
  }
}
