package com.banco.proyectoBanco.model.accounts;

import com.banco.proyectoBanco.errors.AmmountHasToBeValid;
import com.banco.proyectoBanco.errors.BriefcaseDontHaveMoney;
import com.banco.proyectoBanco.errors.BriefcaseExceededLimit;
import com.banco.proyectoBanco.errors.CurrencyNotAvailable;
import com.banco.proyectoBanco.model.Account;
import com.banco.proyectoBanco.model.Briefcase;
import javax.persistence.Entity;
import javax.persistence.Transient;
import java.util.Objects;

@Entity
public class StandardAccount extends Account {

    @Transient
    final String argCurrency = "ARS";
    @Transient
    final String usdCurrency = "USD";
    @Transient
    final int limitBriefcase = 5;

    public StandardAccount() {
        super();
        this.briefcaseList.add(new Briefcase(this, briefcasesNumber));
        this.briefcasesNumber++;
    }

    @Override
    public void addBriefcase(String currency) throws CurrencyNotAvailable, BriefcaseExceededLimit {
        if (briefcaseList.size() == limitBriefcase) {
            throw new BriefcaseExceededLimit("You exceeded the limit of briefcases available for your account");
        }
        if (!Objects.equals(currency, argCurrency) && !Objects.equals(currency, usdCurrency)) {
            throw new CurrencyNotAvailable("You are not allowed to trade with that currency, upgrade your account");
        }
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
