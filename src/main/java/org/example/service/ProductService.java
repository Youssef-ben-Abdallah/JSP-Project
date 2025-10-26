package org.example.service;

import org.example.model.Product;
import org.example.repository.ProductRepository;

import java.util.List;

public class ProductService {
    private final ProductRepository productRepository = new ProductRepository();

    public List<Product> getAll() {
        return productRepository.findAll();
    }

    public Product getById(int id) {
        return productRepository.findById(id);
    }

    public void addProduct(String name, String desc, double price, String imageUrl, int categoryId) {
        Product p = new Product();
        p.setName(name);
        p.setDescription(desc);
        p.setPrice(price);
        p.setImageUrl(imageUrl);
        p.setCategoryId(categoryId);
        productRepository.create(p);
    }

    public void deleteProduct(int id) {
        productRepository.deleteById(id);
    }
}
