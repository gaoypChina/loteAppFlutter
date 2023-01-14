import 'package:flutter/material.dart';

class MyCheckBox extends StatefulWidget {
  final String title;
  final bool value;
  final Color color;
  final ValueChanged<bool> onChanged;
  final bool isRequired;
  final bool disable;
  const MyCheckBox({Key key, @required this.title, @required this.value, @required this.onChanged, this.color, this.isRequired, this.disable = false}) : super(key: key);

  @override
  State<MyCheckBox> createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: widget.disable,
      child: InkWell(
        onTap: () => _onChanged(!widget.value),
        child: Wrap(
          children: [
            Checkbox(value: widget.value, onChanged: _onChanged),
            Visibility(
              visible: _visibleIfNotNull(),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0 ),
                child: Text(_title()),
              ),
            ),
          ],
        )
      )
    );
  }

  void _onChanged(bool value) => widget.onChanged(value);

  bool _visibleIfNotNull() {
    return widget.title != null;
  }
  
  String _title() {
    return widget.title != null ? widget.title : '';
  }
  
}