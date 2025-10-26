package org.example.service;

import org.example.model.SubCategory;
import org.example.repository.SubCategoryRepository;

import java.util.Collections;
import java.util.List;
import java.util.Map;

public class SubCategoryService {
    private final SubCategoryRepository subCategoryRepository = new SubCategoryRepository();

    public List<SubCategory> getAll() {
        return subCategoryRepository.findAll();
    }

    public Map<Integer, List<SubCategory>> getAllGroupedByCategory() {
        return subCategoryRepository.findAllGroupedByCategory();
    }

    public List<SubCategory> getByCategory(int categoryId) {
        return subCategoryRepository.findByCategoryId(categoryId);
    }

    public SubCategory getById(int id) {
        return subCategoryRepository.findById(id);
    }

    public void addSubCategory(String name, String description, int categoryId) {
        SubCategory subCategory = new SubCategory();
        subCategory.setName(name);
        subCategory.setDescription(description);
        subCategory.setCategoryId(categoryId);
        subCategoryRepository.create(subCategory);
    }

    public void deleteSubCategory(int id) {
        subCategoryRepository.deleteById(id);
    }

    public List<SubCategory> safeGetByCategory(Integer categoryId) {
        if (categoryId == null) {
            return Collections.emptyList();
        }
        return getByCategory(categoryId);
    }
}
