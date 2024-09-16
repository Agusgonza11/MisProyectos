#include "loginscreen.h"
#include "./ui_loginscreen.h"

LoginScreen::LoginScreen(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::LoginScreen)
{
    ui->setupUi(this);
    ui->stackedWidget->setCurrentIndex(0);
    this->currentHouseIndex = 0;
}

LoginScreen::~LoginScreen()
{
    delete ui;
}


void LoginScreen::on_pushButton_clicked()
{
    currentHouseIndex = 0;
    ui->stackedWidget->setCurrentIndex(1);
}

void LoginScreen::selectHouse(){
    switch (currentHouseIndex) {
    case 0:
        ui->label_8->setPixmap(QString::fromUtf8("/home/lucas/Desktop/Taller I/Dune2000/src/Client/resources/EBFD_Atreides_Logo.png"));
        ui->label_9->setText("Atreides");
        break;
    case 1:
        ui->label_8->setPixmap(QString::fromUtf8("/home/lucas/Desktop/Taller I/Dune2000/src/Client/resources/EBFD_Ordos_Logo.png"));
        ui->label_9->setText("Ordos");
        break;
    case 2:
        ui->label_8->setPixmap(QString::fromUtf8("/home/lucas/Desktop/Taller I/Dune2000/src/Client/resources/EBFD_Harkonnen_Logo.png"));
        ui->label_9->setText("Harkonnen");
    }

    ui->label_9->setAlignment(Qt::AlignCenter);
    ui->label_9->setStyleSheet("font-weight: bold");
}


void LoginScreen::on_pushButton_4_clicked()
{
    ui->stackedWidget->setCurrentIndex(0);
}


void LoginScreen::on_pushButton_7_clicked()
{
    if(currentHouseIndex==2){
        currentHouseIndex = 0;
    }else{
        currentHouseIndex++;
    }
   selectHouse();

}


void LoginScreen::on_pushButton_6_clicked()
{
    if(currentHouseIndex==0){
        currentHouseIndex = 2;
    }else{
        currentHouseIndex--;
    }
    selectHouse();
}


void LoginScreen::on_pushButton_3_clicked()
{
    currentHouseIndex = 0;
    ui->stackedWidget->setCurrentIndex(2);
}


void LoginScreen::selectHouseJoin(){
    switch (currentHouseIndex) {
    case 0:
        ui->label_26->setPixmap(QString::fromUtf8("/home/lucas/Desktop/Taller I/Dune2000/src/Client/resources/EBFD_Atreides_Logo.png"));
        ui->label_24->setText("Atreides");
        break;
    case 1:
        ui->label_26->setPixmap(QString::fromUtf8("/home/lucas/Desktop/Taller I/Dune2000/src/Client/resources/EBFD_Ordos_Logo.png"));
        ui->label_24->setText("Ordos");
        break;
    case 2:
        ui->label_26->setPixmap(QString::fromUtf8("/home/lucas/Desktop/Taller I/Dune2000/src/Client/resources/EBFD_Harkonnen_Logo.png"));
        ui->label_24->setText("Harkonnen");
    }

    ui->label_24->setAlignment(Qt::AlignCenter);
    ui->label_24->setStyleSheet("font-weight: bold");
}

void LoginScreen::on_pushButton_15_clicked()
{
    if(currentHouseIndex==2){
        currentHouseIndex = 0;
    }else{
        currentHouseIndex++;
    }
   selectHouseJoin();
}


void LoginScreen::on_pushButton_17_clicked()
{
    if(currentHouseIndex==0){
        currentHouseIndex = 2;
    }else{
        currentHouseIndex--;
    }
    selectHouseJoin();
}



void LoginScreen::on_pushButton_18_clicked()
{
    ui->stackedWidget->setCurrentIndex(0);
}


void LoginScreen::on_comboBox_activated(int index)
{

}


void LoginScreen::on_pushButton_19_clicked()
{
    ui->stackedWidget->setCurrentIndex(3);
}


void LoginScreen::on_pushButton_20_clicked()
{
    ui->stackedWidget->setCurrentIndex(0);
}

