package com.banco.proyectoBanco.service;

import com.banco.proyectoBanco.errors.NonExistentAccountType;
import com.banco.proyectoBanco.model.Account;
import com.banco.proyectoBanco.repository.AccountRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

class AccountServiceTest {

    @Mock
    private AccountRepository accountRepository;

    @InjectMocks
    private AccountService accountService;

    private Account account;

    @BeforeEach
    void setUp() throws NonExistentAccountType {
        MockitoAnnotations.openMocks(this);
        account = new Account();
    }

    @Test
    void getAccountById() {
        Mockito.when(accountRepository.findById(account.getId())).thenReturn(Optional.of(account));
        assertEquals(Optional.of(account), accountService.getAccountById(account.getId()));
    }

    @Test
    void getAccountByCbu() {
        Mockito.when(accountRepository.findByCbu(account.getCbu())).thenReturn(Optional.of(account));
        assertEquals(Optional.of(account), accountService.getAccountByCbu(account.getCbu()));
    }
}