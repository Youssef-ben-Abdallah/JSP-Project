package org.example.service;

import org.example.model.DiscountedPrice;
import org.example.model.Promotion;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;

public class PromotionDiscountCalculator {

    public static Optional<DiscountedPrice> calculate(double price, Integer categoryId, Integer subCategoryId,
                                                      List<Promotion> promotions) {
        if (promotions == null || promotions.isEmpty()) {
            return Optional.empty();
        }
        LocalDateTime now = LocalDateTime.now();
        return promotions.stream()
                .filter(promo -> promo != null && promo.isActive(now))
                .filter(promo -> appliesToProduct(promo, categoryId, subCategoryId))
                .map(promo -> buildDiscount(price, promo))
                .filter(DiscountedPrice::hasSavings)
                .max(Comparator.comparingDouble(DiscountedPrice::getSavings));
    }

    private static boolean appliesToProduct(Promotion promotion, Integer categoryId, Integer subCategoryId) {
        if (promotion.getSubCategoryId() != null) {
            return subCategoryId != null && promotion.getSubCategoryId().equals(subCategoryId);
        }
        if (promotion.getCategoryId() != null) {
            return categoryId != null && promotion.getCategoryId().equals(categoryId);
        }
        return true;
    }

    private static DiscountedPrice buildDiscount(double price, Promotion promotion) {
        double discounted;
        if (promotion.isPercentage()) {
            discounted = price - (price * (promotion.getDiscountValue() / 100));
        } else {
            discounted = price - promotion.getDiscountValue();
        }
        double finalPrice = Math.max(discounted, 0);
        double savings = Math.max(price - finalPrice, 0);
        return new DiscountedPrice(price, finalPrice, savings, promotion);
    }

    private PromotionDiscountCalculator() {
    }
}
