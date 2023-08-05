package com.banco.proyectoBanco.errors;

public class AccountDontExist extends Exception {
    public AccountDontExist(String msg) {
        super(msg);
    }
}

