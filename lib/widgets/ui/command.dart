import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import

class CommandPalette extends StatefulWidget {
  final List<CommandGroup> groups;
  final String title;
  final String description;
  final String searchPlaceholder;
  final bool showDialog;
  final ValueChanged<String>? onQueryChanged;
  final Widget? trigger;

  const CommandPalette({
    super.key,
    required this.groups,
    this.title = 'Command Palette',
    this.description = 'Search for a command to run...',
    this.searchPlaceholder = 'Search...',
    this.showDialog = true,
    this.onQueryChanged,
    this.trigger,
  });

  @override
  State<CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends State<CommandPalette> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final List<CommandItem> _filteredItems = [];
  int _selectedIndex = 0;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _filterItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterItems();
    widget.onQueryChanged?.call(_searchController.text);
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems.clear();
      
      for (final group in widget.groups) {
        for (final item in group.items) {
          if (query.isEmpty || 
              item.label.toLowerCase().contains(query) ||
              (item.keywords != null && item.keywords!.any((keyword) => keyword.toLowerCase().contains(query)))) {
            _filteredItems.add(item);
          }
        }
      }
      
      _selectedIndex = _filteredItems.isNotEmpty ? 0 : -1;
    });
  }

  void _openCommandPalette() {
    setState(() {
      _isOpen = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  void _closeCommandPalette() {
    setState(() {
      _isOpen = false;
      _searchController.clear();
      _selectedIndex = 0;
    });
  }

  void _executeCommand(CommandItem item) {
    item.onSelected?.call();
    _closeCommandPalette();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          if (_filteredItems.isNotEmpty) {
            _selectedIndex = (_selectedIndex + 1) % _filteredItems.length;
          }
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          if (_filteredItems.isNotEmpty) {
            _selectedIndex = (_selectedIndex - 1) % _filteredItems.length;
            if (_selectedIndex < 0) _selectedIndex = _filteredItems.length - 1;
          }
        });
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (_selectedIndex >= 0 && _selectedIndex < _filteredItems.length) {
          _executeCommand(_filteredItems[_selectedIndex]);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        _closeCommandPalette();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyK): 
            const _OpenCommandIntent(),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyK): 
            const _OpenCommandIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _OpenCommandIntent: CallbackAction<_OpenCommandIntent>(
            onInvoke: (_) {
              _openCommandPalette();
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Column(
            children: [
              if (widget.trigger != null)
                GestureDetector(
                  onTap: _openCommandPalette,
                  child: widget.trigger,
                ),
              
              if (_isOpen && widget.showDialog)
                _CommandDialog(
                  title: widget.title,
                  description: widget.description,
                  onClose: _closeCommandPalette,
                  child: _buildCommandContent(),
                )
              else if (_isOpen)
                _buildCommandContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommandContent() {
    return Focus(
      onKey: (node, event) {
        _handleKeyEvent(event);
        return KeyEventResult.handled;
      },
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 400),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search input
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText: widget.searchPlaceholder,
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),

            // Separator
            Divider(
              height: 1,
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),

            // Command list
            Expanded(
              child: _filteredItems.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return _CommandItem(
                          item: item,
                          isSelected: index == _selectedIndex,
                          onTap: () => _executeCommand(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          'No results found',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

class _CommandDialog extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onClose;
  final Widget child;

  const _CommandDialog({
    required this.title,
    required this.description,
    required this.onClose,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: child,
        ),
      ),
    );
  }
}

class _CommandItem extends StatelessWidget {
  final CommandItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _CommandItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected 
          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (item.description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (item.shortcut != null) ...[
                const SizedBox(width: 12),
                _CommandShortcut(shortcut: item.shortcut!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CommandShortcut extends StatelessWidget {
  final String shortcut;

  const _CommandShortcut({required this.shortcut});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        shortcut,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class CommandGroup {
  final String? label;
  final List<CommandItem> items;

  const CommandGroup({
    this.label,
    required this.items,
  });
}

class CommandItem {
  final String label;
  final String? description;
  final IconData? icon;
  final String? shortcut;
  final List<String>? keywords;
  final VoidCallback? onSelected;

  const CommandItem({
    required this.label,
    this.description,
    this.icon,
    this.shortcut,
    this.keywords,
    this.onSelected,
  });
}

class _OpenCommandIntent extends Intent {
  const _OpenCommandIntent();
}