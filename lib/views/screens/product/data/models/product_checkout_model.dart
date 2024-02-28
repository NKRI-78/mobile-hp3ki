// To parse this JSON data, do
//
//     final productCheckoutModel = productCheckoutModelFromJson(jsonString);

import 'dart:convert';

ProductCheckoutModel productCheckoutModelFromJson(String str) =>
    ProductCheckoutModel.fromJson(json.decode(str));

String productCheckoutModelToJson(ProductCheckoutModel data) =>
    json.encode(data.toJson());

class ProductCheckoutModel {
  int totalItem;
  int totalPrice;
  List<StoreElement> stores;

  ProductCheckoutModel({
    required this.totalItem,
    required this.totalPrice,
    required this.stores,
  });

  factory ProductCheckoutModel.fromJson(Map<String, dynamic> json) =>
      ProductCheckoutModel(
        totalItem: json["total_item"],
        totalPrice: json["total_price"],
        stores: List<StoreElement>.from(
            json["stores"].map((x) => StoreElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_item": totalItem,
        "total_price": totalPrice,
        "stores": List<dynamic>.from(stores.map((x) => x.toJson())),
      };
}

class StoreElement {
  bool selected;
  StoreStore store;
  List<Item> items;

  StoreElement({
    required this.selected,
    required this.store,
    required this.items,
  });

  factory StoreElement.fromJson(Map<String, dynamic> json) => StoreElement(
        selected: json["selected"],
        store: StoreStore.fromJson(json["store"]),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "selected": selected,
        "store": store.toJson(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  Cart cart;
  String id;
  String name;
  String picture;
  int price;
  int weight;
  int stock;
  int minOrder;

  Item({
    required this.cart,
    required this.id,
    required this.name,
    required this.picture,
    required this.price,
    required this.weight,
    required this.stock,
    required this.minOrder,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        cart: Cart.fromJson(json["cart"]),
        id: json["id"],
        name: json["name"],
        picture: json["picture"],
        price: json["price"],
        weight: json["weight"],
        stock: json["stock"],
        minOrder: json["min_order"],
      );

  Map<String, dynamic> toJson() => {
        "cart": cart.toJson(),
        "id": id,
        "name": name,
        "picture": picture,
        "price": price,
        "weight": weight,
        "stock": stock,
        "min_order": minOrder,
      };
}

class Cart {
  String id;
  bool selected;
  int quantity;
  String note;
  bool isOutStock;

  Cart({
    required this.id,
    required this.selected,
    required this.quantity,
    required this.note,
    required this.isOutStock,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"],
        selected: json["selected"],
        quantity: json["quantity"],
        note: json["note"],
        isOutStock: json["is_out_stock"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "selected": selected,
        "quantity": quantity,
        "note": note,
        "is_out_stock": isOutStock,
      };
}

class StoreStore {
  String id;
  String name;
  String picture;
  String description;
  String address;

  StoreStore({
    required this.id,
    required this.name,
    required this.picture,
    required this.description,
    required this.address,
  });

  factory StoreStore.fromJson(Map<String, dynamic> json) => StoreStore(
        id: json["id"],
        name: json["name"],
        picture: json["picture"],
        description: json["description"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "picture": picture,
        "description": description,
        "address": address,
      };
}
