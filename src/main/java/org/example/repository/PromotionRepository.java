package org.example.repository;

import org.example.model.Promotion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class PromotionRepository {

    public List<Promotion> findAll() {
        String sql = "SELECT id, title, description, discount_type, discount_value, start_time, end_time " +
                "FROM promotions ORDER BY start_time DESC";
        return executeQuery(sql);
    }

    public List<Promotion> findActive() {
        String sql = "SELECT id, title, description, discount_type, discount_value, start_time, end_time " +
                "FROM promotions WHERE start_time <= NOW() AND end_time >= NOW() ORDER BY end_time ASC";
        return executeQuery(sql);
    }

    public void create(Promotion promotion) {
        String sql = "INSERT INTO promotions (title, description, discount_type, discount_value, start_time, end_time) " +
                "VALUES (?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, promotion.getTitle());
            ps.setString(2, promotion.getDescription());
            ps.setString(3, promotion.getDiscountType());
            ps.setDouble(4, promotion.getDiscountValue());
            ps.setTimestamp(5, Timestamp.valueOf(promotion.getStartTime()));
            ps.setTimestamp(6, Timestamp.valueOf(promotion.getEndTime()));
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(Promotion promotion) {
        String sql = "UPDATE promotions SET title = ?, description = ?, discount_type = ?, discount_value = ?, start_time = ?, end_time = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, promotion.getTitle());
            ps.setString(2, promotion.getDescription());
            ps.setString(3, promotion.getDiscountType());
            ps.setDouble(4, promotion.getDiscountValue());
            ps.setTimestamp(5, Timestamp.valueOf(promotion.getStartTime()));
            ps.setTimestamp(6, Timestamp.valueOf(promotion.getEndTime()));
            ps.setInt(7, promotion.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM promotions WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private List<Promotion> executeQuery(String sql) {
        List<Promotion> promotions = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                promotions.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return promotions;
    }

    private Promotion mapRow(ResultSet rs) throws SQLException {
        Promotion promotion = new Promotion();
        promotion.setId(rs.getInt("id"));
        promotion.setTitle(rs.getString("title"));
        promotion.setDescription(rs.getString("description"));
        promotion.setDiscountType(rs.getString("discount_type"));
        promotion.setDiscountValue(rs.getDouble("discount_value"));
        Timestamp start = rs.getTimestamp("start_time");
        Timestamp end = rs.getTimestamp("end_time");
        promotion.setStartTime(start != null ? start.toLocalDateTime() : null);
        promotion.setEndTime(end != null ? end.toLocalDateTime() : null);
        return promotion;
    }
}
