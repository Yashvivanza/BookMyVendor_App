class ServiceModel{
  String serviceMasterId;
  String serviceName;
  String servicePrice;
  String serviceImage;
  String serviceDetails;
  String subCategoryId;
  String subCategoryName;

  ServiceModel({
    required this.serviceMasterId,
    required this.serviceName,
    required this.servicePrice,
    required this.serviceImage,
    required this.serviceDetails,
    required this.subCategoryId,
    required this.subCategoryName,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceMasterId: json["service_master_id"].toString(),
      serviceName: json["service_name"].toString(),
      servicePrice: json["service_price"].toString(),
      serviceImage: json["service_image"].toString(),
      serviceDetails: json["service_details"].toString(),
      subCategoryId:
          json["category"]["sub_category_id"].toString(),
      subCategoryName:
          json["category"]["sub_category_name"].toString(),
    );
  }
}