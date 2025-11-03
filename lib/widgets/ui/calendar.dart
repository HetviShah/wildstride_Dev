import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  final DateTime? focusedDay;
  final DateTime? selectedDay;
  final DateTime? startDay;
  final DateTime? endDay;
  final Function(DateTime, DateTime)? onRangeSelected;
  final Function(DateTime, DateTime)? onDaySelected;
  final bool showOutsideDays;
  final CalendarFormat calendarFormat;
  final HeaderStyle? headerStyle;
  final DaysOfWeekStyle? daysOfWeekStyle;
  final CalendarStyle? calendarStyle;
  final bool sixWeekMonthsEnforced;
  final bool weekendDays;

  const Calendar({
    super.key,
    this.focusedDay,
    this.selectedDay,
    this.startDay,
    this.endDay,
    this.onRangeSelected,
    this.onDaySelected,
    this.showOutsideDays = true,
    this.calendarFormat = CalendarFormat.month,
    this.headerStyle,
    this.daysOfWeekStyle,
    this.calendarStyle,
    this.sixWeekMonthsEnforced = true,
    this.weekendDays = true,
  });

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  DateTime? _startDay;
  DateTime? _endDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.focusedDay ?? DateTime.now();
    _selectedDay = widget.selectedDay;
    _startDay = widget.startDay;
    _endDay = widget.endDay;
    _calendarFormat = widget.calendarFormat;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        rangeStartDay: _startDay,
        rangeEndDay: _endDay,
        onDaySelected: _handleDaySelected,
        onRangeSelected: _handleRangeSelected,
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
          CalendarFormat.twoWeeks: '2 Weeks',
          CalendarFormat.week: 'Week',
        },
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarFormat: _calendarFormat,
        // Removed showWeekNumbers parameter as it doesn't exist in table_calendar
        weekendDays: widget.weekendDays ? [DateTime.saturday, DateTime.sunday] : [],
        sixWeekMonthsEnforced: widget.sixWeekMonthsEnforced,
        shouldFillViewport: widget.showOutsideDays,
        headerStyle: widget.headerStyle ?? _buildHeaderStyle(colorScheme),
        daysOfWeekStyle: widget.daysOfWeekStyle ?? _buildDaysOfWeekStyle(colorScheme),
        calendarStyle: widget.calendarStyle ?? _buildCalendarStyle(colorScheme, theme),
        calendarBuilders: CalendarBuilders(
          headerTitleBuilder: (context, day) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                _formatHeaderTitle(day),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ) ?? const TextStyle(fontWeight: FontWeight.w500),
              ),
            );
          },
          todayBuilder: (context, day, focusedDay) {
            return _buildDayContainer(
              day: day,
              isToday: true,
              isSelected: isSameDay(_selectedDay, day),
              isInRange: _isInRange(day),
              isRangeStart: isSameDay(_startDay, day),
              isRangeEnd: isSameDay(_endDay, day),
              theme: theme,
              colorScheme: colorScheme,
            );
          },
          defaultBuilder: (context, day, focusedDay) {
            return _buildDayContainer(
              day: day,
              isToday: false,
              isSelected: isSameDay(_selectedDay, day),
              isInRange: _isInRange(day),
              isRangeStart: isSameDay(_startDay, day),
              isRangeEnd: isSameDay(_endDay, day),
              theme: theme,
              colorScheme: colorScheme,
            );
          },
        ),
      ),
    );
  }

  void _handleDaySelected(DateTime? selectedDay, DateTime focusedDay) {
    if (selectedDay == null) return;
    
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _startDay = null;
      _endDay = null;
    });
    widget.onDaySelected?.call(selectedDay, focusedDay);
  }

  void _handleRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _startDay = start;
      _endDay = end;
      _focusedDay = focusedDay;
    });
    if (start != null && end != null) {
      widget.onRangeSelected?.call(start, end);
    }
  }

  bool _isInRange(DateTime day) {
    if (_startDay == null || _endDay == null) return false;
    return (day.isAfter(_startDay!) || isSameDay(day, _startDay)) &&
           (day.isBefore(_endDay!) || isSameDay(day, _endDay));
  }

  String _formatHeaderTitle(DateTime day) {
    return '${_getMonthName(day.month)} ${day.year}';
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }

  Widget _buildDayContainer({
    required DateTime day,
    required bool isToday,
    required bool isSelected,
    required bool isInRange,
    required bool isRangeStart,
    required bool isRangeEnd,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    final isOutsideMonth = day.month != _focusedDay.month;
    final isDisabled = day.isAfter(DateTime.utc(2030, 12, 31)) || 
                      day.isBefore(DateTime.utc(2010, 1, 1));

    Color backgroundColor = Colors.transparent;
    Color textColor = colorScheme.onSurface.withOpacity(0.6);
    BorderRadius borderRadius = BorderRadius.zero;

    if (isSelected) {
      backgroundColor = colorScheme.primary;
      textColor = colorScheme.onPrimary;
      borderRadius = BorderRadius.circular(4);
    } else if (isToday) {
      backgroundColor = colorScheme.surfaceVariant;
      textColor = colorScheme.onSurface;
      borderRadius = BorderRadius.circular(4);
    } else if (isInRange) {
      backgroundColor = colorScheme.surfaceVariant.withOpacity(0.3);
      textColor = colorScheme.onSurface;
    }

    if (isRangeStart) {
      borderRadius = const BorderRadius.horizontal(left: Radius.circular(4));
    } else if (isRangeEnd) {
      borderRadius = const BorderRadius.horizontal(right: Radius.circular(4));
    }

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Text(
          day.day.toString(),
          style: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
            color: isDisabled 
                ? colorScheme.onSurface.withOpacity(0.3)
                : isOutsideMonth
                    ? colorScheme.onSurface.withOpacity(0.3)
                    : textColor,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  HeaderStyle _buildHeaderStyle(ColorScheme colorScheme) {
    return HeaderStyle(
      titleCentered: true,
      formatButtonVisible: false,
      titleTextStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      leftChevronIcon: Icon(
        Icons.chevron_left,
        color: colorScheme.onSurface.withOpacity(0.5),
        size: 16,
      ),
      rightChevronIcon: Icon(
        Icons.chevron_right,
        color: colorScheme.onSurface.withOpacity(0.5),
        size: 16,
      ),
      headerPadding: const EdgeInsets.symmetric(vertical: 8),
    );
  }

  DaysOfWeekStyle _buildDaysOfWeekStyle(ColorScheme colorScheme) {
    return DaysOfWeekStyle(
      weekdayStyle: TextStyle(
        color: colorScheme.onSurface.withOpacity(0.6),
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      weekendStyle: TextStyle(
        color: colorScheme.onSurface.withOpacity(0.6),
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  CalendarStyle _buildCalendarStyle(ColorScheme colorScheme, ThemeData theme) {
    final defaultTextStyle = theme.textTheme.bodyMedium ?? const TextStyle();
    
    return CalendarStyle(
      outsideDaysVisible: widget.showOutsideDays,
      outsideTextStyle: defaultTextStyle.copyWith(
        color: colorScheme.onSurface.withOpacity(0.3),
      ),
      disabledTextStyle: defaultTextStyle.copyWith(
        color: colorScheme.onSurface.withOpacity(0.3),
      ),
      weekendTextStyle: defaultTextStyle.copyWith(
        color: colorScheme.onSurface.withOpacity(0.6),
      ),
      defaultTextStyle: defaultTextStyle.copyWith(
        color: colorScheme.onSurface.withOpacity(0.6),
      ),
      selectedTextStyle: defaultTextStyle.copyWith(
        color: colorScheme.onPrimary,
        fontWeight: FontWeight.w500,
      ),
      todayTextStyle: defaultTextStyle.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
      cellPadding: const EdgeInsets.all(2),
    );
  }
}