package com.banco.proyectoBanco.service;

import com.banco.proyectoBanco.model.Account;
import com.banco.proyectoBanco.model.Briefcase;
import com.banco.proyectoBanco.repository.BriefcaseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;


@Service
public class BriefcaseService {

    @Autowired
    private BriefcaseRepository briefcaseRepository;

    public List<Briefcase> getBriefcases(Account account) {
        List<Briefcase> briefcaseList = briefcaseRepository.findAll();
        List<Briefcase> briefcasesUser = new ArrayList<>();
        for (Briefcase actual : briefcaseList) {
            if(actual.getAccount().getId() == account.getId()) {
                briefcasesUser.add(actual);
            }
        }
        return briefcasesUser;
    }

    public Optional<Briefcase> getBriefcase(Account account, int briefcase) {
        List<Briefcase> briefcaseList = getBriefcases(account);
        for (Briefcase actual : briefcaseList) {
            if (actual.getBriefcaseNumber() == briefcase) {
                return Optional.of(actual);
            }
        }
        return Optional.empty();
    }

    public void update(Briefcase costumerBriefcase) { this.briefcaseRepository.saveAndFlush(costumerBriefcase); }

    public void delete(Briefcase userBriefcase) { briefcaseRepository.delete(userBriefcase);}
}
