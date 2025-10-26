package org.example.repository;

import org.example.model.SubCategory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SubCategoryRepository {

    public List<SubCategory> findAll() {
        List<SubCategory> list = new ArrayList<>();
        String sql = "SELECT sc.id, sc.name, sc.description, sc.category_id, c.name AS category_name " +
                "FROM subcategories sc JOIN categories c ON sc.category_id = c.id ORDER BY c.name, sc.name";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<Integer, List<SubCategory>> findAllGroupedByCategory() {
        Map<Integer, List<SubCategory>> map = new HashMap<>();
        String sql = "SELECT sc.id, sc.name, sc.description, sc.category_id, c.name AS category_name " +
                "FROM subcategories sc JOIN categories c ON sc.category_id = c.id ORDER BY sc.name";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                SubCategory sc = mapRow(rs);
                map.computeIfAbsent(sc.getCategoryId(), key -> new ArrayList<>()).add(sc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public List<SubCategory> findByCategoryId(int categoryId) {
        List<SubCategory> list = new ArrayList<>();
        String sql = "SELECT sc.id, sc.name, sc.description, sc.category_id, c.name AS category_name " +
                "FROM subcategories sc JOIN categories c ON sc.category_id = c.id WHERE sc.category_id = ? ORDER BY sc.name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public SubCategory findById(int id) {
        String sql = "SELECT sc.id, sc.name, sc.description, sc.category_id, c.name AS category_name " +
                "FROM subcategories sc JOIN categories c ON sc.category_id = c.id WHERE sc.id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void create(SubCategory subCategory) {
        String sql = "INSERT INTO subcategories(name, description, category_id) VALUES (?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, subCategory.getName());
            ps.setString(2, subCategory.getDescription());
            ps.setInt(3, subCategory.getCategoryId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteById(int id) {
        String sql = "DELETE FROM subcategories WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private SubCategory mapRow(ResultSet rs) throws SQLException {
        SubCategory sc = new SubCategory();
        sc.setId(rs.getInt("id"));
        sc.setName(rs.getString("name"));
        sc.setDescription(rs.getString("description"));
        sc.setCategoryId(rs.getInt("category_id"));
        sc.setCategoryName(rs.getString("category_name"));
        return sc;
    }
}
