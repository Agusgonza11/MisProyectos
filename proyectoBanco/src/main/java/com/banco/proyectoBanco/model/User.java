package com.banco.proyectoBanco.model;

import com.banco.proyectoBanco.controller.dto.UserDto;
import com.banco.proyectoBanco.errors.NonExistentAccountType;

import javax.persistence.*;

@Entity
@Table (name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    private String firstName;
    private String lastName;
    private String password;
    private String username;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "account_id", referencedColumnName = "id")
    private Account account;

    public User() {
    }

    public User(String firstName, String lastName, String username, String account, String password) throws NonExistentAccountType {
        this.firstName = firstName;
        this.lastName = lastName;
        this.username = username;
        this.account = AccountFactory.createAccount(account);
        this.password = password;
    }

    public User(UserDto userDto) throws NonExistentAccountType {
        this.firstName = userDto.getFirstName();
        this.lastName = userDto.getLastName();
        this.username = userDto.getUsername();
        this.account = AccountFactory.createAccount(userDto.getAccount());
        this.password = userDto.getPassword();
    }

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }

    public String getUsername() {
        return username;
    }

    public boolean delete(String password) {
        return this.password.equals(password);
    }

    public void setPassword(String password) {
        this.password = password;
    }


    //-----  Getters and Setters unused  --------------------------------------

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPassword() {
        return password;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
