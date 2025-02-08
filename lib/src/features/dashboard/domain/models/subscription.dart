class GetSubscriptionModel {
  String id;
  String name;
  String description;
  double amount;
  String duration;

  GetSubscriptionModel({
    required this.name,
    required this.id,
    required this.description,
    required this.amount,
    required this.duration,
  });

  factory GetSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      GetSubscriptionModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        amount: json["amount"]?.toDouble(),
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "amount": amount,
        "duration": duration,
      };
}
