package com.banco.proyectoBanco.errors;

public class PasswordsDontMatch extends Exception {
    public PasswordsDontMatch(String msg) {
        super(msg);
    }
}

