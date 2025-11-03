import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FilterPanel extends StatefulWidget {
  final List<FilterSection> sections;
  final VoidCallback onClearAll;
  final VoidCallback onClose;
  final bool hasActiveFilters;
  final int activeFilterCount;
  final double? maxHeight;
  final EdgeInsetsGeometry? padding;

  const FilterPanel({
    super.key,
    required this.sections,
    required this.onClearAll,
    required this.onClose,
    required this.hasActiveFilters,
    required this.activeFilterCount,
    this.maxHeight,
    this.padding,
  });

  @override
  FilterPanelState createState() => FilterPanelState();
}

class FilterPanelState extends State<FilterPanel> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: widget.padding ?? const EdgeInsets.all(8),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: widget.maxHeight ?? MediaQuery.of(context).size.height * 0.7,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16), // Fixed: removed const from Column
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              Expanded(
                child: _buildFilterContent(), // Fixed: removed const
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Filter Options',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green[900],
          ),
        ),
        Row(
          children: [
            if (widget.hasActiveFilters)
              TextButton(
                onPressed: widget.onClearAll,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.orange,
                ),
                child: const Text(
                  'Clear All',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            IconButton(
              icon: const Icon(LucideIcons.x, size: 20),
              onPressed: widget.onClose,
              tooltip: 'Close filters',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterContent() {
    if (widget.sections.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(LucideIcons.filter, size: 32, color: Colors.grey[400]),
            ),
            const SizedBox(height: 8),
            Text(
              'No filters available',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        ...widget.sections.map((section) => _buildFilterSection(section)),
        const SizedBox(height: 8),
        _buildActiveFiltersBadge(),
      ],
    );
  }

  Widget _buildFilterSection(FilterSection section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              section.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          _buildFilterSectionContent(section),
        ],
      ),
    );
  }

  Widget _buildFilterSectionContent(FilterSection section) {
    switch (section.type) {
      case FilterType.checkboxList:
        return _buildCheckboxList(section);
      case FilterType.chipList:
        return _buildChipList(section);
      case FilterType.dropdown:
        return _buildDropdown(section);
      case FilterType.rangeSlider:
        return _buildRangeSlider(section);
      case FilterType.toggleButtons:
        return _buildToggleButtons(section);
      case FilterType.multiSelectDropdown:
        return _buildMultiSelectDropdown(section);
    }
  }

  Widget _buildCheckboxList(FilterSection section) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: section.options.map((option) {
        final isSelected = section.selectedOptions.contains(option);
        return CheckboxListTile(
          title: Text(
            option,
            style: const TextStyle(fontSize: 14),
          ),
          value: isSelected,
          onChanged: section.enabled ? (selected) {
            section.onOptionSelected(option, selected ?? false);
          } : null,
          dense: true,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        );
      }).toList(),
    );
  }

  Widget _buildChipList(FilterSection section) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: section.options.map((option) {
        final isSelected = section.selectedOptions.contains(option);
        return FilterChip(
          label: Text(
            option,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
          ),
          selected: isSelected,
          onSelected: section.enabled ? (selected) {
            section.onOptionSelected(option, selected);
          } : null,
          backgroundColor: isSelected ? Colors.orange : Colors.grey[100],
          selectedColor: Colors.orange,
          checkmarkColor: Colors.white,
          shape: StadiumBorder(
            side: BorderSide(
              color: isSelected ? Colors.orange : Colors.grey[300]!,
              width: 1,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDropdown(FilterSection section) {
    return DropdownButtonFormField<String>(
      value: section.selectedOptions.isNotEmpty ? section.selectedOptions.first : null,
      items: section.options.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: section.enabled ? (value) {
        if (value != null) {
          // Clear previous selection and select new one
          for (var option in section.options) {
            if (option != value) {
              section.onOptionSelected(option, false);
            }
          }
          section.onOptionSelected(value, true);
        }
      } : null,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        hintText: section.hintText ?? 'Select an option',
      ),
      isExpanded: true,
    );
  }

  Widget _buildRangeSlider(FilterSection section) {
    final values = section.rangeValues;
    if (values == null) return Container();

    return Column(
      children: [
        RangeSlider(
          values: values,
          min: section.minValue ?? 0,
          max: section.maxValue ?? 100,
          divisions: section.divisions ?? 10,
          labels: RangeLabels(
            section.formatValue?.call(values.start) ?? values.start.round().toString(),
            section.formatValue?.call(values.end) ?? values.end.round().toString(),
          ),
          onChanged: section.enabled ? (newValues) {
            section.onRangeChanged?.call(newValues);
          } : null,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              section.formatValue?.call(values.start) ?? values.start.round().toString(),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              section.formatValue?.call(values.end) ?? values.end.round().toString(),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleButtons(FilterSection section) {
    return ToggleButtons(
      isSelected: section.options.map((option) => section.selectedOptions.contains(option)).toList(),
      onPressed: section.enabled ? (index) {
        final option = section.options[index];
        final isSelected = section.selectedOptions.contains(option);
        section.onOptionSelected(option, !isSelected);
      } : null,
      borderRadius: BorderRadius.circular(8),
      constraints: const BoxConstraints.expand(height: 36),
      selectedColor: Colors.white,
      fillColor: Colors.orange,
      color: Colors.grey[600],
      children: section.options.map((option) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(option, style: const TextStyle(fontSize: 12)),
      )).toList(),
    );
  }

  Widget _buildMultiSelectDropdown(FilterSection section) {
    return InkWell(
      onTap: section.enabled ? () => _showMultiSelectDialog(section) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                section.selectedOptions.isEmpty
                    ? section.hintText ?? 'Select options'
                    : '${section.selectedOptions.length} selected',
                style: TextStyle(
                  color: section.selectedOptions.isEmpty ? Colors.grey[500] : Colors.grey[700],
                ),
              ),
            ),
            Icon(LucideIcons.chevronDown, size: 16, color: Colors.grey[500]),
          ],
        ),
      ),
    );
  }

  void _showMultiSelectDialog(FilterSection section) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(section.title),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: section.options.length,
            itemBuilder: (context, index) {
              final option = section.options[index];
              final isSelected = section.selectedOptions.contains(option);
              return CheckboxListTile(
                title: Text(option),
                value: isSelected,
                onChanged: (selected) {
                  section.onOptionSelected(option, selected ?? false);
                  setState(() {});
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersBadge() {
    if (!widget.hasActiveFilters) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.filter, size: 12, color: Colors.orange),
          const SizedBox(width: 4),
          Text(
            '${widget.activeFilterCount} active filter${widget.activeFilterCount != 1 ? 's' : ''}',
            style: const TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

enum FilterType {
  checkboxList,
  chipList,
  dropdown,
  rangeSlider,
  toggleButtons,
  multiSelectDropdown,
}

class FilterSection {
  final String title;
  final FilterType type;
  final List<String> options;
  final List<String> selectedOptions;
  final Function(String, bool) onOptionSelected;
  final RangeValues? rangeValues;
  final double? minValue;
  final double? maxValue;
  final int? divisions;
  final Function(RangeValues)? onRangeChanged;
  final String? hintText;
  final String? Function(double)? formatValue;
  final bool enabled;

  FilterSection({
    required this.title,
    required this.type,
    required this.options,
    required this.selectedOptions,
    required this.onOptionSelected,
    this.rangeValues,
    this.minValue,
    this.maxValue,
    this.divisions,
    this.onRangeChanged,
    this.hintText,
    this.formatValue,
    this.enabled = true,
  });
}

// Helper class for common filter configurations
class FilterConfigs {
  static FilterSection createDifficultyFilter({
    required List<String> selectedDifficulties,
    required Function(String, bool) onDifficultySelected,
    String title = 'Difficulty Level',
    bool enabled = true,
  }) {
    return FilterSection(
      title: title,
      type: FilterType.chipList,
      options: const ['Easy', 'Moderate', 'Hard'], // Added const
      selectedOptions: selectedDifficulties,
      onOptionSelected: onDifficultySelected,
      enabled: enabled,
    );
  }

  static FilterSection createActivitiesFilter({
    required List<String> selectedActivities,
    required Function(String, bool) onActivitySelected,
    required List<String> availableActivities,
    String title = 'Activities',
    bool enabled = true,
  }) {
    return FilterSection(
      title: title,
      type: FilterType.chipList,
      options: availableActivities,
      selectedOptions: selectedActivities,
      onOptionSelected: onActivitySelected,
      enabled: enabled,
    );
  }

  static FilterSection createPriceFilter({
    required RangeValues priceRange,
    required Function(RangeValues) onPriceRangeChanged,
    String title = 'Price Range',
    double minValue = 0,
    double maxValue = 1000,
    int divisions = 20,
    bool enabled = true,
  }) {
    return FilterSection(
      title: title,
      type: FilterType.rangeSlider,
      options: const [], // Added const
      selectedOptions: const [], // Added const
      onOptionSelected: (_, __) {},
      rangeValues: priceRange,
      minValue: minValue,
      maxValue: maxValue,
      divisions: divisions,
      onRangeChanged: onPriceRangeChanged,
      formatValue: (value) => '\$${value.round()}',
      enabled: enabled,
    );
  }

  static FilterSection createTrustScoreFilter({
    required RangeValues trustScoreRange,
    required Function(RangeValues) onTrustScoreRangeChanged,
    String title = 'Trust Score',
    double minValue = 0,
    double maxValue = 100,
    int divisions = 20,
    bool enabled = true,
  }) {
    return FilterSection(
      title: title,
      type: FilterType.rangeSlider,
      options: const [], // Added const
      selectedOptions: const [], // Added const
      onOptionSelected: (_, __) {},
      rangeValues: trustScoreRange,
      minValue: minValue,
      maxValue: maxValue,
      divisions: divisions,
      onRangeChanged: onTrustScoreRangeChanged,
      formatValue: (value) => '${value.round()}%',
      enabled: enabled,
    );
  }

  static FilterSection createDurationFilter({
    required String selectedDuration,
    required Function(String, bool) onDurationSelected,
    String title = 'Duration',
    bool enabled = true,
  }) {
    return FilterSection(
      title: title,
      type: FilterType.dropdown,
      options: const ['Any duration', '1-3 days', '4-7 days', '1-2 weeks', '2+ weeks'], // Added const
      selectedOptions: selectedDuration.isNotEmpty ? [selectedDuration] : [],
      onOptionSelected: onDurationSelected,
      hintText: 'Select duration',
      enabled: enabled,
    );
  }

  static FilterSection createAvailabilityFilter({
    required String selectedAvailability,
    required Function(String, bool) onAvailabilitySelected,
    String title = 'Availability',
    bool enabled = true,
  }) {
    return FilterSection(
      title: title,
      type: FilterType.dropdown,
      options: const ['All trips', 'Open slots', 'Almost full'], // Added const
      selectedOptions: selectedAvailability.isNotEmpty ? [selectedAvailability] : [],
      onOptionSelected: onAvailabilitySelected,
      hintText: 'Select availability',
      enabled: enabled,
    );
  }

  static FilterSection createLanguagesFilter({
    required List<String> selectedLanguages,
    required Function(String, bool) onLanguageSelected,
    required List<String> availableLanguages,
    String title = 'Languages',
    bool enabled = true,
  }) {
    return FilterSection(
      title: title,
      type: FilterType.multiSelectDropdown,
      options: availableLanguages,
      selectedOptions: selectedLanguages,
      onOptionSelected: onLanguageSelected,
      hintText: 'Select languages',
      enabled: enabled,
    );
  }

  static FilterSection createSafetyStatusFilter({
    required List<String> selectedStatuses,
    required Function(String, bool) onStatusSelected,
    String title = 'Safety Status',
    bool enabled = true,
  }) {
    return FilterSection(
      title: title,
      type: FilterType.toggleButtons,
      options: const ['safe', 'active', 'checking-in', 'unknown'], // Added const
      selectedOptions: selectedStatuses,
      onOptionSelected: onStatusSelected,
      enabled: enabled,
    );
  }

  static FilterSection createBooleanFilter({
    required bool isEnabled,
    required Function(String, bool) onToggle,
    required String title,
    required String optionText,
    bool enabled = true,
  }) {
    return FilterSection(
      title: title,
      type: FilterType.checkboxList,
      options: [optionText],
      selectedOptions: isEnabled ? [optionText] : [],
      onOptionSelected: (_, selected) => onToggle(optionText, selected),
      enabled: enabled,
    );
  }
}

// Custom filter chip for better styling
class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final Color? selectedColor;
  final Color? backgroundColor;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.selectedColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: selected ? Colors.white : Colors.grey[700],
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: selected,
      onSelected: (_) => onSelected(),
      backgroundColor: backgroundColor ?? Colors.grey[100],
      selectedColor: selectedColor ?? Colors.orange,
      checkmarkColor: Colors.white,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? (selectedColor ?? Colors.orange) : Colors.grey[300]!,
          width: 1,
        ),
      ),
      elevation: selected ? 2 : 0,
      shadowColor: selected ? (selectedColor ?? Colors.orange).withOpacity(0.5) : Colors.transparent,
    );
  }
}

// Utility extension for filter operations
extension FilterSectionExtensions on FilterSection {
  bool get hasActiveFilters {
    switch (type) {
      case FilterType.checkboxList:
      case FilterType.chipList:
      case FilterType.toggleButtons:
      case FilterType.multiSelectDropdown:
        return selectedOptions.isNotEmpty;
      case FilterType.dropdown:
        return selectedOptions.isNotEmpty && selectedOptions.first != 'Any duration' && selectedOptions.first != 'All trips';
      case FilterType.rangeSlider:
        return rangeValues != null && 
               (rangeValues!.start > (minValue ?? 0) || rangeValues!.end < (maxValue ?? 100));
    }
  }

  void clear() {
    for (final option in options) {
      onOptionSelected(option, false);
    }
    if (type == FilterType.rangeSlider && onRangeChanged != null) {
      onRangeChanged!(RangeValues(minValue ?? 0, maxValue ?? 100));
    }
  }
}