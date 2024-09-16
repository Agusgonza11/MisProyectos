#include "firstwindow.h"
#include "./ui_firstwindow.h"
#include <QErrorMessage>

FIrstWindow::FIrstWindow(std::string& host, std::string& port, QWidget *parent)
        : QMainWindow(parent)
        ,host(host)
        ,port(port)
        , ui(new Ui::FIrstWindow)
        , playing(true)
{
    ui->setupUi(this);
    this->music = new QMediaPlayer(this);
    music->setMedia(QUrl::fromLocalFile("/home/lucas/Desktop/Taller I/Dune2000/src/Client/resources/Dune 2000 - Attack on Arrakis.mp3"));
    music->setVolume(50);
    music->play();
    ui->lineEdit->setStyleSheet("QLineEdit {background-color: white;}");
    ui->lineEdit_2->setStyleSheet("QLineEdit {background-color: white;}");
}

FIrstWindow::~FIrstWindow()
{
    delete ui;
}


void FIrstWindow::on_FIrstWindow_iconSizeChanged(const QSize &iconSize)
{

}


void FIrstWindow::on_checkBox_stateChanged(int arg1)
{
    if(arg1){
        music->pause();
        playing = false;
    }else{
        music->play();
        playing = true;
    }
}


void FIrstWindow::on_pushButton_clicked()
{
    QString first(ui->lineEdit->text());
    QString second(ui->lineEdit_2->text());
    if (first.isEmpty() || second.isEmpty() ){
        QErrorMessage msg;
        msg.showMessage("FILL HOST AND PORT");
        msg.exec();
    }else{
        host = first.toStdString();
        port = second.toStdString();
        music->pause();
        this->close();
    }
}

