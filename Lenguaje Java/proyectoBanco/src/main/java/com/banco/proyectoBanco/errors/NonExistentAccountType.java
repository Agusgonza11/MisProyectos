package com.banco.proyectoBanco.errors;

public class NonExistentAccountType extends Exception {
    public NonExistentAccountType(String msg) {
        super(msg);
    }
}
