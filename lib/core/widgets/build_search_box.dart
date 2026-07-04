import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class BuildSearchBox extends ConsumerWidget {
  const BuildSearchBox({
    super.key,
    required this.searchController,
    required this.searchQueryProvider,
    required this.onQueryChanged,
    this.hintText = 'Search...',
  });

  final TextEditingController searchController;
  final ProviderListenable<String> searchQueryProvider;
  final ValueChanged<String> onQueryChanged;
  final String hintText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.textGrey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        onChanged: onQueryChanged,
        style: const TextStyle(color: AppColors.textBlack, fontSize: 15),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 14),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textGrey,
            size: 22,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    color: AppColors.textGrey,
                    size: 20,
                  ),
                  onPressed: () {
                    searchController.clear();
                    onQueryChanged('');
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.lightBackground.withValues(alpha: 0.5),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.dividerColor.withValues(alpha: 0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
