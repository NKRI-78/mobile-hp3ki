class DetailOrderModel {
  int status;
  bool error;
  String message;
  DetailOrderData data;

  DetailOrderModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory DetailOrderModel.fromJson(Map<String, dynamic> json) => DetailOrderModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: DetailOrderData.fromJson(json["data"]),
  );
}

class DetailOrderData {
  String? transactionId;
  String? orderStatus;
  String? paymentStatus;
  dynamic waybill;
  dynamic expire;
  int? totalCost;
  int? totalPrice;
  String? invoice;
  DateTime? createdAt;
  bool? isReviewed;
  String? paymentAccess;
  String? paymentCode;
  List<DetailOrderItem>? items;

  DetailOrderData({
    this.transactionId,
    this.orderStatus,
    this.paymentStatus,
    this.waybill,
    this.expire,
    this.totalCost,
    this.totalPrice,
    this.invoice,
    this.createdAt,
    this.isReviewed,
    this.paymentAccess,
    this.paymentCode,
    this.items,
  });

  factory DetailOrderData.fromJson(Map<String, dynamic> json) => DetailOrderData(
    transactionId: json["transaction_id"],
    orderStatus: json["order_status"],
    paymentStatus: json["payment_status"],
    waybill: json["waybill"],
    expire: DateTime.parse(json["expire"]),
    totalCost: json["total_cost"],
    totalPrice: json["total_price"],
    invoice: json["invoice"],
    createdAt: DateTime.parse(json["created_at"]),
    isReviewed: json["is_reviewed"],
    paymentAccess: json["payment_access"],
    paymentCode: json["payment_code"],
    items: List<DetailOrderItem>.from(json["items"].map((x) => DetailOrderItem.fromJson(x))),
  );
}

class DetailOrderItem {
  Store store;
  List<ProductElement> products;
  String waybill;
  String courierId;
  int courierPrice;
  String courierService;
  int courierWeight;
  DetailOrderSeller seller;
  DetailOrderBuyer buyer;

  DetailOrderItem({
    required this.store,
    required this.waybill,
    required this.products,
    required this.courierId,
    required this.courierPrice,
    required this.courierService,
    required this.courierWeight,
    required this.seller,
    required this.buyer,
  });

  factory DetailOrderItem.fromJson(Map<String, dynamic> json) => DetailOrderItem(
    store: Store.fromJson(json["store"]),
    products: List<ProductElement>.from(json["products"].map((x) => ProductElement.fromJson(x))),
    waybill: json["waybill"],
    courierId: json["courier_id"],
    courierPrice: json["courier_price"],
    courierService: json["courier_service"],
    courierWeight: json["courier_weight"],
    seller: DetailOrderSeller.fromJson(json["seller"]),
    buyer: DetailOrderBuyer.fromJson(json["buyer"]),
  );
}

class DetailOrderBuyer {
  String id;
  String email;
  String phone;
  String fullname;
  String avatar;
  String address;

  DetailOrderBuyer({
    required this.id,
    required this.email,
    required this.phone,
    required this.fullname,
    required this.avatar,
    required this.address,
  });

  factory DetailOrderBuyer.fromJson(Map<String, dynamic> json) => DetailOrderBuyer(
    id: json["id"],
    email: json["email"],
    phone: json["phone"],
    fullname: json["fullname"],
    avatar: json["avatar"],
    address: json["address"],
  );
}

class DetailOrderSeller {
  String id;
  String email;
  String phone;
  String fullname;
  String avatar;
  String address;

  DetailOrderSeller({
    required this.id,
    required this.email,
    required this.phone,
    required this.fullname,
    required this.avatar,
    required this.address,
  });

  factory DetailOrderSeller.fromJson(Map<String, dynamic> json) => DetailOrderSeller(
    id: json["id"],
    email: json["email"],
    phone: json["phone"],
    fullname: json["fullname"],
    avatar: json["avatar"],
    address: json["address"],
  );
}

class ProductElement {
  ProductProduct product;
  int qty;

  ProductElement({
    required this.product,
    required this.qty,
  });

  factory ProductElement.fromJson(Map<String, dynamic> json) => ProductElement(
    product: ProductProduct.fromJson(json["product"]),
    qty: json["qty"],
  );
}

class ProductProduct {
  String id;
  String title;
  List<Media> medias;
  int price;
  int stock;
  String caption;
  String note;

  ProductProduct({
    required this.id,
    required this.title,
    required this.medias,
    required this.price,
    required this.stock,
    required this.caption,
    required this.note,
  });

  factory ProductProduct.fromJson(Map<String, dynamic> json) => ProductProduct(
    id: json["id"],
    title: json["title"],
    medias: List<Media>.from(json["medias"].map((x) => Media.fromJson(x))),
    price: json["price"],
    stock: json["stock"],
    caption: json["caption"],
    note: json["note"],
  );
}

class Media {
  int id;
  String path;

  Media({
    required this.id, 
    required this.path,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: json["id"],
    path: json["path"],
  );
}

class Store {
  String id;
  String logo;
  String name;
  String address;
  String province;
  String city;
  String district;
  String subdistrict;
  String phone;
  String email;
  bool isOpen;
  DateTime createdAt;

  Store({
    required this.id,
    required this.logo,
    required this.name,
    required this.address,
    required this.province,
    required this.city,
    required this.district,
    required this.subdistrict,
    required this.phone,
    required this.email,
    required this.isOpen,
    required this.createdAt,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    id: json["id"],
    logo: json["logo"],
    name: json["name"],
    address: json["address"],
    province: json["province"],
    city: json["city"],
    district: json["district"],
    subdistrict: json["subdistrict"],
    phone: json["phone"],
    email: json["email"],
    isOpen: json["is_open"],
    createdAt: DateTime.parse(json["created_at"]),
  );
}
