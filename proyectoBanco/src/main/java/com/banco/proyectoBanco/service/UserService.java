package com.banco.proyectoBanco.service;

import com.banco.proyectoBanco.errors.UserAlreadyExist;
import com.banco.proyectoBanco.model.User;
import com.banco.proyectoBanco.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public void insert(User user) throws UserAlreadyExist {
        if (userExist(user.getUsername())) {
            throw new UserAlreadyExist("An account already exists with the user: " + user.getUsername());
        }
        userRepository.save(user);
    }

    private boolean userExist(String username) {
        return userRepository.existsByUsername(username);
    }

    public Optional<User> getUserById(long id) {
        return userRepository.findById(id);
    }

    public Optional<User> getUserByUsername(String username) {
        return userRepository.getByUsername(username);
    }

    public void delete(User user) {
        userRepository.delete(user);
    }

}
