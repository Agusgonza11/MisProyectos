package com.banco.proyectoBanco.repository;

import com.banco.proyectoBanco.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    default boolean existsByUsername(String username) {
        List<User> users = findAll();
        for (User user : users) {
            if (user.getUsername().equals(username)) {
                return true;
            }
        }
        return false;
    }

    default Optional<User> getByUsername(String username) {
        List<User> users = findAll();
        for (User actual : users) {
            if (actual.getUsername().equals(username)) {
                return Optional.of(actual);
            }
        }
        return Optional.empty();
    }
}