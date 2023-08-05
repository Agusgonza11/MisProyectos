package com.banco.proyectoBanco.model;

import com.banco.proyectoBanco.errors.*;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;


@Entity
@Table (name = "accounts")
public class Account {
    @Transient
    final int cbuLimit = 22;
    @Transient
    final long minCbuDigits = 100000000;
    @Transient
    final long maxCbuDigits = 999999999;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @Column(unique = true, length = cbuLimit)
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private String cbu;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "account", cascade = CascadeType.ALL)
    @JsonManagedReference
    protected List<Briefcase> briefcaseList;

    protected int briefcasesNumber;

    public Account() {
        this.briefcasesNumber = 0;
        this.briefcaseList = new ArrayList<>();
        long random = (long)(Math.random() * ( minCbuDigits - maxCbuDigits + 1 ) + maxCbuDigits);
        this.cbu = String.valueOf(id) + random;
    }

    public final boolean delete(int briefcase) {
        if (briefcaseList.size() == 1) {
            return false;
        }
        briefcaseList.removeIf(actual -> actual.haveBriefcaseNumber(briefcase));
        updateBriefcaseListIndex(briefcase);
        return true;
    }

    public void updateBriefcaseListIndex(int briefcase) {
        boolean change = false;
        for (Briefcase value : briefcaseList) {
            if (value.getBriefcaseNumber() >= briefcase) {
                change = true;
                value.updateBriefcaseNumber();
            }
        }
        if (change) { this.briefcasesNumber--; }
    }

    public Briefcase getBriefcaseByIndex(int briefcase) throws BriefcaseDontExist {
        Briefcase myBriefcase = null;
        for (Briefcase actual : briefcaseList) {
            if (actual.haveBriefcaseNumber(briefcase)) {
                myBriefcase = actual;
            }
        }
        if (myBriefcase == null) {
            throw new BriefcaseDontExist("The briefcase don't exist");
        }
        return myBriefcase;
    }

    public void transfer(int briefcase, Account account, int briefcaseDest, double money, double moneyConverted) throws BriefcaseDontExist, EconomicAccountCantTransfer, BriefcaseDontHaveMoney, AmmountHasToBeValid {
        Briefcase myBriefcase = getBriefcaseByIndex(briefcase);
        Briefcase briefcaseToTransfer = account.getBriefcaseByIndex(briefcaseDest);
        transferTo(myBriefcase, briefcaseToTransfer, money, moneyConverted);
    }

    public long getId() {
        return id;
    }

    public String getCbu() {
        return cbu;
    }

    public void addBriefcase(String currency) throws BriefcaseExceededLimit, CurrencyNotAvailable {
    }

    public void transferTo(Briefcase myBriefcase, Briefcase briefcaseToTransfer, double money, double moneyConverted) throws EconomicAccountCantTransfer, BriefcaseDontHaveMoney, AmmountHasToBeValid {
    }


    //-----  Getters and Setters unused  --------------------------------------


    public void setId(long id) {
        this.id = id;
    }

    public void setCbu(String cbu) {
        this.cbu = cbu;
    }

    public List<Briefcase> getBriefcaseList() {
        return briefcaseList;
    }

    public void setBriefcaseList(List<Briefcase> briefcaseList) {
        this.briefcaseList = briefcaseList;
    }

}
