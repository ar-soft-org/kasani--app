part of 'edit_product_bloc.dart';

enum EditProductStatus { initial, loading, success, failure }

extension EditProductStatusX on EditProductStatus {
  bool get isLoadingOrSuccess => [
        EditProductStatus.loading,
        EditProductStatus.success,
      ].contains(this);
}

final class EditProductState extends Equatable {
  const EditProductState({
    this.status = EditProductStatus.initial,
    this.productsData = const {},
  });

  final EditProductStatus status;
  final Map<String, ProductData> productsData;

  EditProductState copyWith({
    EditProductStatus Function()? status,
    Map<String, ProductData> Function()? productsData,
  }) {
    return EditProductState(
      status: status != null ? status() : this.status,
      productsData: productsData != null ? productsData() : this.productsData,
    );
  }

  @override
  List<Object?> get props => [
        status,
        productsData,
      ];
}
