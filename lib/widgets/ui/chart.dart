import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

typedef ChartConfig = Map<String, ChartSeriesConfig>;

class ChartSeriesConfig {
  final String? label;
  final IconData? icon;
  final Color? color;
  final Map<String, Color>? themeColors;

  const ChartSeriesConfig({
    this.label,
    this.icon,
    this.color,
    this.themeColors,
  });
}

class ChartContainer extends StatefulWidget {
  final List<CartesianSeries<dynamic, dynamic>> series;
  final ChartConfig config;
  final Widget? title;
  final bool? enableLegend;
  final bool? enableTooltip;
  final ChartType? chartType;
  final bool? isVertical;
  final Color? backgroundColor;
  final double? aspectRatio;

  const ChartContainer({
    super.key,
    required this.series,
    required this.config,
    this.title,
    this.enableLegend = true,
    this.enableTooltip = true,
    this.chartType = ChartType.line,
    this.isVertical = false,
    this.backgroundColor,
    this.aspectRatio = 16 / 9,
  });

  @override
  State<ChartContainer> createState() => _ChartContainerState();
}

class _ChartContainerState extends State<ChartContainer> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: widget.enableTooltip == true);
  }

  Color _getSeriesColor(String seriesName, Brightness brightness) {
    final config = widget.config[seriesName];
    if (config == null) return Colors.blue;

    if (config.color != null) {
      return config.color!;
    }

    if (config.themeColors != null) {
      final themeKey = brightness == Brightness.dark ? 'dark' : 'light';
      return config.themeColors![themeKey] ?? Colors.blue;
    }

    return Colors.blue;
  }

  List<CartesianSeries<dynamic, dynamic>> _getStyledSeries(Brightness brightness) {
    return widget.series.map((originalSeries) {
      final seriesColor = _getSeriesColor(originalSeries.name ?? '', brightness);

      // Instead of trying to reuse the mappers, we'll create new series
      // with the same data but styled according to our config
      if (originalSeries is LineSeries<dynamic, dynamic>) {
        return LineSeries<dynamic, dynamic>(
          dataSource: originalSeries.dataSource,
          xValueMapper: (dynamic data, int index) => _getXValue(originalSeries, data, index),
          yValueMapper: (dynamic data, int index) => _getYValue(originalSeries, data, index),
          name: originalSeries.name,
          color: seriesColor,
          markerSettings: MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.circle,
            borderWidth: 2,
            borderColor: seriesColor,
            color: Colors.white,
          ),
        );
      } else if (originalSeries is ColumnSeries<dynamic, dynamic>) {
        return ColumnSeries<dynamic, dynamic>(
          dataSource: originalSeries.dataSource,
          xValueMapper: (dynamic data, int index) => _getXValue(originalSeries, data, index),
          yValueMapper: (dynamic data, int index) => _getYValue(originalSeries, data, index),
          name: originalSeries.name,
          color: seriesColor,
        );
      } else if (originalSeries is BarSeries<dynamic, dynamic>) {
        return BarSeries<dynamic, dynamic>(
          dataSource: originalSeries.dataSource,
          xValueMapper: (dynamic data, int index) => _getXValue(originalSeries, data, index),
          yValueMapper: (dynamic data, int index) => _getYValue(originalSeries, data, index),
          name: originalSeries.name,
          color: seriesColor,
        );
      }

      return originalSeries;
    }).toList();
  }

  dynamic _getXValue(CartesianSeries<dynamic, dynamic> series, dynamic data, int index) {
    // For ChartData objects, use the x property
    if (data is ChartData) {
      return data.x;
    }
    
    // For other data types, try to extract value based on common patterns
    if (data is Map<String, dynamic>) {
      return data['x'] ?? data['month'] ?? data['name'] ?? data['label'] ?? index;
    }
    
    // Fallback to index if we can't determine the x value
    return index;
  }

  dynamic _getYValue(CartesianSeries<dynamic, dynamic> series, dynamic data, int index) {
    // For ChartData objects, use the y property
    if (data is ChartData) {
      return data.y;
    }
    
    // For other data types, try to extract value based on common patterns
    if (data is Map<String, dynamic>) {
      return data['y'] ?? data['value'] ?? data['sales'] ?? data['revenue'] ?? data['quantity'] ?? 0;
    }
    
    // If it's a numeric type, use it directly
    if (data is num) {
      return data;
    }
    
    // Fallback to 0 if we can't determine the y value
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return AspectRatio(
      aspectRatio: widget.aspectRatio!,
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? theme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null) ...[
              widget.title!,
              const SizedBox(height: 16),
            ],
            Expanded(
              child: SfCartesianChart(
                plotAreaBackgroundColor: Colors.transparent,
                primaryXAxis: CategoryAxis(
                  axisLine: const AxisLine(width: 0),
                  majorGridLines: const MajorGridLines(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 0),
                  majorGridLines: MajorGridLines(
                    color: theme.colorScheme.outline.withOpacity(0.3),
                    width: 1,
                  ),
                  majorTickLines: const MajorTickLines(size: 0),
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                tooltipBehavior: _tooltipBehavior,
                legend: Legend(
                  isVisible: widget.enableLegend == true,
                  position: LegendPosition.bottom,
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                series: _getStyledSeries(brightness),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartTooltip extends StatelessWidget {
  final dynamic data;
  final ChartConfig config;
  final String seriesName;
  final Color seriesColor;
  final bool hideLabel;
  final bool hideIndicator;
  final String indicatorType;

  const ChartTooltip({
    super.key,
    required this.data,
    required this.config,
    required this.seriesName,
    required this.seriesColor,
    this.hideLabel = false,
    this.hideIndicator = false,
    this.indicatorType = 'dot',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final seriesConfig = config[seriesName] ?? const ChartSeriesConfig();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!hideLabel && seriesConfig.label != null) ...[
            Text(
              seriesConfig.label!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!hideIndicator) ...[
                _buildIndicator(),
                const SizedBox(width: 8),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data is ChartData) ...[
                    Text(
                      (data as ChartData).x.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      (data as ChartData).y.toString(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ] else if (data != null) ...[
                    Text(
                      data.toString(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    switch (indicatorType) {
      case 'line':
        return Container(
          width: 16,
          height: 2,
          color: seriesColor,
        );
      case 'dashed':
        return Container(
          width: 16,
          height: 2,
          decoration: BoxDecoration(
            border: Border.all(
              color: seriesColor,
              width: 1,
            ),
          ),
        );
      case 'dot':
      default:
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: seriesColor,
            shape: BoxShape.circle,
          ),
        );
    }
  }
}

class ChartLegend extends StatelessWidget {
  final List<String> seriesNames;
  final ChartConfig config;
  final bool hideIcon;
  final MainAxisAlignment alignment;

  const ChartLegend({
    super.key,
    required this.seriesNames,
    required this.config,
    this.hideIcon = false,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: seriesNames.map((seriesName) {
        final seriesConfig = config[seriesName] ?? const ChartSeriesConfig();
        final color = seriesConfig.color ?? theme.colorScheme.primary;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!hideIcon && seriesConfig.icon != null) ...[
              Icon(
                seriesConfig.icon,
                size: 12,
                color: color,
              ),
              const SizedBox(width: 4),
            ] else if (!hideIcon) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
            ],
            Text(
              seriesConfig.label ?? seriesName,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

// Base data class for chart data
class ChartData {
  final dynamic x;
  final num y;

  ChartData(this.x, this.y);
}

// Example data classes
class SalesData extends ChartData {
  final String month;
  final double sales;
  final double revenue;

  SalesData(this.month, this.sales, this.revenue) : super(month, sales);
}

class ProductData extends ChartData {
  final String name;
  final int quantity;

  ProductData(this.name, this.quantity) : super(name, quantity);
}

enum ChartType {
  line,
  bar,
  column,
  pie,
  area,
}

// Example usage:
/*
class ChartExample extends StatelessWidget {
  final List<SalesData> salesData = [
    SalesData('Jan', 35000, 28000),
    SalesData('Feb', 42000, 35000),
    SalesData('Mar', 38000, 32000),
    SalesData('Apr', 51000, 45000),
  ];

  final ChartConfig config = {
    'sales': ChartSeriesConfig(
      label: 'Sales',
      color: Colors.blue,
      themeColors: {'light': Colors.blue, 'dark': Colors.lightBlue},
    ),
    'revenue': ChartSeriesConfig(
      label: 'Revenue',
      color: Colors.green,
      themeColors: {'light': Colors.green, 'dark': Colors.lightGreen},
    ),
  };

  @override
  Widget build(BuildContext context) {
    return ChartContainer(
      series: [
        LineSeries<SalesData, String>(
          dataSource: salesData,
          xValueMapper: (SalesData sales, _) => sales.month,
          yValueMapper: (SalesData sales, _) => sales.sales,
          name: 'sales',
        ),
        LineSeries<SalesData, String>(
          dataSource: salesData,
          xValueMapper: (SalesData sales, _) => sales.month,
          yValueMapper: (SalesData sales, _) => sales.revenue,
          name: 'revenue',
        ),
      ],
      config: config,
      title: Text(
        'Monthly Sales Report',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
*/