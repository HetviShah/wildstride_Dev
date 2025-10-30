import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  final Widget? child;
  final List<TableRow>? rows;
  final String? dataSlot;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  final List<BoxShadow>? boxShadow;
  final BorderRadius? borderRadius;
  final TableBorder? border;
  final Map<int, TableColumnWidth>? columnWidths;
  final TextDirection? textDirection;
  final TableColumnWidth defaultColumnWidth;
  final TextBaseline? textBaseline;

  const CustomTable({
    super.key,
    this.child,
    this.rows,
    this.dataSlot,
    this.padding,
    this.decoration,
    this.boxShadow,
    this.borderRadius,
    this.border,
    this.columnWidths,
    this.textDirection,
    this.defaultColumnWidth = const FlexColumnWidth(),
    this.textBaseline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16.0),
      decoration: decoration ??
          BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(8.0),
            boxShadow: boxShadow ??
                [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
          ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: child ??
            Table(
              border: border,
              columnWidths: columnWidths,
              defaultColumnWidth: defaultColumnWidth,
              textDirection: textDirection,
              textBaseline: textBaseline,
              children: rows ?? [],
            ),
      ),
    );
  }
}

class TableHeader extends StatelessWidget {
  final List<Widget> children;
  final String? dataSlot;
  final Color? backgroundColor;
  final TableBorder? border;

  const TableHeader({
    super.key,
    required this.children,
    this.dataSlot,
    this.backgroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade100,
      ),
      child: Table(
        border: border ?? const TableBorder(bottom: BorderSide(color: Colors.grey)),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.grey.shade100,
            ),
            children: children,
          ),
        ],
      ),
    );
  }
}

class TableBody extends StatelessWidget {
  final List<TableRow> children;
  final String? dataSlot;
  final Color? rowColor;
  final Color? alternateRowColor;
  final TableBorder? border;

  const TableBody({
    super.key,
    required this.children,
    this.dataSlot,
    this.rowColor,
    this.alternateRowColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      border: border,
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final row = entry.value;
        final isEven = index % 2 == 0;
        
        return TableRow(
          decoration: BoxDecoration(
            color: isEven 
                ? (alternateRowColor ?? Colors.grey.shade50) 
                : (rowColor ?? Colors.transparent),
          ),
          children: row.children,
        );
      }).toList(),
    );
  }
}

class TableFooter extends StatelessWidget {
  final List<Widget> children;
  final String? dataSlot;
  final Color? backgroundColor;
  final TableBorder? border;

  const TableFooter({
    super.key,
    required this.children,
    this.dataSlot,
    this.backgroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade100,
      ),
      child: Table(
        border: border ?? const TableBorder(top: BorderSide(color: Colors.grey)),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.grey.shade100,
            ),
            children: children,
          ),
        ],
      ),
    );
  }
}

class CustomTableRow extends StatelessWidget {
  final List<Widget> children;
  final String? dataSlot;
  final Decoration? decoration;
  final VoidCallback? onTap;
  final bool selected;
  final Color? hoverColor;
  final TableBorder? border;

  const CustomTableRow({
    super.key,
    required this.children,
    this.dataSlot,
    this.decoration,
    this.onTap,
    this.selected = false,
    this.hoverColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected 
          ? (hoverColor ?? Colors.blue.shade50) 
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: hoverColor ?? Colors.grey.shade100,
        child: Table(
          border: border,
          children: [
            TableRow(
              decoration: decoration,
              children: children,
            ),
          ],
        ),
      ),
    );
  }
}

class TableHead extends StatelessWidget {
  final Widget child;
  final String? dataSlot;
  final TableCellVerticalAlignment? verticalAlignment;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final bool hasCheckbox;

  const TableHead({
    super.key,
    required this.child,
    this.dataSlot,
    this.verticalAlignment,
    this.padding,
    this.textStyle,
    this.hasCheckbox = false,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: verticalAlignment ?? TableCellVerticalAlignment.middle,
      child: Container(
        padding: padding ?? const EdgeInsets.all(12.0),
        child: DefaultTextStyle(
          style: textStyle ?? 
              const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
          child: child,
        ),
      ),
    );
  }
}

class TableCellWidget extends StatelessWidget {
  final Widget child;
  final String? dataSlot;
  final TableCellVerticalAlignment? verticalAlignment;
  final EdgeInsetsGeometry? padding;
  final bool hasCheckbox;

