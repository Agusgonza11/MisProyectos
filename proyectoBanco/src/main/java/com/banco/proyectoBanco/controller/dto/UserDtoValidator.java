package com.banco.proyectoBanco.controller.dto;

import com.banco.proyectoBanco.errors.*;


//I tried to use the binding result instead but for some reason the validation didn't work
public class UserDtoValidator {
    public static void validate(UserDto userDto) throws PasswordNonInput, PasswordsDontMatch, UsernameNonInput, FirstNameNonInput, LastNameNonInput {
        if (userDto.getPassword().isEmpty()) {
            throw new PasswordNonInput("You must enter a password");
        }
        if (!userDto.getPassword().equals(userDto.getMatchingPassword())) {
            throw new PasswordsDontMatch("Passwords don't match");
        }
        if (userDto.getUsername().isEmpty()) {
            throw new UsernameNonInput("You have to select a username");
        }
        if (userDto.getFirstName().isEmpty()) {
            throw new FirstNameNonInput("You must enter a first name");
        }
        if (userDto.getLastName().isEmpty()) {
            throw new LastNameNonInput("You must enter a last name");
        }
    }
}
