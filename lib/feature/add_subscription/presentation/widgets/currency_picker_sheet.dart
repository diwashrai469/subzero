import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/currency_data.dart';

class CurrencyPickerSheet extends StatefulWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const CurrencyPickerSheet({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  State<CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<CurrencyPickerSheet> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _allCurrencies = currencyDetails.keys.toList();
  late List<String> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = _allCurrencies;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filtered = _allCurrencies;
        return;
      }
      final q = query.toLowerCase();
      _filtered = _allCurrencies.where((code) {
        final d = currencyDetails[code]!;
        return code.toLowerCase().contains(q) ||
            d['name']!.toLowerCase().contains(q) ||
            d['country']!.toLowerCase().contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // keyboardHeight tells us how much the keyboard is pushing up
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        // Cap height so it never overflows — shrinks when keyboard opens
        constraints: BoxConstraints(
          maxHeight: screenHeight - keyboardHeight - 60,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F0),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Drag handle ─────────────────────
            Padding(
              padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
              child: Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),

            // ── Header ──────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Currency',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Icon(
                        Icons.close,
                        size: 14.sp,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 14.h),

            // ── Search bar ──────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                height: 44.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filter,
                  autofocus: false,
                  style: TextStyle(fontSize: 13.sp, color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Search by currency, country...',
                    hintStyle: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade400,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 18.sp,
                      color: Colors.grey.shade400,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              _filter('');
                            },
                            child: Icon(
                              Icons.close,
                              size: 16.sp,
                              color: Colors.grey.shade400,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ),

            // ── Result count ────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_filtered.length} currencies',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),

            // ── List — takes remaining space ────
            Flexible(
              child: _filtered.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 36.sp,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'No currencies found',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final code = _filtered[index];
                        final d = currencyDetails[code]!;
                        final isSelected = code == widget.selected;

                        return GestureDetector(
                          onTap: () {
                            widget.onSelected(code);
                            Navigator.pop(context);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: EdgeInsets.only(bottom: 8.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 11.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Color(0xFF006C73)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  d['flag']!,
                                  style: TextStyle(fontSize: 22.sp),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        d['name']!,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        '${d['country']} · $code',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: isSelected
                                              ? Colors.white60
                                              : Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Container(
                                    width: 22.w,
                                    height: 22.w,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      size: 13.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
