package com.banco.proyectoBanco.model.accounts;

import com.banco.proyectoBanco.errors.BriefcaseExceededLimit;
import com.banco.proyectoBanco.errors.EconomicAccountCantTransfer;
import com.banco.proyectoBanco.model.Account;
import com.banco.proyectoBanco.model.Briefcase;

import javax.persistence.Entity;

@Entity
public class EconomicAccount extends Account {

    public EconomicAccount() {
        super();
        this.briefcaseList.add(new Briefcase(this, briefcasesNumber));
    }

    @Override
    public void addBriefcase(String currency) throws BriefcaseExceededLimit {
        throw new BriefcaseExceededLimit("You past your limit of briefcase to your account, upgrade it!");
    }

    @Override
    public void transferTo(Briefcase myBriefcase, Briefcase briefcaseToTransfer, double money, double moneyConverted) throws EconomicAccountCantTransfer {
        throw new EconomicAccountCantTransfer("This type of account cannot make transfers");
    }

}
