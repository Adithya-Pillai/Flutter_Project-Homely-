class Kitchen {
  final String kid;
  final String name;
  final String email;
  final String phoneNumber;
  final double rating;
  final String subtitle;
  final String kitchenImage;
  final String bio;
  final String address;
  final List<Map<String, dynamic>> ongoingOrders;
  final List<Map<String, dynamic>> orderHistory;
  final List<Map<String, dynamic>> notifications;
  final List<Map<String, dynamic>> messages;
  final List<Map<String, dynamic>> items;

  Kitchen({
    required this.kid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.rating,
    required this.subtitle,
    required this.kitchenImage,
    required this.bio,
    required this.address,
    required this.ongoingOrders,
    required this.orderHistory,
    required this.notifications,
    required this.messages,
    required this.items,
  });
}
