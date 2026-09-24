import 'package:flutter/material.dart';

import '../../project/models/project.dart';
import '../views/business_flow_card.dart';
import '../views/contract_card.dart';
import '../views/delivery_card.dart';
import '../views/payment_card.dart';
import '../views/quotation_card.dart';

/// 商务：报价 → 合同 → 交付 → 结款
class BusinessTab extends StatelessWidget {
  final Project project;

  const BusinessTab({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final business = project.business;
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        QuotationCard(business: business),
        const SizedBox(height: 16),
        ContractCard(project: project, business: business),
        const SizedBox(height: 16),
        DeliveryCard(project: project),
        const SizedBox(height: 16),
        PaymentCard(business: business),
        const SizedBox(height: 16),
        BusinessFlowCard(matrix: project.matrix),
      ],
    );
  }
}
