package org.example.model;

import java.time.LocalDateTime;

public class Promotion {
    private int id;
    private String title;
    private String description;
    private String discountType;
    private double discountValue;
    private LocalDateTime startTime;
    private LocalDateTime endTime;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public double getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(double discountValue) {
        this.discountValue = discountValue;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    public LocalDateTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalDateTime endTime) {
        this.endTime = endTime;
    }

    public boolean isPercentage() {
        return "PERCENTAGE".equalsIgnoreCase(discountType);
    }

    public boolean isFixedAmount() {
        return "FIXED_AMOUNT".equalsIgnoreCase(discountType);
    }

    public boolean isActive(LocalDateTime now) {
        if (startTime == null || endTime == null || now == null) {
            return false;
        }
        return (now.isEqual(startTime) || now.isAfter(startTime))
                && (now.isBefore(endTime) || now.isEqual(endTime));
    }
}
