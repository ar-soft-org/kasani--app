import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasanipedido/bloc/home/home_cubit.dart';

import 'category_card.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentCategory = state.currentCategory;

        return Align(
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: state.categories.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final item = state.categories[index];

              return CategoryCard(
                categoryId: item.idCategoria,
                label: item.nombreCategoria,
                isSelected: currentCategory?.idCategoria == item.idCategoria &&
                    state.currentSubCategory == null,
                onTap: (String categoryId) {
                  BlocProvider.of<HomeCubit>(context)
                      .setCurrentSelection(id: categoryId, isCategory: true);
                },
              );
            },
          ),
        );
      },
    );
  }
}
