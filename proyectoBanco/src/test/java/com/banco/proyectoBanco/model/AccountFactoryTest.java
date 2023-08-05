package com.banco.proyectoBanco.model;

import com.banco.proyectoBanco.errors.AmmountHasToBeValid;
import com.banco.proyectoBanco.errors.NonExistentAccountType;
import com.banco.proyectoBanco.model.accounts.EconomicAccount;
import com.banco.proyectoBanco.model.accounts.PremiumAccount;
import com.banco.proyectoBanco.model.accounts.StandardAccount;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class AccountFactoryTest {

    @Test
    void createEconomicAccount() throws NonExistentAccountType {
        Account account = AccountFactory.createAccount("economic");
        Assertions.assertEquals(EconomicAccount.class, account.getClass());
    }

    @Test
    void createStandardAccount() throws NonExistentAccountType {
        Account account = AccountFactory.createAccount("standard");
        Assertions.assertEquals(StandardAccount.class, account.getClass());
    }

    @Test
    void createPremiumAccount() throws NonExistentAccountType {
        Account account = AccountFactory.createAccount("premium");
        Assertions.assertEquals(PremiumAccount.class, account.getClass());
    }

    @Test
    void createNonExistentAccount() {
        Assertions.assertThrows(NonExistentAccountType.class, () -> {
            AccountFactory.createAccount("executive");
        });
    }
}
