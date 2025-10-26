package org.example.service;

import org.example.model.Promotion;
import org.example.repository.PromotionRepository;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class PromotionService {
    private static final DateTimeFormatter FORM = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    private final PromotionRepository repository = new PromotionRepository();

    public List<Promotion> getAll() {
        return repository.findAll();
    }

    public List<Promotion> getActive() {
        return repository.findActive();
    }

    public void create(String title, String description, String discountType, String discountValue,
                       String startTime, String endTime) {
        Promotion promotion = new Promotion();
        promotion.setTitle(title != null ? title.trim() : null);
        promotion.setDescription(description != null ? description.trim() : null);
        promotion.setDiscountType(normalizeType(discountType));
        promotion.setDiscountValue(parseDouble(discountValue));
        promotion.setStartTime(parseDate(startTime));
        promotion.setEndTime(parseDate(endTime));
        validateChronology(promotion.getStartTime(), promotion.getEndTime());
        validateBusinessRules(promotion);
        repository.create(promotion);
    }

    public void delete(int id) {
        repository.delete(id);
    }

    private String normalizeType(String type) {
        if (type == null) {
            return "PERCENTAGE";
        }
        String upper = type.trim().toUpperCase();
        if (!"PERCENTAGE".equals(upper) && !"FIXED_AMOUNT".equals(upper)) {
            return "PERCENTAGE";
        }
        return upper;
    }

    private double parseDouble(String value) {
        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private LocalDateTime parseDate(String value) {
        if (value == null || value.isEmpty()) {
            return null;
        }
        try {
            return LocalDateTime.parse(value, FORM);
        } catch (Exception e) {
            throw new IllegalArgumentException("Format de date invalide");
        }
    }

    private void validateChronology(LocalDateTime start, LocalDateTime end) {
        if (start == null || end == null || end.isBefore(start)) {
            throw new IllegalArgumentException("La période de la promotion est invalide");
        }
    }

    private void validateBusinessRules(Promotion promotion) {
        if (promotion.getTitle() == null || promotion.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Le titre est obligatoire");
        }
        if (promotion.getDescription() == null || promotion.getDescription().trim().isEmpty()) {
            throw new IllegalArgumentException("La description est obligatoire");
        }
        if (promotion.getDiscountValue() <= 0) {
            throw new IllegalArgumentException("La valeur de la remise doit être positive");
        }
    }
}
