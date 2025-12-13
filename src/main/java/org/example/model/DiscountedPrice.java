package org.example.model;

public class DiscountedPrice {
    private final double originalPrice;
    private final double finalPrice;
    private final double savings;
    private final Promotion promotion;

    public DiscountedPrice(double originalPrice, double finalPrice, double savings, Promotion promotion) {
        this.originalPrice = originalPrice;
        this.finalPrice = finalPrice;
        this.savings = savings;
        this.promotion = promotion;
    }

    public double getOriginalPrice() {
        return originalPrice;
    }

    public double getFinalPrice() {
        return finalPrice;
    }

    public double getSavings() {
        return savings;
    }

    public Promotion getPromotion() {
        return promotion;
    }

    public boolean hasSavings() {
        return savings > 0;
    }
}
