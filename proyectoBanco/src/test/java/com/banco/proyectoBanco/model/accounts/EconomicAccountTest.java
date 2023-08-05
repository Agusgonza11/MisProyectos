package com.banco.proyectoBanco.model.accounts;

import com.banco.proyectoBanco.errors.AmmountHasToBeValid;
import com.banco.proyectoBanco.errors.BriefcaseExceededLimit;
import com.banco.proyectoBanco.errors.EconomicAccountCantTransfer;
import com.banco.proyectoBanco.model.Account;
import com.banco.proyectoBanco.model.Briefcase;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class EconomicAccountTest {

    @Test
    void addBriefcaseToAccount() {
        EconomicAccount account = new EconomicAccount();
        Assertions.assertThrows(BriefcaseExceededLimit.class, () -> {
            account.addBriefcase("ARS");
        });
    }

    @Test
    void transferToAnotherAccount() {
        EconomicAccount account = new EconomicAccount();
        Assertions.assertThrows(EconomicAccountCantTransfer.class, () -> {
            account.transferTo(new Briefcase(account, 0), new Briefcase(), 100, 100);
        });
    }
}
