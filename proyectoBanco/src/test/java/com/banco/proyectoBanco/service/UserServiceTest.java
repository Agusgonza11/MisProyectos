package com.banco.proyectoBanco.service;

import com.banco.proyectoBanco.errors.NonExistentAccountType;
import com.banco.proyectoBanco.errors.UserAlreadyExist;
import com.banco.proyectoBanco.model.User;
import com.banco.proyectoBanco.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import java.util.List;
import java.util.Optional;
import static org.junit.jupiter.api.Assertions.*;

class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    private User user;

    @BeforeEach
    void setUp() throws NonExistentAccountType {
        MockitoAnnotations.openMocks(this);
        user = new User("Agustin", "Gonzalez", "Agus2000", "standard", "abc");
    }

    @Test
    void getAllUsers() {
        Mockito.when(userRepository.findAll()).thenReturn(List.of(user));
        assertNotNull(userService.getAllUsers());
    }

    @Test
    void getUserById() {
        Mockito.when(userRepository.findById(user.getId())).thenReturn(Optional.of(user));
        assertEquals(Optional.of(user), userService.getUserById(user.getId()));
    }

    @Test
    void getUserByUsername() {
        Mockito.when(userRepository.getByUsername(user.getUsername())).thenReturn(Optional.of(user));
        assertEquals(Optional.of(user), userService.getUserByUsername(user.getUsername()));
    }

    @Test
    void delete() throws UserAlreadyExist {
        userService.delete(user);
        Mockito.verify(userRepository).delete(user);
    }
}