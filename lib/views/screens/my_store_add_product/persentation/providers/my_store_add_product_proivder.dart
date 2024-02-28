import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/utils/modal.dart';
import 'package:hp3ki/views/screens/my_store_add_product/data/product_category_model.dart';
import 'package:hp3ki/views/screens/my_store_add_product/data/product_condition_model.dart';
import 'package:hp3ki/views/screens/my_store_add_product/domain/my_store_add_product_repository.dart';
import 'package:hp3ki/views/screens/product/data/models/product_detail_model.dart';

import 'package:uuid/uuid.dart';

class MyStoreAddProductProvider with ChangeNotifier {
  final MyStoreAddProductRepository repo;
  final ProductDetailModel? product;

  MyStoreAddProductProvider({
    required this.repo,
    this.product,
  });

  List<ProductCategoryModel> categories = [];
  List<ProductConditionModel> conditions = [];

  String? categoryId;
  String? conditionId;

  List<dynamic> images = [];

  String productName = '';

  String productDescription = '';

  String productPrice = '0';

  String stock = '1';
  String minOrder = '1';
  String weight = '0';

  bool status = true;

  bool loading = false;

  var number = CurrencyTextInputFormatter(
    locale: 'id_ID',
    decimalDigits: 0,
    symbol: '',
  );

  void init() {
    if (product != null) {
      images = product!.pictures.map((e) => e.path).toList();
      productName = product!.name;
      productPrice = number.format(product!.price.toString());
      stock = number.format(product!.stock.toString());
      minOrder = number.format(product!.minOrder.toString());
      weight = number.format(product!.weight.toString());
      productDescription = product!.description;
      conditionId = product!.condition.id;
      status = product!.status == 1 ? true : false;
      categoryId = product!.category.id;
      notifyListeners();
    }
    fetchConditions();
    fetchCategories();
  }

  void fetchCategories() async {
    try {
      categories = await repo.getCategories();
      notifyListeners();
    } catch (e) {
      ///
    }
  }

  void fetchConditions() async {
    try {
      conditions = await repo.getConditions();
      if (product == null) conditionId = conditions.first.id;
      notifyListeners();
    } catch (e) {
      ///
    }
  }

  void setImages(List<dynamic> files) {
    images = [...images, ...files];
    notifyListeners();
  }

  void removeImageIndex(int index) {
    images.removeAt(index);
    notifyListeners();
  }

  void setState({
    String? productNameState,
    String? productPriceState,
    String? stockState,
    String? minOrderState,
    String? weightState,
    String? productDescriptionState,
  }) {
    productName = productNameState ?? productName;
    productPrice = productPriceState ?? productPrice;
    stock = stockState ?? stock;
    minOrder = minOrderState ?? minOrder;
    weight = weightState ?? weight;
    productDescription = productDescriptionState ?? productDescription;
    notifyListeners();
  }

  void changeCondtion(ProductConditionModel state) {
    conditionId = state.id;
    notifyListeners();
  }

  void changeCategory(ProductCategoryModel state) {
    categoryId = state.id;
    notifyListeners();
  }

  Future<void> addProduct(BuildContext context) async {
    try {
      loading = true;
      notifyListeners();
      await uploadImageFile();
      const uuid = Uuid();
      final id = uuid.v4();

      repo.addProductImageBulk(id, imagesFromUrl);

      await repo.addProduct(
          name: productName,
          description: productDescription,
          categoryId: categoryId ?? "",
          conditionId: conditionId ?? "",
          price: productPrice.parseToNumber,
          weight: weight.parseToNumber,
          stock: stock.parseToNumber,
          id: id,
          open: status,
          minOrder: minOrder.parseToNumber);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              '${getTranslated("TXT_ADD", context)} ${getTranslated("TXT_PRODUCT", context)} ${getTranslated("TXT_SUCCESS", context)}')));
    } catch (e) {
      await GeneralModal.error(context, msg: e.toString(), onOk: () {
        Navigator.pop(context);
      });
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> uploadImageFile() async {
    try {
      for (var file in imagesFromFile) {
        images.remove(file);
        images.add(await repo.uploadMedia(file));
      }
    } catch (e) {
      rethrow;
    }
  }

  List<File> get imagesFromFile => images.whereType<File>().toList();
  List<String> get imagesFromUrl => images.whereType<String>().toList();

  Future<void> editProduct(BuildContext context) async {
    try {
      loading = true;
      notifyListeners();
      await uploadImageFile();
      await repo.deleteProductImageAll(product!.id);
      repo.addProductImageBulk(product!.id, imagesFromUrl);
      await repo.addProduct(
          name: productName,
          description: productDescription,
          categoryId: categoryId ?? "",
          conditionId: conditionId ?? "",
          price: productPrice.parseToNumber,
          weight: weight.parseToNumber,
          stock: stock.parseToNumber,
          id: product!.id,
          open: status,
          minOrder: minOrder.parseToNumber);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${getTranslated("TXT_EDIT", context)} ${getTranslated(
        "TXT_PRODUCT",
        context,
      )} ${getTranslated("TXT_SUCCESS", context)}')));
    } catch (e) {
      await GeneralModal.error(context, msg: e.toString(), onOk: () {
        Navigator.pop(context);
      });
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void changeStatus(bool value) {
    status = value;
    notifyListeners();
  }
}

extension on String {
  int get parseToNumber =>
      int.parse(replaceAll(' ', '').replaceAll('.', '').replaceAll('Rp', ''));
}
