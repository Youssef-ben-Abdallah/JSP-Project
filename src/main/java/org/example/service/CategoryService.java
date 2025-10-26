package org.example.service;

import org.example.model.Category;
import org.example.model.SubCategory;
import org.example.repository.CategoryRepository;

import java.util.Collections;
import java.util.List;
import java.util.Map;

public class CategoryService {
    private final CategoryRepository categoryRepository = new CategoryRepository();
    private final SubCategoryService subCategoryService = new SubCategoryService();

    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }

    public Category getById(int id) {
        return categoryRepository.findById(id);
    }

    public List<Category> getCategoriesWithSubCategories() {
        List<Category> categories = categoryRepository.findAll();
        Map<Integer, List<SubCategory>> grouped = subCategoryService.getAllGroupedByCategory();
        for (Category category : categories) {
            List<SubCategory> subCategories = grouped.getOrDefault(category.getId(), Collections.emptyList());
            category.setSubCategories(subCategories);
        }
        return categories;
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
