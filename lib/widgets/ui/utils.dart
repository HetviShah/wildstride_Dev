/// Dart equivalent of clsx + tailwind-merge utility
/// Combines multiple class values intelligently
String cn(List<dynamic> inputs) {
  return _twMerge(_clsx(inputs));
}

/// Equivalent of clsx - combines class names conditionally
String _clsx(List<dynamic> inputs) {
  final classes = <String>[];

  for (final input in inputs) {
    if (input == null) continue;

    if (input is String) {
      if (input.isNotEmpty) {
        classes.add(input);
      }
    } else if (input is List) {
      // Recursively process lists
      final inner = _clsx(input.cast<dynamic>());
      if (inner.isNotEmpty) {
        classes.add(inner);
      }
    } else if (input is Map) {
      // Process maps: add key if value is truthy
      for (final entry in input.entries) {
        if (entry.value == true) {
          classes.add(entry.key);
        }
      }
    }
  }

  return classes.join(' ');
}

/// Simplified equivalent of tailwind-merge
/// Handles basic conflict resolution for common Tailwind classes
String _twMerge(String classString) {
  if (classString.isEmpty) return '';

  final classes = classString.split(' ').where((c) => c.isNotEmpty).toList();
  final conflicts = <String, Set<String>>{};
  final result = <String>[];

  // Group classes by type for conflict resolution
  for (final className in classes) {
    final type = _getClassType(className);
    if (!conflicts.containsKey(type)) {
      conflicts[type] = <String>{};
    }
    conflicts[type]!.add(className);
  }

  // Resolve conflicts by taking the last class in each group
  for (final className in classes.reversed) {
    final type = _getClassType(className);
    if (conflicts[type]!.contains(className)) {
      result.add(className);
      conflicts[type]!.remove(className);
    }
  }

  return result.reversed.join(' ');
}

/// Categorizes Tailwind classes by type for conflict resolution
String _getClassType(String className) {
  // Common Tailwind class patterns
  if (className.startsWith('m-') || className.startsWith('p-')) {
    return 'spacing';
  } else if (className.startsWith('w-') || className.startsWith('h-')) {
    return 'sizing';
  } else if (className.startsWith('bg-')) {
    return 'background';
  } else if (className.startsWith('text-')) {
    return 'text';
  } else if (className.startsWith('border-')) {
    return 'border';
  } else if (className.startsWith('rounded-')) {
    return 'border-radius';
  } else if (className.startsWith('flex-') || className.contains('flex-')) {
    return 'flex';
  } else if (className.startsWith('grid-')) {
    return 'grid';
  } else if (className.startsWith('justify-') || className.startsWith('items-')) {
    return 'alignment';
  } else if (className.startsWith('opacity-')) {
    return 'opacity';
  } else if (className.startsWith('shadow-')) {
    return 'shadow';
  }
  
  return 'other';
}

/// Extension methods for easier usage with Widget properties
extension CnExtension on List<dynamic> {
  String cn() {
    return _twMerge(_clsx(this));
  }
}

/// Helper class for conditional class building
class ClassBuilder {
  final List<dynamic> _classes = [];

  ClassBuilder add(String className, [bool condition = true]) {
    if (condition && className.isNotEmpty) {
      _classes.add(className);
    }
    return this;
  }

  ClassBuilder addAll(List<String> classNames, [bool condition = true]) {
    if (condition) {
      _classes.addAll(classNames.where((c) => c.isNotEmpty));
    }
    return this;
  }

  ClassBuilder addMap(Map<String, bool> classMap) {
    _classes.add(classMap);
    return this;
  }

  String build() {
    return _classes.cn();
  }
}