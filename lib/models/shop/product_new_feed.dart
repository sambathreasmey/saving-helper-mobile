class ProductNewFeed {
  int? code;
  List<Data>? data;
  String? message;
  int? status;

  ProductNewFeed({this.code, this.data, this.message, this.status});

  ProductNewFeed.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class Data {
  int? categoryId;
  String? createdAt;
  String? currencyType;
  String? description;
  String? image;
  String? name;
  String? price;
  int? productId;
  String? status;
  String? updatedAt;
  List<Variant>? variant;

  Data(
      {this.categoryId,
        this.createdAt,
        this.currencyType,
        this.description,
        this.image,
        this.name,
        this.price,
        this.productId,
        this.status,
        this.updatedAt,
        this.variant});

  Data.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    currencyType = json['currency_type'];
    description = json['description'];
    image = json['image'];
    name = json['name'];
    price = json['price'];
    productId = json['product_id'];
    status = json['status'];
    updatedAt = json['updated_at'];
    if (json['variant'] != null) {
      variant = <Variant>[];
      json['variant'].forEach((v) {
        variant!.add(new Variant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['currency_type'] = this.currencyType;
    data['description'] = this.description;
    data['image'] = this.image;
    data['name'] = this.name;
    data['price'] = this.price;
    data['product_id'] = this.productId;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    if (this.variant != null) {
      data['variant'] = this.variant!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Variant {
  String? createdAt;
  String? image;
  String? price;
  int? productId;
  String? sku;
  String? status;
  String? updatedAt;
  int? variantId;
  String? variantName;

  Variant(
      {this.createdAt,
        this.image,
        this.price,
        this.productId,
        this.sku,
        this.status,
        this.updatedAt,
        this.variantId,
        this.variantName});

  Variant.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    image = json['image'];
    price = json['price'];
    productId = json['product_id'];
    sku = json['sku'];
    status = json['status'];
    updatedAt = json['updated_at'];
    variantId = json['variant_id'];
    variantName = json['variant_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['image'] = this.image;
    data['price'] = this.price;
    data['product_id'] = this.productId;
    data['sku'] = this.sku;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['variant_id'] = this.variantId;
    data['variant_name'] = this.variantName;
    return data;
  }
}
