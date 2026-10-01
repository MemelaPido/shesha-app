import 'package:flutter/foundation.dart';
import '../models/membership_plan.dart';

class MembershipProvider extends ChangeNotifier {
  static const plans = <MembershipPlan>[
    MembershipPlan(id: 1, name: 'Basic', monthlyPrice: 89, description: 'Fuel assistance · 4 call-outs'),
    MembershipPlan(id: 2, name: 'Standard', monthlyPrice: 159, description: 'Fuel + tyre & wheel cover', popular: true),
    MembershipPlan(id: 3, name: 'Premium', monthlyPrice: 249, description: 'Fuel + tyres + windscreen'),
    MembershipPlan(id: 4, name: 'Family', monthlyPrice: 399, description: 'Premium cover for 3 vehicles'),
  ];

  MembershipPlan _selectedPlan = plans[1];
  MembershipPlan get selectedPlan => _selectedPlan;

  void selectPlan(MembershipPlan plan) {
    _selectedPlan = plan;
    notifyListeners();
  }
}
