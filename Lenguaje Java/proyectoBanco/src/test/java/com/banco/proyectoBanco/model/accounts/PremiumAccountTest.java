package com.banco.proyectoBanco.model.accounts;

import com.banco.proyectoBanco.errors.AmmountHasToBeValid;
import com.banco.proyectoBanco.errors.BriefcaseDontHaveMoney;
import com.banco.proyectoBanco.model.Account;
import com.banco.proyectoBanco.model.Briefcase;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class PremiumAccountTest {

    @Test
    void addBriefcaseToAccount() {
        PremiumAccount account = new PremiumAccount();
        account.addBriefcase("ARS");
        Assertions.assertEquals(2, account.getBriefcaseList().size());
        account.addBriefcase("EUR");
        Assertions.assertEquals(3, account.getBriefcaseList().size());
    }

    @Test
    void transferToAnotherAccount() throws AmmountHasToBeValid, BriefcaseDontHaveMoney {
        PremiumAccount account = new PremiumAccount();
        account.getBriefcaseList().get(0).deposit(100);
        Briefcase briefcase = new Briefcase(new Account(), 0);
        account.transferTo(account.getBriefcaseList().get(0), briefcase, 100, 100);
        Assertions.assertEquals(100, briefcase.getMoney());
    }

    @Test
    void transferToAnotherAccountWithoutMoney() throws AmmountHasToBeValid {
        PremiumAccount account = new PremiumAccount();
        Assertions.assertThrows(BriefcaseDontHaveMoney.class, () -> {
            account.transferTo(new Briefcase(account, 0), new Briefcase(), 100, 100);
        });
    }
}
