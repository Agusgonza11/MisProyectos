/********************************************************************************
** Form generated from reading UI file 'firstwindow.ui'
**
** Created by: Qt User Interface Compiler version 5.12.12
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_FIRSTWINDOW_H
#define UI_FIRSTWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QCheckBox>
#include <QtWidgets/QFrame>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>
#include <QDir>
#include <iostream>

QT_BEGIN_NAMESPACE

class Ui_FIrstWindow
{
public:
    QWidget *centralwidget;
    QLabel *label;
    QFrame *frame;
    QLabel *label_2;
    QWidget *verticalLayoutWidget;
    QVBoxLayout *verticalLayout;
    QLabel *label_3;
    QLineEdit *lineEdit;
    QWidget *verticalLayoutWidget_3;
    QVBoxLayout *verticalLayout_3;
    QLabel *label_4;
    QLineEdit *lineEdit_2;
    QCheckBox *checkBox;
    QPushButton *pushButton;

    void setupUi(QMainWindow *FIrstWindow)
    {
        QString path = QDir::currentPath();
        std::cout<<path.toStdString();
        if (FIrstWindow->objectName().isEmpty())
            FIrstWindow->setObjectName(QString::fromUtf8("FIrstWindow"));
        FIrstWindow->resize(900, 600);
        centralwidget = new QWidget(FIrstWindow);
        centralwidget->setObjectName(QString::fromUtf8("centralwidget"));
        label = new QLabel(centralwidget);
        label->setObjectName(QString::fromUtf8("label"));
        label->setGeometry(QRect(299, 0, 601, 600));
        label->setPixmap(QPixmap(QString::fromUtf8("/home/lucas/Desktop/Taller I/Dune2000/src/Client/resources/Webp.net-resizeimage.jpg")));
        frame = new QFrame(centralwidget);
        frame->setObjectName(QString::fromUtf8("frame"));
        frame->setGeometry(QRect(0, 0, 301, 600));
        frame->setStyleSheet(QString::fromUtf8("background-color: rgb(253,245,230);"));
        frame->setFrameShape(QFrame::StyledPanel);
        frame->setFrameShadow(QFrame::Plain);
        label_2 = new QLabel(frame);
        label_2->setObjectName(QString::fromUtf8("label_2"));
        label_2->setGeometry(QRect(0, 20, 301, 140));
        label_2->setPixmap(QPixmap(QString::fromUtf8("/home/lucas/Desktop/Taller I/Dune2000/src/Client/resources/0c2f66f43752d47fb49abeea0badf4.png")));
        verticalLayoutWidget = new QWidget(frame);
        verticalLayoutWidget->setObjectName(QString::fromUtf8("verticalLayoutWidget"));
        verticalLayoutWidget->setGeometry(QRect(10, 250, 271, 61));
        verticalLayout = new QVBoxLayout(verticalLayoutWidget);
        verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
        verticalLayout->setContentsMargins(0, 0, 0, 0);
        label_3 = new QLabel(verticalLayoutWidget);
        label_3->setObjectName(QString::fromUtf8("label_3"));
        label_3->setEnabled(true);
        label_3->setMaximumSize(QSize(100, 30));

        verticalLayout->addWidget(label_3);

        lineEdit = new QLineEdit(verticalLayoutWidget);
        lineEdit->setObjectName(QString::fromUtf8("lineEdit"));
        lineEdit->setEnabled(true);
        lineEdit->setMaximumSize(QSize(500, 30));

        verticalLayout->addWidget(lineEdit);

        verticalLayoutWidget_3 = new QWidget(frame);
        verticalLayoutWidget_3->setObjectName(QString::fromUtf8("verticalLayoutWidget_3"));
        verticalLayoutWidget_3->setGeometry(QRect(10, 330, 271, 61));
        verticalLayout_3 = new QVBoxLayout(verticalLayoutWidget_3);
        verticalLayout_3->setObjectName(QString::fromUtf8("verticalLayout_3"));
        verticalLayout_3->setContentsMargins(0, 0, 0, 0);
        label_4 = new QLabel(verticalLayoutWidget_3);
        label_4->setObjectName(QString::fromUtf8("label_4"));
        label_4->setEnabled(true);
        label_4->setMaximumSize(QSize(100, 30));

        verticalLayout_3->addWidget(label_4);

        lineEdit_2 = new QLineEdit(verticalLayoutWidget_3);
        lineEdit_2->setObjectName(QString::fromUtf8("lineEdit_2"));
        lineEdit_2->setEnabled(true);
        lineEdit_2->setMaximumSize(QSize(500, 30));

        verticalLayout_3->addWidget(lineEdit_2);

        checkBox = new QCheckBox(frame);
        checkBox->setObjectName(QString::fromUtf8("checkBox"));
        checkBox->setGeometry(QRect(10, 530, 51, 61));
        checkBox->setStyleSheet(QString::fromUtf8("QCheckBox::indicator{\n"
"	width: 40px;\n"
"	height: 40px;\n"
"}\n"
"\n"
"QCheckBox::indicator:unchecked{\n"
"	image: url(\"/home/lucas/Desktop/Taller I/Dune2000/src/Client/resources/switch.png\");\n"
"}\n"
"\n"
"QCheckBox::indicator:checked{\n"
"	image: url(\"/home/lucas/Desktop/Taller I/Dune2000/src/Client/resources/off-button.png\");\n"
"}"));
        pushButton = new QPushButton(centralwidget);
        pushButton->setObjectName(QString::fromUtf8("pushButton"));
        pushButton->setGeometry(QRect(770, 550, 111, 31));
        FIrstWindow->setCentralWidget(centralwidget);

        retranslateUi(FIrstWindow);

        QMetaObject::connectSlotsByName(FIrstWindow);
    } // setupUi

    void retranslateUi(QMainWindow *FIrstWindow)
    {
        FIrstWindow->setWindowTitle(QApplication::translate("FIrstWindow", "FIrstWindow", nullptr));
        label->setText(QString());
        label_2->setText(QString());
        label_3->setText(QApplication::translate("FIrstWindow", "<html><head/><body><p><span style=\" font-size:12pt; font-weight:600;\">Host</span></p></body></html>", nullptr));
        label_4->setText(QApplication::translate("FIrstWindow", "<html><head/><body><p><span style=\" font-size:12pt; font-weight:600;\">Port</span></p></body></html>", nullptr));
        checkBox->setText(QString());
        pushButton->setText(QApplication::translate("FIrstWindow", "Begin", nullptr));
    } // retranslateUi

};

namespace Ui {
    class FIrstWindow: public Ui_FIrstWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_FIRSTWINDOW_H
