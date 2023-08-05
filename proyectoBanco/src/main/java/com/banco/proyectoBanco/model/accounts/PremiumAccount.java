package com.banco.proyectoBanco.model.accounts;

import com.banco.proyectoBanco.errors.AmmountHasToBeValid;
import com.banco.proyectoBanco.errors.BriefcaseDontHaveMoney;
import com.banco.proyectoBanco.model.Account;
import com.banco.proyectoBanco.model.Briefcase;
import javax.persistence.Entity;

@Entity
public class PremiumAccount extends Account {

    public PremiumAccount() {
        super();
        this.briefcaseList.add(new Briefcase(this, briefcasesNumber));
        this.briefcasesNumber++;
    }

    @Override
    public void addBriefcase(String currency) {
        this.briefcaseList.add(new Briefcase(this, currency, briefcasesNumber));
        this.briefcasesNumber++;
    }

    @Override
    public void transferTo(Briefcase myBriefcase, Briefcase briefcaseToTransfer, double money, double moneyConverted) throws BriefcaseDontHaveMoney, AmmountHasToBeValid {
        if (!myBriefcase.transfer(money, moneyConverted, briefcaseToTransfer)) {
            throw new BriefcaseDontHaveMoney("The selected briefcase does not have that amount of money");
        }
    }

}
