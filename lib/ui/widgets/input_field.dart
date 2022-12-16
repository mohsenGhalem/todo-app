import 'package:flutter/material.dart';
import 'package:to_do_app_v2/ui/size_config.dart';
import 'package:to_do_app_v2/ui/theme.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.fieldController,
      this.child})
      : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? fieldController;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            alignment: Alignment.center,
            width: SizeConfig.screenWidth * 0.95,
            height: 52,
            padding: const EdgeInsets.only(left: 8.0),
            margin: const EdgeInsets.only(
              top: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: titleStyle,
                    obscureText: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hint,
                      hintStyle: subTitleStyle,
                    ),
                    controller: fieldController,
                    readOnly: child != null ? true : false,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 5),
                  child: child ?? Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
