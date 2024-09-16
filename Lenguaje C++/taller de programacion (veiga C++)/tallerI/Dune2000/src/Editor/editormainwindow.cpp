#include <QErrorMessage>
#include <filesystem>
#include <iostream>
#include "editormainwindow.h"
#include "./ui_editormainwindow.h"
#include "MapLoader.h"




EditorMainWindow::EditorMainWindow(std::string& name,int& x, int& y, int& mode, int& nOfPlayers,QWidget *parent)
    : QMainWindow(parent)
    , x(x)
    , y(y)
    , mode(mode)
    , name(name)
    , nOfPlayers(nOfPlayers)
    , ui(new Ui::EditorMainWindow)
{
    ui->setupUi(this);
    ui->stackedWidget->setCurrentIndex(0);
    ui->MapX->setValidator( new QIntValidator(0, 9999, this) );
    ui->MapY->setValidator( new QIntValidator(0, 9999, this) );

    MapLoader loader;
    std::string path = "../map/";
    for (const auto & entry : std::filesystem::directory_iterator(path)){
        std::string _path = entry.path();
        if (path.find("yaml")){
            Game newGame;
            loader.loadMapPreview(_path,newGame.y, newGame.x, newGame.players,newGame.name);
            games.push_back(newGame);
        }
    }
    for (int i = 0; i < (int) games.size() ; ++i) {
        QString n = QString::fromStdString(games[i].name);
        ui->comboBox->addItem(n);
    }
}

EditorMainWindow::~EditorMainWindow()
{
    delete ui;
}


void EditorMainWindow::on_new_2_clicked()
{
    ui->stackedWidget->setCurrentIndex(1);
}


void EditorMainWindow::on_back1_clicked()
{
    ui->stackedWidget->setCurrentIndex(0);
}


void EditorMainWindow::on_load_clicked()
{
    ui->stackedWidget->setCurrentIndex(2);
}


void EditorMainWindow::on_back_2_clicked()
{
    ui->stackedWidget->setCurrentIndex(0);
}


void EditorMainWindow::on_startLoad_clicked()
{
    for (int i = 0; i < (int) games.size() ; ++i) {
        if (games[i].name == ui->comboBox->currentText().toStdString()){
            x = games[i].x;
            y = games[i].y;
            name = games[i].name;
            mode = 2;
            nOfPlayers = games[i].players;
            this->close();
        }
    }
}


void EditorMainWindow::on_startnew_clicked()
{
    QString _name(ui->gameName->text());
    if (!ui->MapX->text().isEmpty() || !ui->MapX->text().isEmpty() || !_name.isEmpty() ) {
         x = ui->MapX->text().toInt();
         y = ui->MapY->text().toInt();
        name = _name.toStdString();
        mode = 1;
        nOfPlayers = ui->spinBox->value();
        this->close();
    }else{
        QErrorMessage msg;
        msg.showMessage("FILL ITEMS CORRECTLY");
        msg.exec();
    }
}

void EditorMainWindow::on_comboBox_currentIndexChanged(int index) {
    for (int i = 0; i < (int) games.size() ; ++i) {
        if (games[i].name == ui->comboBox->currentText().toStdString()){
            std::string rows = std::to_string(games[i].x);
            QString _x = QString::fromStdString(rows);
            ui->MapX_2->setText(_x);
            std::string cols = std::to_string(games[i].y);
            QString _y = QString::fromStdString(cols);
            ui->MapY_2->setText(_y);
            std::string players = std::to_string(games[i].players);
            QString n = QString::fromStdString(players);
            ui->MapY_3->setText(n);
        }
    }
}


