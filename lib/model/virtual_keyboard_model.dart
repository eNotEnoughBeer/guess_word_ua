import 'package:flutter/material.dart';
import '../UI/colors_map.dart';
import '../view_model/view_model.dart';

/// ## ChangeNotifier class for one letter button on keyboard
class KeyboardKey extends ChangeNotifier {
  final String? text;
  final IconData iconData;
  final ValueSetter<String>? onTextInput;
  final VoidCallback? onPressed;
  final int flex;
  late Color color;
  KeyboardKey({
    this.text,
    IconData? iconData,
    this.onTextInput,
    this.onPressed,
    this.flex = 1,
    this.color = unusedColor,
  }) : iconData = iconData ?? Icons.add;

  KeyboardKey copyWith({
    String? text,
    ValueSetter<String>? onTextInput,
    VoidCallback? onPressed,
    int? flex,
    Color? color,
    IconData? iconData,
  }) {
    return KeyboardKey(
      text: text ?? this.text,
      onTextInput: onTextInput ?? this.onTextInput,
      onPressed: onPressed ?? this.onPressed,
      flex: flex ?? this.flex,
      color: color ?? this.color,
      iconData: iconData ?? this.iconData,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KeyboardKey &&
        other.text == text &&
        other.onTextInput == onTextInput &&
        other.onPressed == onPressed &&
        other.flex == flex &&
        other.color == color;
  }

  @override
  int get hashCode =>
      text.hashCode ^
      flex.hashCode ^
      color.hashCode ^
      onTextInput.hashCode ^
      onPressed.hashCode;
}

/// ### ChangeNotifier class for a keyboard widget
class KeyboardModel extends ChangeNotifier {
  final Color color; // background color (not a keyboard key)
  final List<KeyboardKey> _keyboard; // all of the keyboard letters
  List<KeyboardKey> get keyboard => _keyboard;

  final ValueSetter<String>?
      onTextInput; // callback for "letter" button pressed
  final VoidCallback?
      onBackspacePressed; // callback for "backspace" button pressed
  final VoidCallback? onEnterPressed; // callback for "Enter" button pressed
  KeyboardModel({
    this.color = backgroundColor,
    this.onTextInput,
    this.onBackspacePressed,
    this.onEnterPressed,
  }) : _keyboard = List<KeyboardKey>.generate(35, (index) {
          if (index == 24) {
            return standardKeyboardUA[index]
                .copyWith(onPressed: onBackspacePressed);
          } else if (index == 34) {
            return standardKeyboardUA[index]
                .copyWith(onPressed: onEnterPressed);
          } else {
            return standardKeyboardUA[index].copyWith(onTextInput: onTextInput);
          }
        }, growable: false);

  // nothing interesting just an Ukrainian keyboard, without "`" letter :)
  static List<KeyboardKey> standardKeyboardUA = <KeyboardKey>[
    KeyboardKey(text: 'Й'),
    KeyboardKey(text: 'Ц'),
    KeyboardKey(text: 'У'),
    KeyboardKey(text: 'К'),
    KeyboardKey(text: 'Е'),
    KeyboardKey(text: 'Н'),
    KeyboardKey(text: 'Г'),
    KeyboardKey(text: 'Ґ'),
    KeyboardKey(text: 'Ш'),
    KeyboardKey(text: 'Щ'),
    KeyboardKey(text: 'З'),
    KeyboardKey(text: 'Х'),
    KeyboardKey(text: 'Ф'),
    KeyboardKey(text: 'І'),
    KeyboardKey(text: 'Ї'),
    KeyboardKey(text: 'В'),
    KeyboardKey(text: 'А'),
    KeyboardKey(text: 'П'),
    KeyboardKey(text: 'Р'),
    KeyboardKey(text: 'О'),
    KeyboardKey(text: 'Л'),
    KeyboardKey(text: 'Д'),
    KeyboardKey(text: 'Ж'),
    KeyboardKey(text: 'Є'),
    KeyboardKey(iconData: Icons.backspace_outlined, flex: 3),
    KeyboardKey(text: 'Я', flex: 2),
    KeyboardKey(text: 'Ч', flex: 2),
    KeyboardKey(text: 'С', flex: 2),
    KeyboardKey(text: 'М', flex: 2),
    KeyboardKey(text: 'И', flex: 2),
    KeyboardKey(text: 'Т', flex: 2),
    KeyboardKey(text: 'Ь', flex: 2),
    KeyboardKey(text: 'Б', flex: 2),
    KeyboardKey(text: 'Ю', flex: 2),
    KeyboardKey(iconData: Icons.subdirectory_arrow_left, flex: 3),
  ];

  /// ### just drop the button colors to initial state
  void resetKeyboard() {
    for (int i = 0; i < _keyboard.length; i++) {
      if (_keyboard[i].color != unusedColor) {
        _keyboard[i].color = unusedColor;
        _keyboard[i].notifyListeners();
      }
    }
  }

  /// ### fill keyboard keys background according to [currentWord]
  void redrawColors(List<LetterByUsage> currentWord) {
    for (var e in currentWord) {
      var index = _keyboard.indexWhere((element) => element.text == e.char);
      if (index == -1) continue;
      if (e.status == LetterStatus.useless) {
        if (_keyboard[index].color != unusedColor) continue;
        _keyboard[index].color = absentColor;
      } else {
        _keyboard[index].color = presentOnCorrectPositionColor;
      }
      _keyboard[index].notifyListeners();
    }
  }
}
