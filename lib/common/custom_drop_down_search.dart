import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropDownSearch extends StatelessWidget {
  const CustomDropDownSearch(
      {Key? key,
      this.labelText,
      required this.items,
      this.selected,
      this.isShowSearch,
      this.onChanged,
      this.maxHeight,
      this.labelColor})
      : super(key: key);
  final String? labelText;
  final bool? isShowSearch;
  final List items;
  final String? selected;
  final double? maxHeight;
  final Function(dynamic)? onChanged;
  final Color? labelColor;
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      selectedItem: selected,
      items: (filter, loadProps) => items.cast<String>(),
      onSelected: onChanged,
      decoratorProps: DropDownDecoratorProps(
        baseStyle: TextStyle(fontSize: 14.sp),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: const EdgeInsets.fromLTRB(15, 12, 0, 0),
          labelText: labelText ?? '',
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(
              color: labelColor ?? Colors.grey.shade600, fontSize: 14.sp),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(90.0)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      popupProps: PopupProps.dialog(
        searchFieldProps: const TextFieldProps(),
        showSearchBox: isShowSearch ?? false,
        searchDelay: const Duration(seconds: 0),
        constraints: BoxConstraints(maxWidth: 500, maxHeight: maxHeight ?? 300.h),
      ),
    );
  }
}
