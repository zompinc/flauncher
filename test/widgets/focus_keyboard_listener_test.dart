/*
 * FLauncher
 * Copyright (C) 2021  Étienne Fesser
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:flauncher/widgets/focus_keyboard_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<List<String>> pumpListener(WidgetTester tester) async {
    final calls = <String>[];
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: FocusKeyboardListener(
          onPressed: (key) {
            calls.add("pressed");
            return KeyEventResult.handled;
          },
          onLongPress: (key) {
            calls.add("longPress");
            return KeyEventResult.handled;
          },
          builder: (context) => InkWell(
            autofocus: true,
            onTap: () => calls.add("tap"),
            child: SizedBox(width: 100, height: 100),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    return calls;
  }

  for (final key in longPressableKeys) {
    testWidgets("${key.keyLabel} down does not activate the child before key up", (tester) async {
      final calls = await pumpListener(tester);

      await tester.sendKeyDownEvent(key, platform: "android");
      await tester.pump();
      expect(calls, isEmpty);

      await tester.sendKeyUpEvent(key, platform: "android");
      await tester.pump();
      expect(calls, ["pressed"]);
    });
  }
}
