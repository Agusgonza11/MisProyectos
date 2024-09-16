package com.banco.proyectoBanco.model;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class UserTest {

    @Test
    void deleteUserWithMatchingPassword() {
        User user = new User();
        user.setPassword("Password");
        Assertions.assertTrue(user.delete("Password"));
    }

    @Test
    void deleteUserWithNoMatchingPassword() {
        User user = new User();
        user.setPassword("Password");
        Assertions.assertFalse(user.delete("AnotherPassword"));
    }
}
