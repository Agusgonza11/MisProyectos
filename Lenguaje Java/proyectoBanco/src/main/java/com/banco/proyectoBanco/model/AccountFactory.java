package com.banco.proyectoBanco.model;

import com.banco.proyectoBanco.errors.NonExistentAccountType;
import com.banco.proyectoBanco.model.accounts.EconomicAccount;
import com.banco.proyectoBanco.model.accounts.PremiumAccount;
import com.banco.proyectoBanco.model.accounts.StandardAccount;

public class AccountFactory {
    public static Account createAccount(String account) throws NonExistentAccountType {
        return switch (account) {
            case "economic" -> new EconomicAccount();
            case "standard" -> new StandardAccount();
            case "premium" -> new PremiumAccount();
            default -> throw new NonExistentAccountType("Non-existent account type");
        };
    }
}
