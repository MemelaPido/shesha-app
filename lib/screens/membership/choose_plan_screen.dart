import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../models/membership_plan.dart';
import '../../providers/membership_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/primary_button.dart';

class ChoosePlanScreen extends StatelessWidget {
  const ChoosePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final membership = context.watch<MembershipProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('3/3 · Choose your plan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text('Plans that move with you', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
            const SizedBox(height: 18),
            for (final plan in MembershipProvider.plans) ...[
              _PlanCard(
                plan: plan,
                selected: plan.id == membership.selectedPlan.id,
                onSelect: () => context.read<MembershipProvider>().selectPlan(plan),
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 8),
            PrimaryButton(
              label: 'Continue with ${membership.selectedPlan.name}',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.dashboard, (_) => false),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, required this.selected, required this.onSelect});
  final MembershipPlan plan;
  final bool selected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: selected ? AppColors.primary : AppColors.line, width: selected ? 2 : 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(plan.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    Text('R${plan.monthlyPrice}/mo', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(plan.description, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                const SizedBox(height: 12),
                OutlinedButton(
                  style: selected
                      ? OutlinedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white)
                      : null,
                  onPressed: onSelect,
                  child: Text(selected ? 'Selected ✓' : 'Select'),
                ),
              ],
            ),
          ),
        ),
        if (plan.popular)
          const Positioned(
            right: 12,
            top: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.vertical(bottom: Radius.circular(6))),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Text('MOST POPULAR', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
      ],
    );
  }
}
