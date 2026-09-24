/// 结款记录
class Payment {
  final String name;

  /// 金额（万元）
  final double amount;

  /// 已收 / 待收
  final String status;

  /// 到账日期（未收时为空串）
  final String date;

  const Payment({
    required this.name,
    required this.amount,
    required this.status,
    this.date = '',
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    name: json['name'] as String,
    amount: (json['amount'] as num).toDouble(),
    status: json['status'] as String,
    date: json['date'] as String? ?? '',
  );
}

/// 商务信息：报价 → 合同 → 交付 → 结款
class BusinessInfo {
  /// 成本法报价（万元）
  final double costBased;

  /// 市场法报价（万元）
  final double marketBased;

  /// 定价依据说明
  final String pricingNote;

  /// 合同签订日期
  final String contractDate;

  /// 结款记录
  final List<Payment> payments;

  const BusinessInfo({
    required this.costBased,
    required this.marketBased,
    required this.pricingNote,
    required this.contractDate,
    required this.payments,
  });

  factory BusinessInfo.fromJson(Map<String, dynamic> json) => BusinessInfo(
    costBased: (json['costBased'] as num).toDouble(),
    marketBased: (json['marketBased'] as num).toDouble(),
    pricingNote: json['pricingNote'] as String? ?? '',
    contractDate: json['contractDate'] as String? ?? '',
    payments: (json['payments'] as List<dynamic>? ?? [])
        .map((e) => Payment.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
