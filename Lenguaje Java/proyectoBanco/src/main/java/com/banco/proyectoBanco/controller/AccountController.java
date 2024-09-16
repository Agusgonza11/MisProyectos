package com.banco.proyectoBanco.controller;

import com.banco.proyectoBanco.errors.*;
import com.banco.proyectoBanco.model.Account;
import com.banco.proyectoBanco.model.Briefcase;
import com.banco.proyectoBanco.model.User;
import com.banco.proyectoBanco.service.AccountService;
import com.banco.proyectoBanco.service.BriefcaseService;
import com.banco.proyectoBanco.service.UserService;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@RestController
@RequestMapping("/user")
public class AccountController {

    @Autowired
    private AccountService accountService;
    @Autowired
    private UserService userService;
    @Autowired
    private BriefcaseService briefcaseService;

    @GetMapping("/{id}")
    public List<Briefcase> getBriefcasesByUser(@PathVariable long id){
        Optional<User> users = userService.getUserById(id);
        if (users.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "User don't exist");
        }
        User costumer = users.get();
        return briefcaseService.getBriefcases(costumer.getAccount());
    }

    @PostMapping("/{id}/addBriefcase")
    public ResponseEntity<String> addBriefcase(@PathVariable long id, @RequestParam String coin){
        try {
            Account account = getAccountById(id);
            account.addBriefcase(coin);
            accountService.update(account);
        } catch (Exception exception) {
            return new ResponseEntity<>(exception.getMessage(), HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity<>("The briefcase was created successfully", HttpStatus.CREATED);
    }

    @DeleteMapping("/{id}/{briefcase}/deleteBriefcase")
    public ResponseEntity<String> deleteBriefcase(@PathVariable long id, @PathVariable int briefcase) {
        try {
            Account account = getAccountById(id);
            Briefcase userBriefcase = getBriefcaseByIdAndBriefcaseNumber(id, briefcase);
            if (!account.delete(briefcase)){
                return new ResponseEntity<>("The briefcase cannot be removed", HttpStatus.FAILED_DEPENDENCY);
            }
            briefcaseService.delete(userBriefcase);
        } catch (Exception exception) {
            return new ResponseEntity<>(exception.getMessage(), HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity<>("The briefcase was successfully removed", HttpStatus.ACCEPTED);
    }

    @PostMapping("/{id}/{briefcase}/deposit")
    public ResponseEntity<String> depositMoney(@PathVariable long id, @PathVariable int briefcase, @RequestParam double money){
        try {
            Briefcase userBriefcase = getBriefcaseByIdAndBriefcaseNumber(id, briefcase);
            userBriefcase.deposit(money);
            briefcaseService.update(userBriefcase);
        } catch (Exception exception) {
            return new ResponseEntity<>(exception.getMessage(), HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity<>("Your deposit of $" + money + " was made successfully", HttpStatus.ACCEPTED);
    }

    @PostMapping("/{id}/{briefcase}/extract")
    public ResponseEntity<String> extractMoney(@PathVariable long id, @PathVariable int briefcase, @RequestParam double money) throws BriefcaseDontExist, UserDontExist {
        try {
          Briefcase userBriefcase = getBriefcaseByIdAndBriefcaseNumber(id, briefcase);
            if (!userBriefcase.extract(money)) {
                return new ResponseEntity<>("The selected briefcase does not have that amount of money", HttpStatus.BAD_REQUEST);
            }
            briefcaseService.update(userBriefcase);
        } catch (Exception exception) {
            return new ResponseEntity<>(exception.getMessage(), HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity<>("Your extraction of $" + money + " was made successfully", HttpStatus.ACCEPTED);
    }

    @PostMapping("/{id}/{briefcase}/transfer")
    public ResponseEntity<String> transferMoney(@PathVariable long id, @PathVariable int briefcase, @RequestParam String cbu, @RequestParam int briefcaseDest, @RequestParam double money) {
        try {
            Account account = getAccountById(id);
            Optional<Account> accountToTransfer = accountService.getAccountByCbu(cbu);
            if (accountToTransfer.isEmpty()) {
                throw new AccountDontExist("The account don't exist");
            }
            String currencyToConvert = account.getBriefcaseByIndex(briefcase).getCurrency();
            String destinationCurrency = accountToTransfer.get().getBriefcaseByIndex(briefcaseDest).getCurrency();
            double moneyConverted = currencyConverter(currencyToConvert, destinationCurrency, money);
            account.transfer(briefcase, accountToTransfer.get(), briefcaseDest, money, moneyConverted);
            accountService.update(account);
        } catch (Exception exception) {
            return new ResponseEntity<>(exception.getMessage(), HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity<>("Your transfer of $" + money + " was made successfully", HttpStatus.ACCEPTED);
    }


    private Briefcase getBriefcaseByIdAndBriefcaseNumber(long id, int briefcase) throws UserDontExist, BriefcaseDontExist {
        Optional<User> users = userService.getUserById(id);
        if (users.isEmpty()) {
            throw new UserDontExist("User don't exist");
        }
        User costumer = users.get();
        Optional<Briefcase> userBriefcase = briefcaseService.getBriefcase(costumer.getAccount(), briefcase);
        if (userBriefcase.isEmpty()) {
            throw new BriefcaseDontExist("The briefcase don't exist");
        }
        return userBriefcase.get();
    }

    private Account getAccountById(long id) throws UserDontExist, AccountDontExist {
        Optional<User> users = userService.getUserById(id);
        if (users.isEmpty()) {
            throw new UserDontExist("User don't exist");
        }
        User costumer = users.get();
        Optional<Account> accounts = accountService.getAccountById(costumer.getAccount().getId());
        if (accounts.isEmpty()) {
            throw new AccountDontExist("The account don't exist");
        }
        return accounts.get();
    }

    private double currencyConverter(String currencyToConvert, String baseCurrency, double money) throws IOException, JSONException {
        String url = "https://api.apilayer.com/currency_data/convert?to=" + baseCurrency + "&from=" + currencyToConvert + "&amount=" + money;
        OkHttpClient client = new OkHttpClient().newBuilder().build();
        Request request = new Request.Builder()
                .url(url)
                .addHeader("apikey", "fNLC311lQrY4SNtg589DSTnaLA4u1aN5")
                .build();
        Response response = client.newCall(request).execute();
        String resStr = Objects.requireNonNull(response.body()).string();
        JSONObject json = new JSONObject(resStr);
        return Double.parseDouble(json.get("result").toString());
    }

}
