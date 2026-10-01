class MembershipPlan {
  final int id;
  final String name;
  final int monthlyPrice;
  final String description;
  final bool popular;

  const MembershipPlan({
    required this.id,
    required this.name,
    required this.monthlyPrice,
    required this.description,
    this.popular = false,
  });
}
