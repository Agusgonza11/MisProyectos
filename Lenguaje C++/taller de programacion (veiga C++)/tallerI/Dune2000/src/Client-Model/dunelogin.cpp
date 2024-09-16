#include "dunelogin.h"
#include "./ui_dunelogin.h"

DuneLogin::DuneLogin(Socket* skt,QWidget *parent)
    : QMainWindow(parent)
    ,ui(new Ui::DuneLogin)
{
    this->socket = skt;
    ui->setupUi(this);
    ui->stackedWidget->setCurrentIndex(0);
    this->currentHouseIndex = 0;
    this->currentHouseIndexJoin = 0;
}

DuneLogin::~DuneLogin()
{
    delete ui;
}


void DuneLogin::on_newGameButton_clicked()
{
    ui->stackedWidget->setCurrentIndex(1);


}


void DuneLogin::on_backNew_clicked()
{
    ui->stackedWidget->setCurrentIndex(0);
}


void DuneLogin::on_joinGameButton_clicked()
{
    ui->stackedWidget->setCurrentIndex(3);
}


void DuneLogin::on_startNewGame_clicked()
{

}

void DuneLogin::selectHouse(){
    switch (currentHouseIndex) {
    case 0:
        ui->house->setPixmap(QString::fromUtf8("resources/login/EBFD_Atreides_Logo.png"));
        ui->houseNameLabel->setText("Atreides");
        break;
    case 1:
        ui->house->setPixmap(QString::fromUtf8("resources/login/EBFD_Ordos_Logo.png"));
        ui->houseNameLabel->setText("Ordos");
        break;
    case 2:
        ui->house->setPixmap(QString::fromUtf8("resources/login/EBFD_Harkonnen_Logo.png"));
        ui->houseNameLabel->setText("Harkonnen");
    }

     ui->houseNameLabelJoin->setAlignment(Qt::AlignCenter);
}

void DuneLogin::on_nextHouse_clicked()
{
    if(currentHouseIndex==2){
        currentHouseIndex = 0;
    }else{
        currentHouseIndex++;
    }
   selectHouse();
}


void DuneLogin::on_prevHouse_clicked()
{
    if(currentHouseIndex==0){
        currentHouseIndex = 2;
    }else{
        currentHouseIndex--;
    }
    selectHouse();
}



void DuneLogin::on_backjoin_clicked()
{
    ui->stackedWidget->setCurrentIndex(0);
}


void DuneLogin::on_startJoin_clicked()
{

}


void DuneLogin::selectHouseJoin(){
    switch (currentHouseIndexJoin) {
    case 0:
        ui->houseJoin->setPixmap(QString::fromUtf8("resources/login/EBFD_Atreides_Logo.png"));
        ui->houseNameLabelJoin->setText("Atreides");
        break;
    case 1:
        ui->houseJoin->setPixmap(QString::fromUtf8("resources/login/EBFD_Ordos_Logo.png"));
        ui->houseNameLabelJoin->setText("Ordos");
        break;
    case 2:
        ui->houseJoin->setPixmap(QString::fromUtf8("resources/login/EBFD_Harkonnen_Logo.png"));
        ui->houseNameLabelJoin->setText("Harkonnen");
    }

    ui->houseNameLabelJoin->setAlignment(Qt::AlignCenter);
}



void DuneLogin::on_prevHouseJoin_clicked()
{
    if(currentHouseIndexJoin==0){
        currentHouseIndexJoin = 2;
    }else{
        currentHouseIndexJoin--;
    }
    selectHouseJoin();
}


void DuneLogin::on_nextHouseJoin_clicked()
{
    if(currentHouseIndexJoin==0){
        currentHouseIndexJoin = 2;
    }else{
        currentHouseIndexJoin--;
    }
    selectHouseJoin();
}


void DuneLogin::on_reloadButton_clicked()
{

}


void DuneLogin::on_progressBar_valueChanged(int value)
{
    ui->progressBar->setValue(value);
}

