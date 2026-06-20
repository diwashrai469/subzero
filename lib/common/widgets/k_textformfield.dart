import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_theme.dart';
import '../constant/app_dimens.dart';
import '../constant/ui_helpers.dart';

class KTextFormField extends StatefulWidget {
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextEditingController? controller;
  final bool? diabled;
  final Iterable<String>? autofillHints;
  final String? hint;
  final String? initialValue;
  final String? label;
  final bool required;
  final bool obscureText;
  final bool? autoFocus;
  final TextInputType keyboardType;
  final dynamic maxLines;
  final int? maxlength;
  final String? errorText;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final List<TextInputFormatter>? formatters;
  final Widget? prefixIcon, suffixIcon;
  final bool takeCheckSpace;

  const KTextFormField({
    this.takeCheckSpace = false,
    this.prefixIcon,
    this.contentPadding,
    this.autoFocus = false,
    this.suffixIcon,
    this.focusNode,
    this.validator,
    this.autofillHints,
    this.onFieldSubmitted,
    this.maxlength,
    this.diabled = false,
    this.onChanged,
    this.required = true,
    this.hint,
    this.label,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.controller,
    this.initialValue,
    this.errorText,
    this.formatters,
    super.key,
  });

  @override
  _KTextFormFieldState createState() => _KTextFormFieldState();
}

class _KTextFormFieldState extends State<KTextFormField> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null && widget.label!.isNotEmpty)
          Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        text: widget.label,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        children: <InlineSpan>[
                          if (widget.required == true)
                            const TextSpan(
                              text: '* ',
                              style: TextStyle(color: errorColor),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              sHeightSpan,
            ],
          ),
        TextFormField(
          onFieldSubmitted: (value) => widget.onFieldSubmitted,
          autofillHints: widget.autofillHints,
          maxLength: widget.maxlength,
          inputFormatters: widget.formatters,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: obscureText,
          enabled: !widget.diabled!,
          autofocus: widget.autoFocus ?? false,
          focusNode: widget.focusNode,
          initialValue: widget.initialValue,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: (widget.initialValue?.isEmpty == true ||
                      widget.initialValue == null)
                  ? null
                  : Colors.grey),
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            contentPadding: widget.contentPadding,
            hintText: widget.hint,
            filled: true,
            fillColor: Colors.white,
            hintStyle: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: darkGrey,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
            errorStyle: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: AppDimens.headlineFontSizeXXXSmall,
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: const BorderSide(color: primaryColor)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: const BorderSide(
                color: darkGrey,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: const BorderSide(
                color: errorColor,
              ),
            ),
          ),
          validator: widget.validator,
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