  const TableCellWidget({
    super.key,
    required this.child,
    this.dataSlot,
    this.verticalAlignment,
    this.padding,
    this.hasCheckbox = false,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: verticalAlignment ?? TableCellVerticalAlignment.middle,
      child: Container(
        padding: padding ?? const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }
}

class TableCaption extends StatelessWidget {
  final Widget child;
  final String? dataSlot;
  final EdgeInsetsGeometry? margin;
  final TextStyle? textStyle;

  const TableCaption({
    super.key,
    required this.child,
    this.dataSlot,
    this.margin,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(top: 16.0),
      child: DefaultTextStyle(
        style: textStyle ?? 
            TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
        child: child,
      ),
    );
  }
}

// Utility class with proper type handling
class TableUtils {
  static BoxDecoration mergeDecorations(List<BoxDecoration?> decorations) {
    BoxDecoration result = const BoxDecoration();
    for (final decoration in decorations) {
      if (decoration != null) {
        result = result.copyWith(
          color: decoration.color ?? result.color,
          border: decoration.border ?? result.border,
          borderRadius: decoration.borderRadius ?? result.borderRadius,
          boxShadow: decoration.boxShadow ?? result.boxShadow,
        );
      }
    }
    return result;
  }
  
  static EdgeInsets mergePadding(List<EdgeInsetsGeometry?> paddingList) {
    EdgeInsets result = EdgeInsets.zero;
    for (final padding in paddingList) {
      if (padding != null) {
        // Properly handle EdgeInsetsGeometry to EdgeInsets conversion
        final resolvedPadding = padding.resolve(TextDirection.ltr);
        result = EdgeInsets.only(
          left: result.left + resolvedPadding.left,
          right: result.right + resolvedPadding.right,
          top: result.top + resolvedPadding.top,
          bottom: result.bottom + resolvedPadding.bottom,
        );
      }
    }
    return result;
  }
}

// Corrected implementation using proper DataTable parameters
class AdvancedDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final bool showCheckboxColumn;
  final DataRow? selectedRow;
  final ValueChanged<bool?>? onSelectAll;
  final double dataRowMinHeight;
  final double dataRowMaxHeight;
  final double headingRowHeight;
  final double horizontalMargin;
  final double columnSpacing;
  final bool showBottomBorder;
  final int? sortColumnIndex;
  final bool sortAscending;

  const AdvancedDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.showCheckboxColumn = false,
    this.selectedRow,
    this.onSelectAll,
    this.dataRowMinHeight = kMinInteractiveDimension,
    this.dataRowMaxHeight = double.infinity,
    this.headingRowHeight = 56.0,
    this.horizontalMargin = 24.0,
    this.columnSpacing = 56.0,
    this.showBottomBorder = false,
    this.sortColumnIndex,
    this.sortAscending = true,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: columns,
      rows: rows,
      showCheckboxColumn: showCheckboxColumn,
      onSelectAll: onSelectAll,
      dataRowMinHeight: dataRowMinHeight,
      dataRowMaxHeight: dataRowMaxHeight,
      headingRowHeight: headingRowHeight,
      horizontalMargin: horizontalMargin,
      columnSpacing: columnSpacing,
      showBottomBorder: showBottomBorder,
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );
  }
}

// Example usage with proper implementation
class TableExample extends StatelessWidget {
  const TableExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Table Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic DataTable example
            const Text('Basic DataTable', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            CustomTable(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Age')),
                  DataColumn(label: Text('Status')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('John Doe')),
                    DataCell(Text('30')),
                    DataCell(Text('Active')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Jane Smith')),
                    DataCell(Text('25')),
                    DataCell(Text('Inactive')),
                  ]),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Custom table using Flutter's Table widget
            const Text('Custom Table Widget', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            CustomTable(
              border: TableBorder.all(color: Colors.grey.shade300),
              rows: [
                // Header row
                TableRow(
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                  ),
                  children: [
                    TableCellWidget(
                      child: Text('Product', 
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    TableCellWidget(
                      child: Text('Price', 
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    TableCellWidget(
                      child: Text('Stock', 
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                // Data rows
                const TableRow(
                  children: [
                    TableCellWidget(child: Text('Laptop')),
                    TableCellWidget(child: Text('\$999.99')),
                    TableCellWidget(child: Text('15')),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                  ),
                  children: const [
                    TableCellWidget(child: Text('Mouse')),
                    TableCellWidget(child: Text('\$29.99')),
                    TableCellWidget(child: Text('42')),
                  ],
                ),
                const TableRow(
                  children: [
                    TableCellWidget(child: Text('Keyboard')),
                    TableCellWidget(child: Text('\$79.99')),
                    TableCellWidget(child: Text('23')),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Advanced DataTable example
            const Text('Advanced DataTable', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            AdvancedDataTable(
              columns: const [
                DataColumn(
                  label: Text('Name'),
                  tooltip: 'Customer name',
                ),
                DataColumn(
                  label: Text('Age'),
                  numeric: true,
                ),
                DataColumn(
                  label: Text('Status'),
                ),
              ],
              rows: [
                DataRow(
                  cells: [
                    const DataCell(Text('John Doe')),
                    const DataCell(Text('30')),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Active', style: TextStyle(color: Colors.green.shade800)),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    const DataCell(Text('Jane Smith')),
                    const DataCell(Text('25')),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Inactive', style: TextStyle(color: Colors.red.shade800)),
                      ),
                    ),
                  ],
                ),
              ],
              showCheckboxColumn: true,
              headingRowHeight: 40.0,
            ),
            
            const SizedBox(height: 16),
            
            // Table with caption
            const TableCaption(
              child: Text('This is a table caption describing the content above.'),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple table builder for common use cases
class SimpleTableBuilder {
  static Widget buildSimpleTable({
    required List<String> headers,
    required List<List<String>> data,
    Color? headerBackgroundColor,
    Color? rowBackgroundColor,
    Color? alternateRowBackgroundColor,
    TableBorder? border,
  }) {
    return CustomTable(
      border: border ?? TableBorder.all(color: Colors.grey.shade300),
      rows: [
        // Header row
        TableRow(
          decoration: BoxDecoration(
            color: headerBackgroundColor ?? Colors.blue.shade50,
          ),
          children: headers.map((header) => 
            TableCellWidget(
              child: Text(header, style: const TextStyle(fontWeight: FontWeight.bold)),
            )
          ).toList(),
        ),
        // Data rows
        ...data.asMap().entries.map((entry) {
          final index = entry.key;
          final rowData = entry.value;
          final isEven = index % 2 == 0;
          
          return TableRow(
            decoration: BoxDecoration(
              color: isEven 
                  ? (alternateRowBackgroundColor ?? Colors.grey.shade50)
                  : (rowBackgroundColor ?? Colors.transparent),
            ),
            children: rowData.map((cell) => 
              TableCellWidget(child: Text(cell))
            ).toList(),
          );
        }),
      ],
    );
  }
}