import 'package:flutter/material.dart';

class ResizablePanelGroup extends StatelessWidget {
  final List<Widget> children;
  final Axis direction;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;

  const ResizablePanelGroup({
    Key? key,
    required this.children,
    this.direction = Axis.horizontal,
    this.width,
    this.height,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: decoration,
      child: Flex(
        direction: direction,
        children: children,
      ),
    );
  }
}

class ResizablePanel extends StatelessWidget {
  final Widget child;
  final int flex;
  final double? minWidth;
  final double? minHeight;

  const ResizablePanel({
    Key? key,
    required this.child,
    this.flex = 1,
    this.minWidth,
    this.minHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minWidth ?? 0,
          minHeight: minHeight ?? 0,
        ),
        child: child,
      ),
    );
  }
}

class ResizableHandle extends StatelessWidget {
  final bool withHandle;
  final Axis direction;
  final VoidCallback? onDragStart;
  final VoidCallback? onDragEnd;
  final BoxDecoration? decoration;

  const ResizableHandle({
    Key? key,
    this.withHandle = false,
    required this.direction,
    this.onDragStart,
    this.onDragEnd,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (_) => onDragStart?.call(),
      onPanEnd: (_) => onDragEnd?.call(),
      child: Container(
        width: direction == Axis.horizontal ? 1 : double.infinity,
        height: direction == Axis.vertical ? 1 : double.infinity,
        color: decoration?.color ?? Colors.grey[300],
        child: withHandle ? _buildHandle() : null,
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: direction == Axis.horizontal ? 12 : 16,
        height: direction == Axis.vertical ? 12 : 16,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: Colors.grey[500]!),
        ),
        child: Icon(
          Icons.drag_handle,
          size: direction == Axis.horizontal ? 10 : 12,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}

// Example usage:
class ResizableExample extends StatefulWidget {
  const ResizableExample({Key? key}) : super(key: key);

  @override
  _ResizableExampleState createState() => _ResizableExampleState();
}

class _ResizableExampleState extends State<ResizableExample> {
  double _leftPanelWidth = 200;
  double _rightPanelWidth = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resizable Panels')),
      body: Row(
        children: [
          // Left Panel
          Container(
            width: _leftPanelWidth,
            color: Colors.blue[100],
            child: const Center(child: Text('Left Panel')),
          ),
          
          // Resizable Handle
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _leftPanelWidth += details.delta.dx;
                _rightPanelWidth -= details.delta.dx;
                
                // Add constraints to prevent panels from becoming too small
                if (_leftPanelWidth < 100) _leftPanelWidth = 100;
                if (_rightPanelWidth < 100) _rightPanelWidth = 100;
              });
            },
            child: Container(
              width: 4,
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.drag_handle, size: 20),
              ),
            ),
          ),
          
          // Right Panel
          Expanded(
            child: Container(
              color: Colors.green[100],
              child: const Center(child: Text('Right Panel')),
            ),
          ),
        ],
      ),
    );
  }
}

// More advanced version using LayoutBuilder for dynamic sizing
class AdvancedResizablePanels extends StatefulWidget {
  const AdvancedResizablePanels({Key? key}) : super(key: key);

  @override
  _AdvancedResizablePanelsState createState() => _AdvancedResizablePanelsState();
}

class _AdvancedResizablePanelsState extends State<AdvancedResizablePanels> {
  final List<double> _panelWeights = [0.3, 0.7]; // Initial weights for panels

  void _resizePanel(int index, double delta) {
    setState(() {
      if (delta > 0 && _panelWeights[index + 1] > 0.1) {
        // Resize right panel
        _panelWeights[index] += delta;
        _panelWeights[index + 1] -= delta;
      } else if (delta < 0 && _panelWeights[index] > 0.1) {
        // Resize left panel
        _panelWeights[index] += delta;
        _panelWeights[index + 1] -= delta;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Resizable Panels')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              // Panel 1
              SizedBox(
                width: constraints.maxWidth * _panelWeights[0],
                child: Container(
                  color: Colors.blue[100],
                  child: const Center(child: Text('Panel 1')),
                ),
              ),
              
              // Resize Handle 1
              _buildResizeHandle(0, constraints.maxWidth),
              
              // Panel 2
              Expanded(
                child: Container(
                  color: Colors.green[100],
                  child: const Center(child: Text('Panel 2')),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResizeHandle(int index, double totalWidth) {
    return GestureDetector(
      onPanUpdate: (details) {
        _resizePanel(index, details.delta.dx / totalWidth);
      },
      child: Container(
        width: 4,
        color: Colors.grey[400],
        child: const Center(
          child: Icon(Icons.drag_handle, size: 20, color: Colors.white),
        ),
      ),
    );
  }
}