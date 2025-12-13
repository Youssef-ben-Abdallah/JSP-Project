package org.example.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public final class ImageStorageService {
    private static final String DEFAULT_FOLDER = "jsp-product-uploads";
    private static final String PRODUCT_FOLDER = "products";

    private ImageStorageService() {
    }

    public static Path resolveProductUploadDir() throws IOException {
        String customDir = System.getProperty("product.upload.dir");
        Path basePath;
        if (customDir != null && !customDir.isBlank()) {
            basePath = Paths.get(customDir);
        } else {
            basePath = Paths.get(System.getProperty("user.home"), DEFAULT_FOLDER);
        }
        Path uploadPath = basePath.resolve(PRODUCT_FOLDER);
        Files.createDirectories(uploadPath);
        return uploadPath;
    }
}
