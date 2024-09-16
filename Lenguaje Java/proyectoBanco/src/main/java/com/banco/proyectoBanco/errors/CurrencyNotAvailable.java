package com.banco.proyectoBanco.errors;

public class CurrencyNotAvailable extends Exception {
    public CurrencyNotAvailable(String msg) {
        super(msg);
    }
}

