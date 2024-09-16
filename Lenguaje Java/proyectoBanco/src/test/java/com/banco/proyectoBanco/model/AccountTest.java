package com.banco.proyectoBanco.model;

import com.banco.proyectoBanco.errors.AmmountHasToBeValid;
import com.banco.proyectoBanco.errors.BriefcaseDontExist;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

public class AccountTest {

    @Test
    void getBriefcaseByTheBriefcaseNumber() throws BriefcaseDontExist {
        List<Briefcase> briefcaseList = new ArrayList<>();
        Briefcase firstBriefcase = new Briefcase(new Account(), 0);
        Briefcase secondBriefcase = new Briefcase(new Account(), 2);
        briefcaseList.add(firstBriefcase);
        briefcaseList.add(secondBriefcase);
        Account account = new Account();
        account.setBriefcaseList(briefcaseList);
        Briefcase briefcase = account.getBriefcaseByIndex(0);
        Briefcase anotherBriefcase = account.getBriefcaseByIndex(2);
        Assertions.assertEquals(firstBriefcase, briefcase);
        Assertions.assertEquals(secondBriefcase, anotherBriefcase);
    }

    @Test
    void getBriefcaseByTheBriefcaseNumberNonexistent() throws BriefcaseDontExist {
        List<Briefcase> briefcaseList = new ArrayList<>();
        Briefcase firstBriefcase = new Briefcase(new Account(), 0);
        briefcaseList.add(firstBriefcase);
        Account account = new Account();
        account.setBriefcaseList(briefcaseList);
        Assertions.assertThrows(BriefcaseDontExist.class, () -> {
            account.getBriefcaseByIndex(1);
        });
    }

    @Test
    void updateBriefcasesIndexes() {
        List<Briefcase> briefcaseList = new ArrayList<>();
        briefcaseList.add(new Briefcase(new Account(), 0));
        briefcaseList.add(new Briefcase(new Account(), 2));
        Account account = new Account();
        account.setBriefcaseList(briefcaseList);
        account.updateBriefcaseListIndex(2);
        Assertions.assertEquals(0, account.getBriefcaseList().get(0).getBriefcaseNumber());
        Assertions.assertEquals(1, account.getBriefcaseList().get(1).getBriefcaseNumber());
    }
}
