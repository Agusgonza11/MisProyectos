package com.banco.proyectoBanco.controller;

import com.banco.proyectoBanco.controller.dto.UserDto;
import com.banco.proyectoBanco.errors.UserDontExist;
import com.banco.proyectoBanco.model.User;
import com.banco.proyectoBanco.controller.dto.UserDtoValidator;
import com.banco.proyectoBanco.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Optional;

@RestController
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/signup")
    public ResponseEntity<String> createUser(@RequestBody UserDto userDto) {
        try {
            UserDtoValidator.validate(userDto);
            userService.insert(new User(userDto));
        } catch (Exception exception) {
            return new ResponseEntity<>(exception.getMessage(), HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity<>("The user was created successfully", HttpStatus.CREATED);
    }

    @GetMapping("/users")
    public List<User> getUsers() {
        return userService.getAllUsers();
    }

    @DeleteMapping("/unsubscribe")
    public ResponseEntity<String> deleteUser(@RequestParam String username, @RequestParam String password) {
        try {
            Optional<User> userToDelete = userService.getUserByUsername(username);
            if (userToDelete.isEmpty()) {
                throw new UserDontExist("User don't exist");
            }
            if (userToDelete.get().delete(password)) {
                userService.delete(userToDelete.get());
            }
        } catch (Exception exception) {
            return new ResponseEntity<>(exception.getMessage(), HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity<>("The user was successfully removed", HttpStatus.CREATED);
    }

}
