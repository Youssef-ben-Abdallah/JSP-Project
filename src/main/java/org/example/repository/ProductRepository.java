package org.example.repository;

import org.example.model.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class ProductRepository {

    public List<Product> findAll() {
        return findFiltered(null, null);
    }

    public List<Product> findByCategory(int categoryId) {
        return findFiltered(categoryId, null);
    }

    public List<Product> findBySubCategory(int subCategoryId) {
        return findFiltered(null, subCategoryId);
    }

    public Product findById(int id) {
        String sql = baseSelect() + " WHERE p.id=?";
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

    public void create(Product p) {
        String sql = "INSERT INTO products(name, description, price, image_url, category_id, subcategory_id) VALUES (?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setString(2, p.getDescription());
            ps.setDouble(3, p.getPrice());
            ps.setString(4, p.getImageUrl());
            ps.setInt(5, p.getCategoryId());
            if (p.getSubCategoryId() != null) {
                ps.setInt(6, p.getSubCategoryId());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(Product product) {
        String sql = "UPDATE products SET name = ?, description = ?, price = ?, image_url = ?, category_id = ?, subcategory_id = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setDouble(3, product.getPrice());
            ps.setString(4, product.getImageUrl());
            ps.setInt(5, product.getCategoryId());
            if (product.getSubCategoryId() != null) {
                ps.setInt(6, product.getSubCategoryId());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            ps.setInt(7, product.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteById(int id) {
        String sql = "DELETE FROM products WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private List<Product> findFiltered(Integer categoryId, Integer subCategoryId) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(baseSelect());
        if (subCategoryId != null) {
            sql.append(" WHERE p.subcategory_id = ?");
        } else if (categoryId != null) {
            sql.append(" WHERE p.category_id = ?");
        }
        sql.append(" ORDER BY p.name");
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            if (subCategoryId != null) {
                ps.setInt(1, subCategoryId);
            } else if (categoryId != null) {
                ps.setInt(1, categoryId);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private String baseSelect() {
        return "SELECT p.id, p.name, p.description, p.price, p.image_url, p.category_id, p.subcategory_id, " +
                "c.name AS category_name, sc.name AS subcategory_name " +
                "FROM products p JOIN categories c ON p.category_id = c.id " +
                "LEFT JOIN subcategories sc ON p.subcategory_id = sc.id";
    }

    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getDouble("price"));
        p.setImageUrl(rs.getString("image_url"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setCategoryName(rs.getString("category_name"));
        int subCategoryId = rs.getInt("subcategory_id");
        boolean hasSubCategory = !rs.wasNull();
        if (hasSubCategory) {
            p.setSubCategoryId(subCategoryId);
        } else {
            p.setSubCategoryId(null);
        }
        p.setSubCategoryName(hasSubCategory ? rs.getString("subcategory_name") : null);
        return p;
    }
}
