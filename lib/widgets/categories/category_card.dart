import 'package:flutter/material.dart';
import 'package:kasanipedido/screens/widgets/category_card.dart';
import 'package:kasanipedido/utils/app_constant.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/utils/images.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.label,
    required this.categoryId,
    this.isSelected = false,
    required this.onTap,
  });

  final String categoryId;
  final String label;
  final bool isSelected;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return circleCard(
      context,
      categoryId == '1'
          ? AppImages.frecosIcon
          : categoryId == '2'
              ? AppImages.congeladosIcon
              : AppImages.jellyfish,
      label,
      Colors.cyan,
      0,
      index == 1 ? Colors.cyan : AppColors.greyText,
      () => onTap(categoryId),
      isSelected ? AppColors.selectCat : AppColors.purple,
      isSelected ? FontWeight.w700 : FontWeight.w400,
    );
  }
}
