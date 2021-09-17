class PreOrderData {
  final double totalPrice;
  final int addressId;
  final String notes, coupon_code, type, scheduled_on, order_type;

  PreOrderData(this.totalPrice, this.addressId, this.notes, this.coupon_code,
      this.type, this.scheduled_on, this.order_type);
}
