// lib/core/widgets/searchable_dropdown.dart
import 'package:flutter/material.dart';

class SearchableDropdown<T extends Object> extends StatelessWidget {
  const SearchableDropdown({
    super.key,
    required this.items,
    required this.displayStringForOption,
    required this.onSelected,
    this.initialText,
    this.enabled = true,
    this.labelText = 'Select',
    this.errorText,
    this.filter,
    this.prefixIcon,
  });

  final List<T> items;
  final String Function(T) displayStringForOption;
  final ValueChanged<T> onSelected;
  final String? initialText;
  final bool enabled;
  final String labelText;
  final String? errorText;
  final Widget? prefixIcon;

  /// Optional custom filter. Defaults to case-insensitive substring match
  /// on displayStringForOption.
  final bool Function(T item, String query)? filter;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<T>(
      displayStringForOption: displayStringForOption,
      initialValue: initialText != null
          ? TextEditingValue(text: initialText!)
          : null,
      optionsBuilder: (textEditingValue) {
        final query = textEditingValue.text.trim().toLowerCase();
        if (query.isEmpty) return items;
        return items.where((item) {
          if (filter != null) return filter!(item, query);
          return displayStringForOption(item).toLowerCase().contains(query);
        });
      },
      onSelected: enabled ? onSelected : (_) {},
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: labelText,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: const Icon(Icons.search, size: 18),
          ),
          onSubmitted: (_) => onFieldSubmitted(),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220, maxWidth: 320),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final item = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(item),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Text(
                        displayStringForOption(item),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
