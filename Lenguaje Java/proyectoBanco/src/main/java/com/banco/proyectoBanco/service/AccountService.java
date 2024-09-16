package com.banco.proyectoBanco.service;

import com.banco.proyectoBanco.model.Account;
import com.banco.proyectoBanco.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class AccountService {

    @Autowired
    private AccountRepository accountRepository;

    public Optional<Account> getAccountById(long id) { return accountRepository.findById(id); }

    public void update(Account account) { accountRepository.saveAndFlush(account); }

    public Optional<Account> getAccountByCbu(String cbu) { return accountRepository.findByCbu(cbu); }
}
