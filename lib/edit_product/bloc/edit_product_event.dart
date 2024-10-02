part of 'edit_product_bloc.dart';

sealed class EditProductEvent extends Equatable {
  const EditProductEvent();

  @override
  List<Object> get props => [];
}

final class EditProductSubmitted extends EditProductEvent {
  const EditProductSubmitted({required this.product});

  final Product product;

  @override
  List<Object> get props => [product];
}

final class EditProductAddProduct extends EditProductEvent {
  const EditProductAddProduct({required this.product});

  final Product product;

  @override
  List<Object> get props => [product];
}

final class EditProductProductsDataRequested extends EditProductEvent {
  const EditProductProductsDataRequested();

  @override
  List<Object> get props => [];
}
