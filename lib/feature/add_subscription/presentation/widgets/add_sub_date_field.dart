import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:subzero/common/constant/ui_helpers.dart';

// ─────────────────────────────────────────────
//  Custom Date Picker Dialog
// ─────────────────────────────────────────────
Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  return showGeneralDialog<DateTime>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'DatePicker',
    barrierColor: Colors.black.withValues(alpha: 0.55),
    transitionDuration: const Duration(milliseconds: 380),
    transitionBuilder: (ctx, anim, secondAnim, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutExpo);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.88, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
    pageBuilder: (ctx, _, _) => _CustomDatePickerDialog(
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(2100),
    ),
  );
}

class _CustomDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const _CustomDatePickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<_CustomDatePickerDialog> createState() =>
      _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<_CustomDatePickerDialog>
    with SingleTickerProviderStateMixin {
  late DateTime _focusedMonth;
  late DateTime _selectedDate;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _slidingForward = true;

  static const _accentColor = Color(0xFF6C63FF);
  static const _accentLight = Color(0xFFE8E6FF);
  static const _textPrimary = Color(0xFF1A1A2E);
  static const _textSecondary = Color(0xFF8B8BA7);
  static const _white = Colors.white;

  final List<String> _weekDays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _focusedMonth = DateTime(widget.initialDate.year, widget.initialDate.month);

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _changeMonth(int delta) async {
    _slidingForward = delta > 0;
    _slideAnimation =
        Tween<Offset>(
          begin: Offset(_slidingForward ? 1.0 : -1.0, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    await _slideController.reverse();
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + delta);
    });
    _slideController.forward();
  }

  List<DateTime?> _buildCalendarDays() {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDay = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    // Monday = 1 … Sunday = 7
    final startOffset = firstDay.weekday - 1;
    final totalCells =
        (startOffset + lastDay.day + 6) ~/ 7 * 7; // round up to full weeks

    return List.generate(totalCells, (i) {
      final dayIndex = i - startOffset + 1;
      if (dayIndex < 1 || dayIndex > lastDay.day) return null;
      return DateTime(_focusedMonth.year, _focusedMonth.month, dayIndex);
    });
  }

  bool _isSelected(DateTime? d) =>
      d != null &&
      d.year == _selectedDate.year &&
      d.month == _selectedDate.month &&
      d.day == _selectedDate.day;

  bool _isToday(DateTime? d) {
    final now = DateTime.now();
    return d != null &&
        d.year == now.year &&
        d.month == now.month &&
        d.day == now.day;
  }

  bool _isDisabled(DateTime? d) =>
      d == null || d.isBefore(widget.firstDate) || d.isAfter(widget.lastDate);

  @override
  Widget build(BuildContext context) {
    final days = _buildCalendarDays();

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: _white,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: _accentColor.withValues(alpha: 0.18),
              blurRadius: 48,
              spreadRadius: 0,
              offset: const Offset(0, 16),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildMonthNavigator(),
              _buildWeekDayRow(),
              SizedBox(height: 4.h),
              _buildCalendarGrid(days),
              SizedBox(height: 12.h),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // ── HEADER ──────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 20.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF3D35CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SELECT DATE',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.75),
              letterSpacing: 2.5,
            ),
          ),
          sHeightSpan,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('d').format(_selectedDate),
                style: TextStyle(
                  fontSize: 52.sp,
                  fontWeight: FontWeight.w800,
                  color: _white,
                  height: 1,
                ),
              ),
              sWidthSpan,
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE').format(_selectedDate),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    Text(
                      DateFormat('MMMM yyyy').format(_selectedDate),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: _white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── MONTH NAV ────────────────────────────────
  Widget _buildMonthNavigator() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavButton(
            icon: Icons.chevron_left_rounded,
            onTap: () => _changeMonth(-1),
          ),
          Text(
            DateFormat('MMMM  yyyy').format(_focusedMonth),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
              letterSpacing: 0.3,
            ),
          ),
          _NavButton(
            icon: Icons.chevron_right_rounded,
            onTap: () => _changeMonth(1),
          ),
        ],
      ),
    );
  }

  // ── WEEK DAYS ────────────────────────────────
  Widget _buildWeekDayRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _weekDays
            .map(
              (d) => SizedBox(
                width: 32.w,
                child: Center(
                  child: Text(
                    d,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: d == 'Sa' || d == 'Su'
                          ? _accentColor.withValues(alpha: 0.55)
                          : _textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ── CALENDAR GRID ────────────────────────────
  Widget _buildCalendarGrid(List<DateTime?> days) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.0,
            ),
            itemCount: days.length,
            itemBuilder: (_, i) => _buildDayCell(days[i]),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell(DateTime? date) {
    final selected = _isSelected(date);
    final today = _isToday(date);
    final disabled = _isDisabled(date);

    return GestureDetector(
      onTap: disabled ? null : () => setState(() => _selectedDate = date!),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        margin: EdgeInsets.all(2.r),
        decoration: BoxDecoration(
          color: selected
              ? _accentColor
              : today
              ? _accentLight
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: _accentColor.withValues(alpha: 0.38),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            date != null ? '${date.day}' : '',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: selected || today ? FontWeight.w700 : FontWeight.w400,
              color: selected
                  ? _white
                  : today
                  ? _accentColor
                  : disabled
                  ? _textSecondary.withValues(alpha: 0.35)
                  : _textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  // ── FOOTER ───────────────────────────────────
  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 20.h),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 13.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  side: BorderSide(color: const Color(0xFFE2E0F0), width: 1.5),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: _textSecondary,
                ),
              ),
            ),
          ),
          mWidthSpan,
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(_selectedDate),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 13.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF3D35CC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: _accentColor.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: _white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Nav Arrow Button
// ─────────────────────────────────────────────
class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F0FF),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, size: 20.sp, color: const Color(0xFF6C63FF)),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Updated AddSubDateField  (drop-in replacement)
// ─────────────────────────────────────────────
class AddSubDateField extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onDateSelected;

  const AddSubDateField({super.key, this.initialDate, this.onDateSelected});

  @override
  State<AddSubDateField> createState() => _AddSubDateFieldState();
}

class _AddSubDateFieldState extends State<AddSubDateField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _controller.text = DateFormat('dd/MM/yyyy').format(widget.initialDate!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showCustomDatePicker(
      context: context,
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
      widget.onDateSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11.r),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: TextFormField(
        readOnly: true,
        controller: _controller,
        showCursor: false,
        enableInteractiveSelection: false,
        onTap: _selectDate,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(fontSize: 14.sp, color: Colors.black87),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 11.h,
          ),
          border: InputBorder.none,
          hintText: 'DD/MM/YYYY',
          hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey.shade400),
          suffixIcon: Icon(
            Icons.calendar_today_outlined,
            size: 18.sp,
            color: Colors.grey.shade500,
          ),
          suffixIconConstraints: BoxConstraints(
            minWidth: 44.w,
            minHeight: 44.h,
          ),
        ),
      ),
    );
  }
}
