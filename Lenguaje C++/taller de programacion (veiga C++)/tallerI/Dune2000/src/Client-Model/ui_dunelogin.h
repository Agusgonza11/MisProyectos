/********************************************************************************
** Form generated from reading UI file 'dunelogin.ui'
**
** Created by: Qt User Interface Compiler version 5.12.8
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_DUNELOGIN_H
#define UI_DUNELOGIN_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QComboBox>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QProgressBar>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QStackedWidget>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_DuneLogin
{
public:
    QWidget *centralwidget;
    QStackedWidget *stackedWidget;
    QWidget *mainPage;
    QLabel *mainImage;
    QPushButton *newGameButton;
    QPushButton *joinGameButton;
    QWidget *newGamePage;
    QLabel *newGameImage;
    QLabel *mapLabel;
    QComboBox *maps;
    QLineEdit *playerName;
    QLabel *yourNameLabel;
    QLabel *gameNameLabel;
    QLineEdit *gameName;
    QPushButton *backNew;
    QLabel *playersNew;
    QLineEdit *nOfPlayers;
    QLabel *houseLabel;
    QLabel *house;
    QPushButton *prevHouse;
    QPushButton *nextHouse;
    QLabel *houseNameLabel;
    QPushButton *startNewGame;
    QWidget *loadingGame;
    QProgressBar *progressBar;
    QWidget *joinGamePage;
    QLabel *joinGameImage;
    QPushButton *backjoin;
    QPushButton *startJoin;
    QLineEdit *playerName_2;
    QLineEdit *nOfPlayers_2;
    QLabel *gameNameLabel_2;
    QLabel *yourNameLabel_2;
    QPushButton *nextHouseJoin;
    QLabel *houseNameLabelJoin;
    QPushButton *prevHouseJoin;
    QLabel *houseLabel_2;
    QLabel *houseJoin;
    QLabel *mapLabel_2;
    QLabel *playersNew_2;
    QLineEdit *lineEdit;
    QComboBox *selectGameBox;
    QPushButton *reloadButton;

    void setupUi(QMainWindow *DuneLogin)
    {
        if (DuneLogin->objectName().isEmpty())
            DuneLogin->setObjectName(QString::fromUtf8("DuneLogin"));
        DuneLogin->resize(747, 600);
        centralwidget = new QWidget(DuneLogin);
        centralwidget->setObjectName(QString::fromUtf8("centralwidget"));
        stackedWidget = new QStackedWidget(centralwidget);
        stackedWidget->setObjectName(QString::fromUtf8("stackedWidget"));
        stackedWidget->setGeometry(QRect(0, 0, 751, 611));
        mainPage = new QWidget();
        mainPage->setObjectName(QString::fromUtf8("mainPage"));
        mainImage = new QLabel(mainPage);
        mainImage->setObjectName(QString::fromUtf8("mainImage"));
        mainImage->setGeometry(QRect(0, 0, 761, 601));
        mainImage->setPixmap(QPixmap(QString::fromUtf8("resources/login/loginMain.jpg")));
        mainImage->setScaledContents(true);
        newGameButton = new QPushButton(mainPage);
        newGameButton->setObjectName(QString::fromUtf8("newGameButton"));
        newGameButton->setGeometry(QRect(270, 310, 191, 41));
        newGameButton->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	font: 700 11pt \"Dune Rise\";\n"
"	color: rgb(255, 255, 255);\n"
"	background-color: rgb(0, 14,77);\n"
"	border: 2px solid black\n"
"}\n"
""));
        joinGameButton = new QPushButton(mainPage);
        joinGameButton->setObjectName(QString::fromUtf8("joinGameButton"));
        joinGameButton->setGeometry(QRect(270, 390, 191, 41));
        joinGameButton->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	font: 700 11pt \"Dune Rise\";\n"
"	color: rgb(255, 255, 255);\n"
"	background-color: rgb(0, 14,77);\n"
"	border: 2px solid black\n"
"}\n"
""));
        stackedWidget->addWidget(mainPage);
        newGamePage = new QWidget();
        newGamePage->setObjectName(QString::fromUtf8("newGamePage"));
        newGameImage = new QLabel(newGamePage);
        newGameImage->setObjectName(QString::fromUtf8("newGameImage"));
        newGameImage->setGeometry(QRect(0, 0, 761, 611));
        newGameImage->setStyleSheet(QString::fromUtf8("font: 700 15pt \"Dune Rise\";"));
        newGameImage->setTextFormat(Qt::AutoText);
        newGameImage->setPixmap(QPixmap(QString::fromUtf8("resources/login/duneNew.jpg")));
        newGameImage->setScaledContents(true);
        mapLabel = new QLabel(newGamePage);
        mapLabel->setObjectName(QString::fromUtf8("mapLabel"));
        mapLabel->setGeometry(QRect(50, 230, 71, 31));
        mapLabel->setStyleSheet(QString::fromUtf8("font: 700 15pt \"Dune Rise\";\n"
""));
        mapLabel->setTextFormat(Qt::AutoText);
        mapLabel->setScaledContents(false);
        maps = new QComboBox(newGamePage);
        maps->setObjectName(QString::fromUtf8("maps"));
        maps->setGeometry(QRect(120, 230, 281, 31));
        maps->setStyleSheet(QString::fromUtf8("background-color: rgb(238, 238, 236);\n"
"font: 700 11pt \"Dune Rise\";"));
        playerName = new QLineEdit(newGamePage);
        playerName->setObjectName(QString::fromUtf8("playerName"));
        playerName->setGeometry(QRect(240, 120, 381, 31));
        playerName->setStyleSheet(QString::fromUtf8("font: 700 11pt \"Dune Rise\";"));
        yourNameLabel = new QLabel(newGamePage);
        yourNameLabel->setObjectName(QString::fromUtf8("yourNameLabel"));
        yourNameLabel->setGeometry(QRect(50, 120, 171, 31));
        yourNameLabel->setStyleSheet(QString::fromUtf8("font: 700 15pt \"Dune Rise\";"));
        gameNameLabel = new QLabel(newGamePage);
        gameNameLabel->setObjectName(QString::fromUtf8("gameNameLabel"));
        gameNameLabel->setGeometry(QRect(50, 180, 181, 21));
        gameNameLabel->setStyleSheet(QString::fromUtf8("font: 700 15pt \"Dune Rise\";"));
        gameName = new QLineEdit(newGamePage);
        gameName->setObjectName(QString::fromUtf8("gameName"));
        gameName->setGeometry(QRect(240, 170, 381, 31));
        gameName->setStyleSheet(QString::fromUtf8("font: 700 11pt \"Dune Rise\";"));
        backNew = new QPushButton(newGamePage);
        backNew->setObjectName(QString::fromUtf8("backNew"));
        backNew->setGeometry(QRect(20, 540, 131, 51));
        backNew->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	font: 700 11pt \"Dune Rise\";\n"
"	color: rgb(255, 255, 255);\n"
"	background-color: rgb(159, 90,16);\n"
"	border: 2px solid black\n"
"}\n"
""));
        playersNew = new QLabel(newGamePage);
        playersNew->setObjectName(QString::fromUtf8("playersNew"));
        playersNew->setGeometry(QRect(430, 230, 141, 31));
        playersNew->setStyleSheet(QString::fromUtf8("font: 700 15pt \"Dune Rise\";"));
        nOfPlayers = new QLineEdit(newGamePage);
        nOfPlayers->setObjectName(QString::fromUtf8("nOfPlayers"));
        nOfPlayers->setGeometry(QRect(580, 230, 41, 31));
        nOfPlayers->setStyleSheet(QString::fromUtf8("font: 700 11pt \"Dune Rise\";"));
        nOfPlayers->setReadOnly(true);
        houseLabel = new QLabel(newGamePage);
        houseLabel->setObjectName(QString::fromUtf8("houseLabel"));
        houseLabel->setGeometry(QRect(50, 310, 101, 61));
        houseLabel->setStyleSheet(QString::fromUtf8("font: 700 15pt \"Dune Rise\";"));
        house = new QLabel(newGamePage);
        house->setObjectName(QString::fromUtf8("house"));
        house->setGeometry(QRect(190, 270, 131, 131));
        house->setPixmap(QPixmap(QString::fromUtf8("resources/login/EBFD_Atreides_Logo.png")));
        house->setScaledContents(true);
        prevHouse = new QPushButton(newGamePage);
        prevHouse->setObjectName(QString::fromUtf8("prevHouse"));
        prevHouse->setGeometry(QRect(170, 390, 61, 31));
        prevHouse->setStyleSheet(QString::fromUtf8("font: 700 12pt \"Dune Rise\";"));
        nextHouse = new QPushButton(newGamePage);
        nextHouse->setObjectName(QString::fromUtf8("nextHouse"));
        nextHouse->setGeometry(QRect(280, 390, 61, 31));
        nextHouse->setStyleSheet(QString::fromUtf8("font: 700 12pt \"Dune Rise\";"));
        houseNameLabel = new QLabel(newGamePage);
        houseNameLabel->setObjectName(QString::fromUtf8("houseNameLabel"));
        houseNameLabel->setGeometry(QRect(420, 310, 151, 71));
        houseNameLabel->setStyleSheet(QString::fromUtf8("font: 700 13pt \"Dune Rise\";\n"
"color: rgb(255, 255, 255);\n"
"background-color: rgb(46, 52, 54);"));
        houseNameLabel->setAlignment(Qt::AlignCenter);
        startNewGame = new QPushButton(newGamePage);
        startNewGame->setObjectName(QString::fromUtf8("startNewGame"));
        startNewGame->setGeometry(QRect(590, 540, 131, 51));
        startNewGame->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	font: 700 11pt \"Dune Rise\";\n"
"	color: rgb(255, 255, 255);\n"
"	background-color: rgb(159, 90,16);\n"
"	border: 2px solid black\n"
"}\n"
""));
        stackedWidget->addWidget(newGamePage);
        loadingGame = new QWidget();
        loadingGame->setObjectName(QString::fromUtf8("loadingGame"));
        progressBar = new QProgressBar(loadingGame);
        progressBar->setObjectName(QString::fromUtf8("progressBar"));
        progressBar->setGeometry(QRect(200, 210, 321, 51));
        progressBar->setStyleSheet(QString::fromUtf8("font: 700 19pt \"Dune Rise\";\n"
"alternate-background-color: rgb(46, 52, 54);\n"
"background-color: rgb(255, 255, 255);\n"
""));
        progressBar->setValue(24);
        stackedWidget->addWidget(loadingGame);
        joinGamePage = new QWidget();
        joinGamePage->setObjectName(QString::fromUtf8("joinGamePage"));
        joinGameImage = new QLabel(joinGamePage);
        joinGameImage->setObjectName(QString::fromUtf8("joinGameImage"));
        joinGameImage->setGeometry(QRect(0, -4, 751, 621));
        joinGameImage->setPixmap(QPixmap(QString::fromUtf8("resources/login/JoinImage.jpg")));
        joinGameImage->setScaledContents(true);
        backjoin = new QPushButton(joinGamePage);
        backjoin->setObjectName(QString::fromUtf8("backjoin"));
        backjoin->setGeometry(QRect(20, 530, 131, 51));
        backjoin->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	font: 700 11pt \"Dune Rise\";\n"
"	color: rgb(255, 255, 255);\n"
"	background-color: rgb(117, 0,0);\n"
"	border: 2px solid black\n"
"}\n"
""));
        startJoin = new QPushButton(joinGamePage);
        startJoin->setObjectName(QString::fromUtf8("startJoin"));
        startJoin->setGeometry(QRect(600, 530, 131, 51));
        startJoin->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	font: 700 11pt \"Dune Rise\";\n"
"	color: rgb(255, 255, 255);\n"
"	background-color: rgb(117, 0,0);\n"
"	border: 2px solid black\n"
"}\n"
""));
        playerName_2 = new QLineEdit(joinGamePage);
        playerName_2->setObjectName(QString::fromUtf8("playerName_2"));
        playerName_2->setGeometry(QRect(270, 160, 381, 31));
        playerName_2->setStyleSheet(QString::fromUtf8("font: 700 11pt \"Dune Rise\";"));
        nOfPlayers_2 = new QLineEdit(joinGamePage);
        nOfPlayers_2->setObjectName(QString::fromUtf8("nOfPlayers_2"));
        nOfPlayers_2->setGeometry(QRect(600, 260, 51, 41));
        nOfPlayers_2->setStyleSheet(QString::fromUtf8("font: 700 11pt \"Dune Rise\";"));
        nOfPlayers_2->setReadOnly(true);
        gameNameLabel_2 = new QLabel(joinGamePage);
        gameNameLabel_2->setObjectName(QString::fromUtf8("gameNameLabel_2"));
        gameNameLabel_2->setGeometry(QRect(80, 220, 211, 21));
        gameNameLabel_2->setStyleSheet(QString::fromUtf8("font: 700 15pt \"Dune Rise\";\n"
"color: rgb(255, 255, 255);"));
        yourNameLabel_2 = new QLabel(joinGamePage);
        yourNameLabel_2->setObjectName(QString::fromUtf8("yourNameLabel_2"));
        yourNameLabel_2->setGeometry(QRect(80, 160, 171, 31));
        yourNameLabel_2->setStyleSheet(QString::fromUtf8("font: 700 15pt \"Dune Rise\";\n"
"color: rgb(255, 255, 255);"));
        nextHouseJoin = new QPushButton(joinGamePage);
        nextHouseJoin->setObjectName(QString::fromUtf8("nextHouseJoin"));
        nextHouseJoin->setGeometry(QRect(310, 430, 61, 31));
        nextHouseJoin->setStyleSheet(QString::fromUtf8("font: 700 12pt \"Dune Rise\";"));
        houseNameLabelJoin = new QLabel(joinGamePage);
        houseNameLabelJoin->setObjectName(QString::fromUtf8("houseNameLabelJoin"));
        houseNameLabelJoin->setGeometry(QRect(450, 350, 151, 71));
        houseNameLabelJoin->setStyleSheet(QString::fromUtf8("font: 700 13pt \"Dune Rise\";\n"
"color: rgb(255, 255, 255);\n"
"background-color: rgb(46, 52, 54);"));
        houseNameLabelJoin->setAlignment(Qt::AlignCenter);
        prevHouseJoin = new QPushButton(joinGamePage);
        prevHouseJoin->setObjectName(QString::fromUtf8("prevHouseJoin"));
        prevHouseJoin->setGeometry(QRect(200, 430, 61, 31));
        prevHouseJoin->setStyleSheet(QString::fromUtf8("font: 700 12pt \"Dune Rise\";"));
        houseLabel_2 = new QLabel(joinGamePage);
        houseLabel_2->setObjectName(QString::fromUtf8("houseLabel_2"));
        houseLabel_2->setGeometry(QRect(80, 350, 101, 61));
        houseLabel_2->setStyleSheet(QString::fromUtf8("font: 700 15pt \"Dune Rise\";\n"
"color: rgb(255, 255, 255);"));
        houseJoin = new QLabel(joinGamePage);
        houseJoin->setObjectName(QString::fromUtf8("houseJoin"));
        houseJoin->setGeometry(QRect(220, 310, 131, 131));
        houseJoin->setPixmap(QPixmap(QString::fromUtf8("resources/login/EBFD_Atreides_Logo.png")));
        houseJoin->setScaledContents(true);
        mapLabel_2 = new QLabel(joinGamePage);
        mapLabel_2->setObjectName(QString::fromUtf8("mapLabel_2"));
        mapLabel_2->setGeometry(QRect(80, 270, 71, 31));
        mapLabel_2->setStyleSheet(QString::fromUtf8("font: 700 15pt \"Dune Rise\";\n"
"color: rgb(255, 255, 255);"));
        mapLabel_2->setTextFormat(Qt::AutoText);
        mapLabel_2->setScaledContents(false);
        playersNew_2 = new QLabel(joinGamePage);
        playersNew_2->setObjectName(QString::fromUtf8("playersNew_2"));
        playersNew_2->setGeometry(QRect(460, 270, 141, 31));
        playersNew_2->setStyleSheet(QString::fromUtf8("font: 700 15pt \"Dune Rise\";\n"
"color: rgb(255, 255, 255);"));
        lineEdit = new QLineEdit(joinGamePage);
        lineEdit->setObjectName(QString::fromUtf8("lineEdit"));
        lineEdit->setGeometry(QRect(170, 270, 271, 31));
        lineEdit->setReadOnly(true);
        selectGameBox = new QComboBox(joinGamePage);
        selectGameBox->setObjectName(QString::fromUtf8("selectGameBox"));
        selectGameBox->setGeometry(QRect(300, 210, 351, 31));
        reloadButton = new QPushButton(joinGamePage);
        reloadButton->setObjectName(QString::fromUtf8("reloadButton"));
        reloadButton->setGeometry(QRect(660, 210, 31, 31));
        stackedWidget->addWidget(joinGamePage);
        DuneLogin->setCentralWidget(centralwidget);

        retranslateUi(DuneLogin);

        stackedWidget->setCurrentIndex(2);


        QMetaObject::connectSlotsByName(DuneLogin);
    } // setupUi

    void retranslateUi(QMainWindow *DuneLogin)
    {
        DuneLogin->setWindowTitle(QApplication::translate("DuneLogin", "DuneLogin", nullptr));
        mainImage->setText(QString());
        newGameButton->setText(QApplication::translate("DuneLogin", "New Game", nullptr));
        joinGameButton->setText(QApplication::translate("DuneLogin", "Join game", nullptr));
        newGameImage->setText(QString());
        mapLabel->setText(QApplication::translate("DuneLogin", "Map", nullptr));
        yourNameLabel->setText(QApplication::translate("DuneLogin", "Your Name", nullptr));
        gameNameLabel->setText(QApplication::translate("DuneLogin", "Game Name", nullptr));
        backNew->setText(QApplication::translate("DuneLogin", "Back", nullptr));
        playersNew->setText(QApplication::translate("DuneLogin", "Players", nullptr));
        houseLabel->setText(QApplication::translate("DuneLogin", "House", nullptr));
        house->setText(QString());
        prevHouse->setText(QApplication::translate("DuneLogin", "<", nullptr));
        nextHouse->setText(QApplication::translate("DuneLogin", ">", nullptr));
        houseNameLabel->setText(QApplication::translate("DuneLogin", "Atreides", nullptr));
        startNewGame->setText(QApplication::translate("DuneLogin", "Start", nullptr));
        joinGameImage->setText(QString());
        backjoin->setText(QApplication::translate("DuneLogin", "Back", nullptr));
        startJoin->setText(QApplication::translate("DuneLogin", "Start", nullptr));
        gameNameLabel_2->setText(QApplication::translate("DuneLogin", "Select Game", nullptr));
        yourNameLabel_2->setText(QApplication::translate("DuneLogin", "Your Name", nullptr));
        nextHouseJoin->setText(QApplication::translate("DuneLogin", ">", nullptr));
        houseNameLabelJoin->setText(QApplication::translate("DuneLogin", "Atreides", nullptr));
        prevHouseJoin->setText(QApplication::translate("DuneLogin", "<", nullptr));
        houseLabel_2->setText(QApplication::translate("DuneLogin", "House", nullptr));
        houseJoin->setText(QString());
        mapLabel_2->setText(QApplication::translate("DuneLogin", "Map", nullptr));
        playersNew_2->setText(QApplication::translate("DuneLogin", "Players", nullptr));
        reloadButton->setText(QApplication::translate("DuneLogin", "\342\206\272", nullptr));
    } // retranslateUi

};

namespace Ui {
    class DuneLogin: public Ui_DuneLogin {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_DUNELOGIN_H
