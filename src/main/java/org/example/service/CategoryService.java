package org.example.service;

import org.example.model.Category;
import org.example.repository.CategoryRepository;

import java.util.List;

public class CategoryService {
    private final CategoryRepository categoryRepository = new CategoryRepository();

    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }

    public void addCategory(String name, String description) {
        Category c = new Category();
        c.setName(name);
        c.setDescription(description);
        categoryRepository.create(c);
    }

    public void deleteCategory(int id) {
        categoryRepository.deleteById(id);
    }
}
