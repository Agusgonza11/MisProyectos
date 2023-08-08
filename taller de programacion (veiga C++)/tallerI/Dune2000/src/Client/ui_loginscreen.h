/********************************************************************************
** Form generated from reading UI file 'loginscreen.ui'
**
** Created by: Qt User Interface Compiler version 5.12.8
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_LOGINSCREEN_H
#define UI_LOGINSCREEN_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QComboBox>
#include <QtWidgets/QFrame>
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QSpinBox>
#include <QtWidgets/QStackedWidget>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_LoginScreen
{
public:
    QWidget *centralwidget;
    QStackedWidget *stackedWidget;
    QWidget *page;
    QFrame *frame;
    QWidget *verticalLayoutWidget;
    QVBoxLayout *verticalLayout;
    QPushButton *pushButton_19;
    QPushButton *pushButton;
    QPushButton *pushButton_2;
    QPushButton *pushButton_3;
    QLabel *label;
    QWidget *page_2;
    QLabel *label_2;
    QPushButton *pushButton_4;
    QPushButton *pushButton_5;
    QWidget *verticalLayoutWidget_2;
    QVBoxLayout *verticalLayout_2;
    QLabel *label_4;
    QLineEdit *lineEdit;
    QLabel *label_5;
    QLineEdit *lineEdit_2;
    QLabel *label_6;
    QLineEdit *lineEdit_3;
    QHBoxLayout *horizontalLayout;
    QLabel *label_3;
    QSpinBox *spinBox;
    QLabel *label_7;
    QLabel *label_8;
    QLabel *label_9;
    QPushButton *pushButton_6;
    QPushButton *pushButton_7;
    QWidget *page_3;
    QWidget *verticalLayoutWidget_5;
    QVBoxLayout *verticalLayout_5;
    QLabel *label_19;
    QComboBox *comboBox;
    QLabel *label_20;
    QLineEdit *lineEdit_8;
    QLabel *label_21;
    QLineEdit *lineEdit_9;
    QLabel *label_23;
    QLabel *label_24;
    QPushButton *pushButton_15;
    QPushButton *pushButton_16;
    QLabel *label_25;
    QPushButton *pushButton_17;
    QPushButton *pushButton_18;
    QLabel *label_26;
    QWidget *page_7;
    QLabel *label_22;
    QPushButton *pushButton_20;
    QPushButton *pushButton_21;
    QWidget *verticalLayoutWidget_6;
    QVBoxLayout *verticalLayout_6;
    QLabel *label_27;
    QLineEdit *lineEdit_7;
    QLabel *label_28;
    QLineEdit *lineEdit_10;
    QLabel *label_29;
    QLineEdit *lineEdit_11;

    void setupUi(QMainWindow *LoginScreen)
    {
        if (LoginScreen->objectName().isEmpty())
            LoginScreen->setObjectName(QString::fromUtf8("LoginScreen"));
        LoginScreen->resize(590, 595);
        centralwidget = new QWidget(LoginScreen);
        centralwidget->setObjectName(QString::fromUtf8("centralwidget"));
        stackedWidget = new QStackedWidget(centralwidget);
        stackedWidget->setObjectName(QString::fromUtf8("stackedWidget"));
        stackedWidget->setGeometry(QRect(-10, -30, 681, 651));
        page = new QWidget();
        page->setObjectName(QString::fromUtf8("page"));
        frame = new QFrame(page);
        frame->setObjectName(QString::fromUtf8("frame"));
        frame->setGeometry(QRect(150, 340, 311, 221));
        frame->setStyleSheet(QString::fromUtf8("QFrame  {\n"
"	\n"
"	background-color: rgb(66, 33, 2);\n"
"	border: 9px solid white;\n"
"}"));
        frame->setFrameShape(QFrame::StyledPanel);
        frame->setFrameShadow(QFrame::Raised);
        verticalLayoutWidget = new QWidget(frame);
        verticalLayoutWidget->setObjectName(QString::fromUtf8("verticalLayoutWidget"));
        verticalLayoutWidget->setGeometry(QRect(40, 40, 241, 151));
        verticalLayout = new QVBoxLayout(verticalLayoutWidget);
        verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
        verticalLayout->setContentsMargins(0, 0, 0, 0);
        pushButton_19 = new QPushButton(verticalLayoutWidget);
        pushButton_19->setObjectName(QString::fromUtf8("pushButton_19"));
        pushButton_19->setEnabled(true);
        pushButton_19->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	background-color: rgb(237, 212, 0);\n"
"	border: 2px solid white\n"
"}\n"
""));
        pushButton_19->setAutoDefault(false);
        pushButton_19->setFlat(false);

        verticalLayout->addWidget(pushButton_19);

        pushButton = new QPushButton(verticalLayoutWidget);
        pushButton->setObjectName(QString::fromUtf8("pushButton"));
        pushButton->setEnabled(true);
        pushButton->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	background-color: rgb(237, 212, 0);\n"
"	border: 2px solid white\n"
"}\n"
""));
        pushButton->setAutoDefault(false);
        pushButton->setFlat(false);

        verticalLayout->addWidget(pushButton);

        pushButton_2 = new QPushButton(verticalLayoutWidget);
        pushButton_2->setObjectName(QString::fromUtf8("pushButton_2"));
        pushButton_2->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	background-color: rgb(237, 212, 0);\n"
"	border: 2px solid white\n"
"}"));

        verticalLayout->addWidget(pushButton_2);

        pushButton_3 = new QPushButton(verticalLayoutWidget);
        pushButton_3->setObjectName(QString::fromUtf8("pushButton_3"));
        pushButton_3->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	background-color: rgb(237, 212, 0);\n"
"	border: 2px solid white\n"
"}"));

        verticalLayout->addWidget(pushButton_3);

        label = new QLabel(page);
        label->setObjectName(QString::fromUtf8("label"));
        label->setGeometry(QRect(10, 30, 601, 601));
        label->setPixmap(QPixmap(QString::fromUtf8("/home/lucas/Desktop/Taller I/Dune2000/src/Client/resources/VG-dune-2000-A.jpg")));
        label->setScaledContents(true);
        stackedWidget->addWidget(page);
        label->raise();
        frame->raise();
        page_2 = new QWidget();
        page_2->setObjectName(QString::fromUtf8("page_2"));
        label_2 = new QLabel(page_2);
        label_2->setObjectName(QString::fromUtf8("label_2"));
        label_2->setGeometry(QRect(0, 30, 601, 601));
        label_2->setPixmap(QPixmap(QString::fromUtf8("/home/lucas/Desktop/Taller I/Dune2000/src/Client/resources/dune-pixart.png")));
        label_2->setScaledContents(true);
        pushButton_4 = new QPushButton(page_2);
        pushButton_4->setObjectName(QString::fromUtf8("pushButton_4"));
        pushButton_4->setGeometry(QRect(160, 520, 91, 61));
        pushButton_4->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	background-color: rgb(211, 215, 207);\n"
"	border: 2px solid black\n"
"}"));
        pushButton_4->setAutoDefault(false);
        pushButton_4->setFlat(false);
        pushButton_5 = new QPushButton(page_2);
        pushButton_5->setObjectName(QString::fromUtf8("pushButton_5"));
        pushButton_5->setGeometry(QRect(350, 520, 91, 61));
        pushButton_5->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	\n"
"	background-color: rgb(237, 212, 0);\n"
"	border: 2px solid black\n"
"}"));
        verticalLayoutWidget_2 = new QWidget(page_2);
        verticalLayoutWidget_2->setObjectName(QString::fromUtf8("verticalLayoutWidget_2"));
        verticalLayoutWidget_2->setGeometry(QRect(140, 60, 321, 251));
        verticalLayout_2 = new QVBoxLayout(verticalLayoutWidget_2);
        verticalLayout_2->setObjectName(QString::fromUtf8("verticalLayout_2"));
        verticalLayout_2->setContentsMargins(0, 0, 0, 0);
        label_4 = new QLabel(verticalLayoutWidget_2);
        label_4->setObjectName(QString::fromUtf8("label_4"));
        label_4->setEnabled(true);
        label_4->setAutoFillBackground(false);

        verticalLayout_2->addWidget(label_4);

        lineEdit = new QLineEdit(verticalLayoutWidget_2);
        lineEdit->setObjectName(QString::fromUtf8("lineEdit"));

        verticalLayout_2->addWidget(lineEdit);

        label_5 = new QLabel(verticalLayoutWidget_2);
        label_5->setObjectName(QString::fromUtf8("label_5"));

        verticalLayout_2->addWidget(label_5);

        lineEdit_2 = new QLineEdit(verticalLayoutWidget_2);
        lineEdit_2->setObjectName(QString::fromUtf8("lineEdit_2"));

        verticalLayout_2->addWidget(lineEdit_2);

        label_6 = new QLabel(verticalLayoutWidget_2);
        label_6->setObjectName(QString::fromUtf8("label_6"));

        verticalLayout_2->addWidget(label_6);

        lineEdit_3 = new QLineEdit(verticalLayoutWidget_2);
        lineEdit_3->setObjectName(QString::fromUtf8("lineEdit_3"));
        lineEdit_3->setEchoMode(QLineEdit::Password);

        verticalLayout_2->addWidget(lineEdit_3);

        horizontalLayout = new QHBoxLayout();
        horizontalLayout->setObjectName(QString::fromUtf8("horizontalLayout"));
        label_3 = new QLabel(verticalLayoutWidget_2);
        label_3->setObjectName(QString::fromUtf8("label_3"));
        label_3->setAutoFillBackground(true);
        label_3->setStyleSheet(QString::fromUtf8("QLabel{\n"
"		\n"
"	color: rgb(238, 238, 236);\n"
"}"));

        horizontalLayout->addWidget(label_3);

        spinBox = new QSpinBox(verticalLayoutWidget_2);
        spinBox->setObjectName(QString::fromUtf8("spinBox"));
        spinBox->setMaximum(6);

        horizontalLayout->addWidget(spinBox);


        verticalLayout_2->addLayout(horizontalLayout);

        label_7 = new QLabel(page_2);
        label_7->setObjectName(QString::fromUtf8("label_7"));
        label_7->setGeometry(QRect(140, 320, 151, 41));
        label_7->setAutoFillBackground(true);
        label_8 = new QLabel(page_2);
        label_8->setObjectName(QString::fromUtf8("label_8"));
        label_8->setGeometry(QRect(330, 310, 111, 101));
        label_8->setStyleSheet(QString::fromUtf8("QLabel{\n"
"	background-color: rgb(97, 97, 97);\n"
"	background: transparent;\n"
"}"));
        label_8->setPixmap(QPixmap(QString::fromUtf8("/home/lucas/Desktop/Taller I/Dune2000/src/Client/resources/EBFD_Atreides_Logo.png")));
        label_8->setScaledContents(true);
        label_9 = new QLabel(page_2);
        label_9->setObjectName(QString::fromUtf8("label_9"));
        label_9->setGeometry(QRect(340, 410, 81, 31));
        label_9->setAutoFillBackground(true);
        pushButton_6 = new QPushButton(page_2);
        pushButton_6->setObjectName(QString::fromUtf8("pushButton_6"));
        pushButton_6->setGeometry(QRect(300, 410, 31, 31));
        pushButton_7 = new QPushButton(page_2);
        pushButton_7->setObjectName(QString::fromUtf8("pushButton_7"));
        pushButton_7->setGeometry(QRect(430, 410, 31, 31));
        stackedWidget->addWidget(page_2);
        page_3 = new QWidget();
        page_3->setObjectName(QString::fromUtf8("page_3"));
        verticalLayoutWidget_5 = new QWidget(page_3);
        verticalLayoutWidget_5->setObjectName(QString::fromUtf8("verticalLayoutWidget_5"));
        verticalLayoutWidget_5->setGeometry(QRect(140, 60, 321, 251));
        verticalLayout_5 = new QVBoxLayout(verticalLayoutWidget_5);
        verticalLayout_5->setObjectName(QString::fromUtf8("verticalLayout_5"));
        verticalLayout_5->setContentsMargins(0, 0, 0, 0);
        label_19 = new QLabel(verticalLayoutWidget_5);
        label_19->setObjectName(QString::fromUtf8("label_19"));
        label_19->setEnabled(true);
        label_19->setAutoFillBackground(false);

        verticalLayout_5->addWidget(label_19);

        comboBox = new QComboBox(verticalLayoutWidget_5);
        comboBox->addItem(QString());
        comboBox->addItem(QString());
        comboBox->setObjectName(QString::fromUtf8("comboBox"));

        verticalLayout_5->addWidget(comboBox);

        label_20 = new QLabel(verticalLayoutWidget_5);
        label_20->setObjectName(QString::fromUtf8("label_20"));

        verticalLayout_5->addWidget(label_20);

        lineEdit_8 = new QLineEdit(verticalLayoutWidget_5);
        lineEdit_8->setObjectName(QString::fromUtf8("lineEdit_8"));

        verticalLayout_5->addWidget(lineEdit_8);

        label_21 = new QLabel(verticalLayoutWidget_5);
        label_21->setObjectName(QString::fromUtf8("label_21"));

        verticalLayout_5->addWidget(label_21);

        lineEdit_9 = new QLineEdit(verticalLayoutWidget_5);
        lineEdit_9->setObjectName(QString::fromUtf8("lineEdit_9"));
        lineEdit_9->setEchoMode(QLineEdit::Password);

        verticalLayout_5->addWidget(lineEdit_9);

        label_23 = new QLabel(page_3);
        label_23->setObjectName(QString::fromUtf8("label_23"));
        label_23->setGeometry(QRect(0, 30, 601, 601));
        label_23->setPixmap(QPixmap(QString::fromUtf8("/home/lucas/Desktop/Taller I/Dune2000/src/Client/resources/dune-pixart.png")));
        label_23->setScaledContents(true);
        label_24 = new QLabel(page_3);
        label_24->setObjectName(QString::fromUtf8("label_24"));
        label_24->setGeometry(QRect(340, 410, 81, 31));
        label_24->setAutoFillBackground(true);
        pushButton_15 = new QPushButton(page_3);
        pushButton_15->setObjectName(QString::fromUtf8("pushButton_15"));
        pushButton_15->setGeometry(QRect(430, 410, 31, 31));
        pushButton_16 = new QPushButton(page_3);
        pushButton_16->setObjectName(QString::fromUtf8("pushButton_16"));
        pushButton_16->setGeometry(QRect(350, 520, 91, 61));
        pushButton_16->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	\n"
"	background-color: rgb(237, 212, 0);\n"
"	border: 2px solid black\n"
"}"));
        label_25 = new QLabel(page_3);
        label_25->setObjectName(QString::fromUtf8("label_25"));
        label_25->setGeometry(QRect(140, 320, 151, 41));
        label_25->setAutoFillBackground(true);
        pushButton_17 = new QPushButton(page_3);
        pushButton_17->setObjectName(QString::fromUtf8("pushButton_17"));
        pushButton_17->setGeometry(QRect(300, 410, 31, 31));
        pushButton_18 = new QPushButton(page_3);
        pushButton_18->setObjectName(QString::fromUtf8("pushButton_18"));
        pushButton_18->setGeometry(QRect(160, 520, 91, 61));
        pushButton_18->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	background-color: rgb(211, 215, 207);\n"
"	border: 2px solid black\n"
"}"));
        pushButton_18->setAutoDefault(false);
        pushButton_18->setFlat(false);
        label_26 = new QLabel(page_3);
        label_26->setObjectName(QString::fromUtf8("label_26"));
        label_26->setGeometry(QRect(330, 310, 111, 101));
        label_26->setStyleSheet(QString::fromUtf8("QLabel{\n"
"	background-color: rgb(97, 97, 97);\n"
"	background: transparent;\n"
"}"));
        label_26->setPixmap(QPixmap(QString::fromUtf8("/home/lucas/Desktop/Taller I/Dune2000/src/Client/resources/EBFD_Atreides_Logo.png")));
        label_26->setScaledContents(true);
        stackedWidget->addWidget(page_3);
        label_23->raise();
        verticalLayoutWidget_5->raise();
        label_24->raise();
        pushButton_15->raise();
        pushButton_16->raise();
        label_25->raise();
        pushButton_17->raise();
        pushButton_18->raise();
        label_26->raise();
        page_7 = new QWidget();
        page_7->setObjectName(QString::fromUtf8("page_7"));
        label_22 = new QLabel(page_7);
        label_22->setObjectName(QString::fromUtf8("label_22"));
        label_22->setGeometry(QRect(0, 30, 601, 601));
        label_22->setPixmap(QPixmap(QString::fromUtf8("/home/lucas/Desktop/Taller I/Dune2000/src/Client/resources/dune-pixart.png")));
        label_22->setScaledContents(true);
        pushButton_20 = new QPushButton(page_7);
        pushButton_20->setObjectName(QString::fromUtf8("pushButton_20"));
        pushButton_20->setGeometry(QRect(160, 520, 91, 61));
        pushButton_20->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	background-color: rgb(211, 215, 207);\n"
"	border: 2px solid black\n"
"}"));
        pushButton_20->setAutoDefault(false);
        pushButton_20->setFlat(false);
        pushButton_21 = new QPushButton(page_7);
        pushButton_21->setObjectName(QString::fromUtf8("pushButton_21"));
        pushButton_21->setGeometry(QRect(350, 520, 91, 61));
        pushButton_21->setMouseTracking(false);
        pushButton_21->setStyleSheet(QString::fromUtf8("QPushButton {\n"
"	\n"
"	background-color: rgb(237, 212, 0);\n"
"	border: 2px solid black\n"
"}"));
        verticalLayoutWidget_6 = new QWidget(page_7);
        verticalLayoutWidget_6->setObjectName(QString::fromUtf8("verticalLayoutWidget_6"));
        verticalLayoutWidget_6->setGeometry(QRect(160, 90, 281, 161));
        verticalLayout_6 = new QVBoxLayout(verticalLayoutWidget_6);
        verticalLayout_6->setObjectName(QString::fromUtf8("verticalLayout_6"));
        verticalLayout_6->setContentsMargins(0, 0, 0, 0);
        label_27 = new QLabel(verticalLayoutWidget_6);
        label_27->setObjectName(QString::fromUtf8("label_27"));

        verticalLayout_6->addWidget(label_27);

        lineEdit_7 = new QLineEdit(verticalLayoutWidget_6);
        lineEdit_7->setObjectName(QString::fromUtf8("lineEdit_7"));

        verticalLayout_6->addWidget(lineEdit_7);

        label_28 = new QLabel(verticalLayoutWidget_6);
        label_28->setObjectName(QString::fromUtf8("label_28"));

        verticalLayout_6->addWidget(label_28);

        lineEdit_10 = new QLineEdit(verticalLayoutWidget_6);
        lineEdit_10->setObjectName(QString::fromUtf8("lineEdit_10"));
        lineEdit_10->setEchoMode(QLineEdit::Password);

        verticalLayout_6->addWidget(lineEdit_10);

        label_29 = new QLabel(verticalLayoutWidget_6);
        label_29->setObjectName(QString::fromUtf8("label_29"));

        verticalLayout_6->addWidget(label_29);

        lineEdit_11 = new QLineEdit(verticalLayoutWidget_6);
        lineEdit_11->setObjectName(QString::fromUtf8("lineEdit_11"));
        lineEdit_11->setEchoMode(QLineEdit::Password);

        verticalLayout_6->addWidget(lineEdit_11);

        stackedWidget->addWidget(page_7);
        LoginScreen->setCentralWidget(centralwidget);

        retranslateUi(LoginScreen);

        stackedWidget->setCurrentIndex(3);
        pushButton_19->setDefault(false);
        pushButton->setDefault(false);
        pushButton_4->setDefault(false);
        pushButton_18->setDefault(false);
        pushButton_20->setDefault(false);


        QMetaObject::connectSlotsByName(LoginScreen);
    } // setupUi

    void retranslateUi(QMainWindow *LoginScreen)
    {
        LoginScreen->setWindowTitle(QApplication::translate("LoginScreen", "LoginScreen", nullptr));
        pushButton_19->setText(QApplication::translate("LoginScreen", "Register", nullptr));
        pushButton->setText(QApplication::translate("LoginScreen", "New Game", nullptr));
        pushButton_2->setText(QApplication::translate("LoginScreen", "Load Game", nullptr));
        pushButton_3->setText(QApplication::translate("LoginScreen", "Join Game", nullptr));
        label->setText(QString());
        label_2->setText(QString());
        pushButton_4->setText(QApplication::translate("LoginScreen", "Back", nullptr));
        pushButton_5->setText(QApplication::translate("LoginScreen", "Create", nullptr));
        label_4->setText(QApplication::translate("LoginScreen", "<html><head/><body><p><span style=\" font-weight:700;\">Game Name</span></p></body></html>", nullptr));
        label_5->setText(QApplication::translate("LoginScreen", "<html><head/><body><p><span style=\" font-weight:700;\">Your Name</span></p></body></html>", nullptr));
        label_6->setText(QApplication::translate("LoginScreen", "<html><head/><body><p><span style=\" font-weight:700;\">Password</span></p></body></html>", nullptr));
        lineEdit_3->setText(QString());
        label_3->setText(QApplication::translate("LoginScreen", "<html><head/><body><p align=\"center\"><span style=\" font-weight:700; color:#000000;\">Number of players:</span></p></body></html>", nullptr));
        label_7->setText(QApplication::translate("LoginScreen", "<html><head/><body><p align=\"center\"><span style=\" font-weight:700;\">House</span></p></body></html>", nullptr));
        label_8->setText(QString());
        label_9->setText(QApplication::translate("LoginScreen", "<html><head/><body><p align=\"center\"><span style=\" font-weight:700;\">Atreides</span></p></body></html>", nullptr));
        pushButton_6->setText(QApplication::translate("LoginScreen", "<", nullptr));
        pushButton_7->setText(QApplication::translate("LoginScreen", ">", nullptr));
        label_19->setText(QApplication::translate("LoginScreen", "<html><head/><body><p><span style=\" font-weight:700;\">Game Name</span></p></body></html>", nullptr));
        comboBox->setItemText(0, QApplication::translate("LoginScreen", "Amigos", nullptr));
        comboBox->setItemText(1, QApplication::translate("LoginScreen", "Hola", nullptr));

        label_20->setText(QApplication::translate("LoginScreen", "<html><head/><body><p><span style=\" font-weight:700;\">Your Name</span></p></body></html>", nullptr));
        label_21->setText(QApplication::translate("LoginScreen", "<html><head/><body><p><span style=\" font-weight:700;\">Password</span></p></body></html>", nullptr));
        lineEdit_9->setText(QString());
        label_23->setText(QString());
        label_24->setText(QApplication::translate("LoginScreen", "<html><head/><body><p align=\"center\"><span style=\" font-weight:700;\">Atreides</span></p></body></html>", nullptr));
        pushButton_15->setText(QApplication::translate("LoginScreen", ">", nullptr));
        pushButton_16->setText(QApplication::translate("LoginScreen", "Join", nullptr));
        label_25->setText(QApplication::translate("LoginScreen", "<html><head/><body><p align=\"center\"><span style=\" font-weight:700;\">House</span></p></body></html>", nullptr));
        pushButton_17->setText(QApplication::translate("LoginScreen", "<", nullptr));
        pushButton_18->setText(QApplication::translate("LoginScreen", "Back", nullptr));
        label_26->setText(QString());
        label_22->setText(QString());
        pushButton_20->setText(QApplication::translate("LoginScreen", "Back", nullptr));
        pushButton_21->setText(QApplication::translate("LoginScreen", "Register", nullptr));
        label_27->setText(QApplication::translate("LoginScreen", "<html><head/><body><p><span style=\" font-weight:700;\">Username</span></p></body></html>", nullptr));
        label_28->setText(QApplication::translate("LoginScreen", "<html><head/><body><p><span style=\" font-weight:700;\">Password</span></p></body></html>", nullptr));
        label_29->setText(QApplication::translate("LoginScreen", "<html><head/><body><p><span style=\" font-weight:700;\">Repeat Password</span></p></body></html>", nullptr));
    } // retranslateUi

};

namespace Ui {
    class LoginScreen: public Ui_LoginScreen {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_LOGINSCREEN_H
