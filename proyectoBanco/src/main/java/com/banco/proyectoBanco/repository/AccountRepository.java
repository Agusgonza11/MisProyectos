package com.banco.proyectoBanco.repository;

import com.banco.proyectoBanco.model.Account;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface AccountRepository extends JpaRepository<Account, Long> {
    default Optional<Account> findByCbu(String cbu){
        List<Account> accounts = findAll();
        for (Account actual : accounts) {
            if (actual.getCbu().equals(cbu)) {
                return Optional.of(actual);
            }
        }
        return Optional.empty();
    }
}
