/********************************************************************************
** Form generated from reading UI file 'editormainwindow.ui'
**
** Created by: Qt User Interface Compiler version 5.12.8
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_EDITORMAINWINDOW_H
#define UI_EDITORMAINWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QComboBox>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QSpinBox>
#include <QtWidgets/QStackedWidget>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_EditorMainWindow
{
public:
    QWidget *centralwidget;
    QStackedWidget *stackedWidget;
    QWidget *page;
    QLabel *label;
    QPushButton *new_2;
    QPushButton *load;
    QWidget *page_2;
    QPushButton *back1;
    QLabel *label_2;
    QLineEdit *gameName;
    QLabel *label_3;
    QLabel *label_4;
    QSpinBox *spinBox;
    QPushButton *startnew;
    QLabel *label_5;
    QLineEdit *MapX;
    QLineEdit *MapY;
    QLabel *label_6;
    QWidget *page_3;
    QPushButton *back_2;
    QLabel *label_7;
    QPushButton *startLoad;
    QComboBox *comboBox;
    QLabel *label_8;
    QLineEdit *MapX_2;
    QLineEdit *MapY_2;
    QLabel *label_9;
    QLabel *label_10;
    QLabel *label_11;
    QLineEdit *MapY_3;

    void setupUi(QMainWindow *EditorMainWindow)
    {
        if (EditorMainWindow->objectName().isEmpty())
            EditorMainWindow->setObjectName(QString::fromUtf8("EditorMainWindow"));
        EditorMainWindow->resize(491, 650);
        centralwidget = new QWidget(EditorMainWindow);
        centralwidget->setObjectName(QString::fromUtf8("centralwidget"));
        stackedWidget = new QStackedWidget(centralwidget);
        stackedWidget->setObjectName(QString::fromUtf8("stackedWidget"));
        stackedWidget->setGeometry(QRect(0, 0, 491, 651));
        page = new QWidget();
        page->setObjectName(QString::fromUtf8("page"));
        label = new QLabel(page);
        label->setObjectName(QString::fromUtf8("label"));
        label->setGeometry(QRect(0, 0, 491, 651));
        label->setPixmap(QPixmap(QString::fromUtf8("../Desktop/EditorMain.jpg")));
        label->setScaledContents(true);
        new_2 = new QPushButton(page);
        new_2->setObjectName(QString::fromUtf8("new_2"));
        new_2->setGeometry(QRect(170, 320, 151, 41));
        new_2->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	font: 700 11pt \"Dune Rise\";\n"
"	color: rgb(255, 255, 255);\n"
"	background-color: rgb(96, 55, 5);\n"
"	border: 2px solid white\n"
"}\n"
""));
        load = new QPushButton(page);
        load->setObjectName(QString::fromUtf8("load"));
        load->setGeometry(QRect(170, 390, 151, 41));
        load->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	font: 700 11pt \"Dune Rise\";\n"
"	color: rgb(255, 255, 255);\n"
"	background-color: rgb(96, 55, 5);\n"
"	border: 2px solid white\n"
"}\n"
""));
        stackedWidget->addWidget(page);
        page_2 = new QWidget();
        page_2->setObjectName(QString::fromUtf8("page_2"));
        back1 = new QPushButton(page_2);
        back1->setObjectName(QString::fromUtf8("back1"));
        back1->setGeometry(QRect(20, 590, 121, 41));
        back1->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	font: 700 11pt \"Dune Rise\";\n"
"	color: rgb(255, 255, 255);\n"
"	background-color: rgb(96, 55, 5);\n"
"	border: 2px solid white\n"
"}\n"
""));
        label_2 = new QLabel(page_2);
        label_2->setObjectName(QString::fromUtf8("label_2"));
        label_2->setGeometry(QRect(-20, -20, 531, 851));
        label_2->setPixmap(QPixmap(QString::fromUtf8("../Desktop/editornew.jpg")));
        label_2->setScaledContents(true);
        gameName = new QLineEdit(page_2);
        gameName->setObjectName(QString::fromUtf8("gameName"));
        gameName->setGeometry(QRect(170, 90, 291, 31));
        gameName->setStyleSheet(QString::fromUtf8("font: 700 11pt \"Dune Rise\";"));
        label_3 = new QLabel(page_2);
        label_3->setObjectName(QString::fromUtf8("label_3"));
        label_3->setGeometry(QRect(60, 90, 91, 31));
        label_3->setStyleSheet(QString::fromUtf8("font: 700 16pt \"Dune Rise\";\n"
"background-color: rgb(46, 52, 54);\n"
"color: rgb(255, 255, 255);"));
        label_3->setScaledContents(false);
        label_4 = new QLabel(page_2);
        label_4->setObjectName(QString::fromUtf8("label_4"));
        label_4->setGeometry(QRect(60, 150, 341, 31));
        label_4->setStyleSheet(QString::fromUtf8("font: 700 16pt \"Dune Rise\";\n"
"color: rgb(238, 238, 236);\n"
"background-color: rgb(46, 52, 54);"));
        spinBox = new QSpinBox(page_2);
        spinBox->setObjectName(QString::fromUtf8("spinBox"));
        spinBox->setGeometry(QRect(410, 150, 51, 31));
        spinBox->setStyleSheet(QString::fromUtf8("font: 700 11pt \"Dune Rise\";"));
        spinBox->setMinimum(1);
        spinBox->setMaximum(5);
        startnew = new QPushButton(page_2);
        startnew->setObjectName(QString::fromUtf8("startnew"));
        startnew->setGeometry(QRect(350, 590, 121, 41));
        startnew->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	font: 700 11pt \"Dune Rise\";\n"
"	color: rgb(255, 255, 255);\n"
"	background-color: rgb(96, 55, 5);\n"
"	border: 2px solid white\n"
"}\n"
""));
        label_5 = new QLabel(page_2);
        label_5->setObjectName(QString::fromUtf8("label_5"));
        label_5->setGeometry(QRect(60, 210, 151, 31));
        label_5->setStyleSheet(QString::fromUtf8("font: 700 16pt \"Dune Rise\";\n"
"background-color: rgb(46, 52, 54);\n"
"color: rgb(255, 255, 255);"));
        label_5->setScaledContents(false);
        MapX = new QLineEdit(page_2);
        MapX->setObjectName(QString::fromUtf8("MapX"));
        MapX->setGeometry(QRect(240, 210, 81, 31));
        MapX->setAutoFillBackground(false);
        MapX->setStyleSheet(QString::fromUtf8("font: 700 11pt \"Dune Rise\";"));
        MapY = new QLineEdit(page_2);
        MapY->setObjectName(QString::fromUtf8("MapY"));
        MapY->setGeometry(QRect(380, 210, 81, 31));
        MapY->setStyleSheet(QString::fromUtf8("font: 700 11pt \"Dune Rise\";"));
        label_6 = new QLabel(page_2);
        label_6->setObjectName(QString::fromUtf8("label_6"));
        label_6->setGeometry(QRect(340, 210, 21, 31));
        label_6->setStyleSheet(QString::fromUtf8("font: 700 16pt \"Dune Rise\";\n"
"color: rgb(238, 238, 236);"));
        stackedWidget->addWidget(page_2);
        label_2->raise();
        back1->raise();
        gameName->raise();
        label_3->raise();
        label_4->raise();
        spinBox->raise();
        startnew->raise();
        label_5->raise();
        MapX->raise();
        MapY->raise();
        label_6->raise();
        page_3 = new QWidget();
        page_3->setObjectName(QString::fromUtf8("page_3"));
        back_2 = new QPushButton(page_3);
        back_2->setObjectName(QString::fromUtf8("back_2"));
        back_2->setGeometry(QRect(20, 590, 121, 41));
        back_2->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	font: 700 11pt \"Dune Rise\";\n"
"	color: rgb(255, 255, 255);\n"
"	background-color: rgb(96, 55, 5);\n"
"	border: 2px solid white\n"
"}\n"
""));
        label_7 = new QLabel(page_3);
        label_7->setObjectName(QString::fromUtf8("label_7"));
        label_7->setGeometry(QRect(-10, -20, 561, 1261));
        label_7->setPixmap(QPixmap(QString::fromUtf8("../Desktop/load.jpg")));
        label_7->setScaledContents(true);
        startLoad = new QPushButton(page_3);
        startLoad->setObjectName(QString::fromUtf8("startLoad"));
        startLoad->setGeometry(QRect(350, 590, 121, 41));
        startLoad->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	font: 700 11pt \"Dune Rise\";\n"
"	color: rgb(255, 255, 255);\n"
"	background-color: rgb(96, 55, 5);\n"
"	border: 2px solid white\n"
"}\n"
""));
        comboBox = new QComboBox(page_3);
        comboBox->setObjectName(QString::fromUtf8("comboBox"));
        comboBox->setGeometry(QRect(100, 90, 301, 31));
        comboBox->setStyleSheet(QString::fromUtf8("background-color: rgb(175, 151, 80);\n"
"border-color: rgb(0, 0, 0);\n"
"color: rgb(0, 0, 0);"));
        label_8 = new QLabel(page_3);
        label_8->setObjectName(QString::fromUtf8("label_8"));
        label_8->setGeometry(QRect(120, 10, 271, 81));
        label_8->setStyleSheet(QString::fromUtf8("color: rgb(255, 255, 255);\n"
"font: 700 20pt \"Dune Rise\";"));
        MapX_2 = new QLineEdit(page_3);
        MapX_2->setObjectName(QString::fromUtf8("MapX_2"));
        MapX_2->setGeometry(QRect(220, 190, 81, 31));
        MapX_2->setAutoFillBackground(false);
        MapX_2->setStyleSheet(QString::fromUtf8("font: 700 11pt \"Dune Rise\";"));
        MapX_2->setReadOnly(true);
        MapY_2 = new QLineEdit(page_3);
        MapY_2->setObjectName(QString::fromUtf8("MapY_2"));
        MapY_2->setGeometry(QRect(360, 190, 81, 31));
        MapY_2->setStyleSheet(QString::fromUtf8("font: 700 11pt \"Dune Rise\";"));
        MapY_2->setReadOnly(true);
        label_9 = new QLabel(page_3);
        label_9->setObjectName(QString::fromUtf8("label_9"));
        label_9->setGeometry(QRect(320, 190, 21, 31));
        label_9->setStyleSheet(QString::fromUtf8("font: 700 16pt \"Dune Rise\";\n"
"color: rgb(238, 238, 236);"));
        label_10 = new QLabel(page_3);
        label_10->setObjectName(QString::fromUtf8("label_10"));
        label_10->setGeometry(QRect(40, 190, 151, 31));
        label_10->setStyleSheet(QString::fromUtf8("font: 700 16pt \"Dune Rise\";\n"
"background-color: rgb(46, 52, 54);\n"
"color: rgb(255, 255, 255);"));
        label_10->setScaledContents(false);
        label_11 = new QLabel(page_3);
        label_11->setObjectName(QString::fromUtf8("label_11"));
        label_11->setGeometry(QRect(40, 250, 341, 31));
        label_11->setStyleSheet(QString::fromUtf8("font: 700 16pt \"Dune Rise\";\n"
"color: rgb(238, 238, 236);\n"
"background-color: rgb(46, 52, 54);"));
        MapY_3 = new QLineEdit(page_3);
        MapY_3->setObjectName(QString::fromUtf8("MapY_3"));
        MapY_3->setGeometry(QRect(390, 250, 51, 31));
        MapY_3->setStyleSheet(QString::fromUtf8("font: 700 11pt \"Dune Rise\";"));
        MapY_3->setReadOnly(true);
        stackedWidget->addWidget(page_3);
        label_7->raise();
        back_2->raise();
        startLoad->raise();
        comboBox->raise();
        label_8->raise();
        MapX_2->raise();
        MapY_2->raise();
        label_9->raise();
        label_10->raise();
        label_11->raise();
        MapY_3->raise();
        EditorMainWindow->setCentralWidget(centralwidget);

        retranslateUi(EditorMainWindow);

        stackedWidget->setCurrentIndex(1);


        QMetaObject::connectSlotsByName(EditorMainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *EditorMainWindow)
    {
        EditorMainWindow->setWindowTitle(QApplication::translate("EditorMainWindow", "EditorMainWindow", nullptr));
        label->setText(QString());
        new_2->setText(QApplication::translate("EditorMainWindow", "New", nullptr));
        load->setText(QApplication::translate("EditorMainWindow", "Load", nullptr));
        back1->setText(QApplication::translate("EditorMainWindow", "Back", nullptr));
        label_2->setText(QString());
        label_3->setText(QApplication::translate("EditorMainWindow", "NAME", nullptr));
        label_4->setText(QApplication::translate("EditorMainWindow", "NUMBER OF PLAYERS", nullptr));
        startnew->setText(QApplication::translate("EditorMainWindow", "START", nullptr));
        label_5->setText(QApplication::translate("EditorMainWindow", "MAP SIZE", nullptr));
        label_6->setText(QApplication::translate("EditorMainWindow", "x", nullptr));
        back_2->setText(QApplication::translate("EditorMainWindow", "Back", nullptr));
        label_7->setText(QString());
        startLoad->setText(QApplication::translate("EditorMainWindow", "START", nullptr));
        label_8->setText(QApplication::translate("EditorMainWindow", "SELECT MAP", nullptr));
        label_9->setText(QApplication::translate("EditorMainWindow", "x", nullptr));
        label_10->setText(QApplication::translate("EditorMainWindow", "MAP SIZE", nullptr));
        label_11->setText(QApplication::translate("EditorMainWindow", "NUMBER OF PLAYERS", nullptr));
    } // retranslateUi

};

namespace Ui {
    class EditorMainWindow: public Ui_EditorMainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_EDITORMAINWINDOW_H
