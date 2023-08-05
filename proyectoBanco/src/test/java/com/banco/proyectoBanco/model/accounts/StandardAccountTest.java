package com.banco.proyectoBanco.model.accounts;

import com.banco.proyectoBanco.errors.AmmountHasToBeValid;
import com.banco.proyectoBanco.errors.BriefcaseDontHaveMoney;
import com.banco.proyectoBanco.errors.BriefcaseExceededLimit;
import com.banco.proyectoBanco.errors.CurrencyNotAvailable;
import com.banco.proyectoBanco.model.Account;
import com.banco.proyectoBanco.model.Briefcase;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class StandardAccountTest {

    @Test
    void addBriefcaseToAccount() throws CurrencyNotAvailable, BriefcaseExceededLimit {
        StandardAccount account = new StandardAccount();
        account.addBriefcase("ARS");
        Assertions.assertEquals(2, account.getBriefcaseList().size());
        account.addBriefcase("USD");
        Assertions.assertEquals(3, account.getBriefcaseList().size());
    }

    @Test
    void addBriefcaseToAccountExceededLimit() throws CurrencyNotAvailable, BriefcaseExceededLimit {
        StandardAccount account = new StandardAccount();
        account.addBriefcase("ARS");
        account.addBriefcase("ARS");
        account.addBriefcase("ARS");
        account.addBriefcase("ARS");
        Assertions.assertThrows(BriefcaseExceededLimit.class, () -> {
            account.addBriefcase("ARS");
        });
    }

    @Test
    void addBriefcaseToAccountNoCurrency() throws CurrencyNotAvailable, BriefcaseExceededLimit {
        StandardAccount account = new StandardAccount();
        account.addBriefcase("ARS");
        account.addBriefcase("USD");
        Assertions.assertThrows(CurrencyNotAvailable.class, () -> {
            account.addBriefcase("EUR");
        });
    }

    @Test
    void transferToAnotherAccount() throws AmmountHasToBeValid, BriefcaseDontHaveMoney {
        StandardAccount account = new StandardAccount();
        account.getBriefcaseList().get(0).deposit(100);
        Briefcase briefcase = new Briefcase(new Account(), 0);
        account.transferTo(account.getBriefcaseList().get(0), briefcase, 100, 100);
        Assertions.assertEquals(100, briefcase.getMoney());
    }

    @Test
    void transferToAnotherAccountWithoutMoney() throws AmmountHasToBeValid {
        StandardAccount account = new StandardAccount();
        Assertions.assertThrows(BriefcaseDontHaveMoney.class, () -> {
            account.transferTo(new Briefcase(account, 0), new Briefcase(), 100, 100);
        });
    }
}
