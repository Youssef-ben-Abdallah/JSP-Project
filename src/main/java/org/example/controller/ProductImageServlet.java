package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.service.ImageStorageService;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet(name = "ProductImageServlet", urlPatterns = "/product-images/*")
public class ProductImageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.isBlank() || "/".equals(pathInfo) || pathInfo.contains("..")) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String filename = Paths.get(pathInfo).getFileName().toString();
        Path filePath = ImageStorageService.resolveProductUploadDir().resolve(filename);
        if (!Files.exists(filePath) || Files.isDirectory(filePath)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = Files.probeContentType(filePath);
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        resp.setContentType(contentType);
        resp.setHeader("Content-Disposition", "inline; filename=\"" + filename + "\"");

        try (InputStream inputStream = Files.newInputStream(filePath);
             OutputStream outputStream = resp.getOutputStream()) {
            inputStream.transferTo(outputStream);
        }
    }
}
