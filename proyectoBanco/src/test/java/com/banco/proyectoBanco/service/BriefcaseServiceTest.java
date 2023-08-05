package com.banco.proyectoBanco.service;

import com.banco.proyectoBanco.errors.NonExistentAccountType;
import com.banco.proyectoBanco.model.Account;
import com.banco.proyectoBanco.model.Briefcase;
import com.banco.proyectoBanco.repository.BriefcaseRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import java.util.List;
import java.util.Optional;
import static org.junit.jupiter.api.Assertions.*;

class BriefcaseServiceTest {

    @Mock
    private BriefcaseRepository briefcaseRepository;

    @InjectMocks
    private BriefcaseService briefcaseService;

    private Briefcase briefcase;
    private Account account;

    @BeforeEach
    void setUp() throws NonExistentAccountType {
        MockitoAnnotations.openMocks(this);
        account = new Account();
        briefcase = new Briefcase(account, 0);
    }

    @Test
    void getBriefcases() {
        Mockito.when(briefcaseRepository.findAll()).thenReturn(List.of(briefcase));
        assertEquals(List.of(briefcase),briefcaseService.getBriefcases(account));
    }

    @Test
    void getBriefcase() {
        Mockito.when(briefcaseRepository.findAll()).thenReturn(List.of(briefcase));
        assertEquals(Optional.of(briefcase), briefcaseService.getBriefcase(account, 0));
    }

    @Test
    void delete() {
        briefcaseService.delete(briefcase);
        Mockito.verify(briefcaseRepository).delete(briefcase);
    }
}