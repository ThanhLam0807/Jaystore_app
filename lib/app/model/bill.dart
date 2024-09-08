class BillModel {
    String id;
    String fullName;
    String dateCreated;
    int total; // Đổi kiểu dữ liệu của total từ dynamic sang int

    BillModel({
        required this.id,
        required this.fullName,
        required this.dateCreated,
        required this.total,
    });

    factory BillModel.fromJson(Map<String, dynamic> json) => BillModel(
        id: json["id"],
        fullName: json["fullName"],
        dateCreated: json["dateCreated"],
        total: json["total"], // Sửa đổi kiểu dữ liệu của total
    );
}

class BillDetailModel {
    int productId;
    String productName;
    String imageUrl;
    int price;
    int count; // Thay đổi từ quantity sang count
    int total;
    String proDescription;

    BillDetailModel({
        required this.productId,
        required this.productName,
        required this.imageUrl,
        required this.price,
        required this.count, // Thay đổi từ quantity sang count
        required this.total,
        required this.proDescription,
    });

    factory BillDetailModel.fromJson(Map<String, dynamic> json) => BillDetailModel(
        productId: json["productID"] ?? 0,
        productName: json["productName"] ?? "",
        imageUrl: json["imageURL"] ?? "",
        price: json["price"] ?? 0,
        count: json["count"] ?? 0, // Thay đổi từ quantity sang count
        total: json["total"] ?? 0,
        proDescription: json["proDescription"] ?? "",
    );
}