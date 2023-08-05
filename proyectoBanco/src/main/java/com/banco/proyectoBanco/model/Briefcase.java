package com.banco.proyectoBanco.model;

import com.banco.proyectoBanco.errors.AmmountHasToBeValid;
import com.fasterxml.jackson.annotation.JsonBackReference;

import javax.persistence.*;

@Entity
@Table (name = "briefcases")
public class Briefcase {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    private double money;
    private String currency;

    private int briefcaseNumber;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id")
    @JsonBackReference
    Account account;

    @Transient
    final String argCurrency = "ARS";

    public Briefcase() {
    }

    public Briefcase(Account account, int briefcaseNumber){
        this.account = account;
        this.briefcaseNumber = briefcaseNumber;
        this.money = 0;
        this.currency = argCurrency;
    }

    public Briefcase(Account account, String currency, int briefcaseNumber){
        this.account = account;
        this.briefcaseNumber = briefcaseNumber;
        this.money = 0;
        this.currency = currency;
    }

    public void deposit(double amount) throws AmmountHasToBeValid {
        if (amount <= 0) {
            throw new AmmountHasToBeValid("The amount has to be valid");
        }
        this.money += amount;
    }

    public boolean extract(double amount) throws AmmountHasToBeValid {
        if (amount <= 0) {
            throw new AmmountHasToBeValid("The amount has to be valid");
        }
        if (this.money - amount < 0) {
            return false;
        }
        this.money -= amount;
        return true;
    }

    public boolean transfer(double amount, double amountConverted, Briefcase toBriefcase) throws AmmountHasToBeValid {
        if (extract(amount)) {
            toBriefcase.deposit(amountConverted);
            return true;
        }
        return false;
    }

    public boolean haveBriefcaseNumber(int briefcase) {
        return briefcase == this.briefcaseNumber;
    }

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }

    public int getBriefcaseNumber() {
        return briefcaseNumber;
    }

    public void updateBriefcaseNumber() { this.briefcaseNumber--; }

    public String getCurrency() { return currency; }


    //-----  Getters and Setters unused  --------------------------------------

    public double getMoney() { return money; }

    public void setCurrency(String currency) { this.currency = currency; }

    public void setMoney(long money) {
        this.money = money;
    }

    public void setBriefcaseNumber(int briefcaseNumber) { this.briefcaseNumber = briefcaseNumber; }

}
