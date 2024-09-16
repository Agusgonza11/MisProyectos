package com.banco.proyectoBanco.model;

import com.banco.proyectoBanco.errors.AmmountHasToBeValid;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Assertions;


public class BriefcaseTest {

    @Test
    void depositMoneyInBriefcase() throws AmmountHasToBeValid {
        Briefcase briefcase = new Briefcase(new Account(), 0);
        briefcase.deposit(100);
        Assertions.assertEquals(100, briefcase.getMoney());
    }

    @Test
    void depositMoneyNegativeInBriefcase() {
        Briefcase briefcase = new Briefcase(new Account(), 0);
        Assertions.assertThrows(AmmountHasToBeValid.class, () -> {
            briefcase.deposit(-100);
        });
    }

    @Test
    void depositNoMoneyInBriefcase() {
        Briefcase briefcase = new Briefcase(new Account(), 0);
        Assertions.assertThrows(AmmountHasToBeValid.class, () -> {
            briefcase.deposit(0);
        });
    }

    @Test
    void extractMoneyInBriefcase() throws AmmountHasToBeValid {
        Briefcase briefcase = new Briefcase(new Account(), 0);
        briefcase.deposit(100);
        briefcase.extract(25);
        Assertions.assertEquals(75, briefcase.getMoney());
    }

    @Test
    void extractMoneyNegativeInBriefcase() throws AmmountHasToBeValid {
        Briefcase briefcase = new Briefcase(new Account(), 0);
        briefcase.deposit(100);
        Assertions.assertThrows(AmmountHasToBeValid.class, () -> {
            briefcase.extract(-10);
        });
    }

    @Test
    void extractNoMoneyInBriefcase() throws AmmountHasToBeValid {
        Briefcase briefcase = new Briefcase(new Account(), 0);
        briefcase.deposit(100);
        Assertions.assertThrows(AmmountHasToBeValid.class, () -> {
            briefcase.extract(0);
        });
    }

    @Test
    void extractLessMoneyThanAvailable() throws AmmountHasToBeValid {
        Briefcase briefcase = new Briefcase(new Account(), 0);
        briefcase.deposit(100);
        Assertions.assertFalse(briefcase.extract(200));
    }

    @Test
    void transferMoneyToAnotherBriefcase() throws AmmountHasToBeValid {
        Briefcase briefcase = new Briefcase(new Account(), 0);
        Briefcase anotherBriefcase = new Briefcase(new Account(), 0);
        briefcase.deposit(100);
        briefcase.transfer(100, 100, anotherBriefcase);
        Assertions.assertEquals(0, briefcase.getMoney());
        Assertions.assertEquals(100, anotherBriefcase.getMoney());
    }

    @Test
    void transferMoneyNegativeAnotherBriefcase() throws AmmountHasToBeValid {
        Briefcase briefcase = new Briefcase(new Account(), 0);
        Briefcase anotherBriefcase = new Briefcase(new Account(), 0);
        briefcase.deposit(100);
        Assertions.assertThrows(AmmountHasToBeValid.class, () -> {
            briefcase.transfer(-50, 50, anotherBriefcase);
        });
    }

    @Test
    void transferMoneyWithAnotherCurrency() throws AmmountHasToBeValid {
        Briefcase briefcase = new Briefcase(new Account(), 0);
        Briefcase anotherBriefcase = new Briefcase(new Account(),0);
        briefcase.deposit(100);
        briefcase.transfer(50, 10, anotherBriefcase);
        Assertions.assertEquals(50, briefcase.getMoney());
        Assertions.assertEquals(10, anotherBriefcase.getMoney());
    }
}
