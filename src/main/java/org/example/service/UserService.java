package org.example.service;

import org.example.model.User;
import org.example.repository.UserRepository;

public class UserService {
    private final UserRepository userRepository = new UserRepository();

    public User login(String username, String password) {
        return userRepository.findByUsernameAndPassword(username, password);
    }

    public boolean isAdmin(User u) {
        return u != null && "ADMIN".equalsIgnoreCase(u.getRole());
    }

    public User register(String username, String password) {
        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            throw new IllegalArgumentException("Username and password are required");
        }
        User existing = userRepository.findByUsername(username);
        if (existing != null) {
            throw new IllegalArgumentException("Username already exists");
        }
        try {
            int id = userRepository.createUser(username, password, "USER");
            User u = new User();
            u.setId(id);
            u.setUsername(username);
            u.setPassword(password);
            u.setRole("USER");
            return u;
        } catch (Exception e) {
            throw new RuntimeException("Unable to create user", e);
        }
    }
}
