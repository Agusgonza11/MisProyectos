#ifndef LOGINSCREEN_H
#define LOGINSCREEN_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
namespace Ui { class LoginScreen; }
QT_END_NAMESPACE

class LoginScreen : public QMainWindow
{
    Q_OBJECT

public:
    LoginScreen(QWidget *parent = nullptr);
    ~LoginScreen();

private slots:
    void on_pushButton_clicked();
    void on_pushButton_4_clicked();
    void on_pushButton_7_clicked();
    void on_pushButton_6_clicked();
    void selectHouse();
    void selectHouseJoin();
    void on_pushButton_15_clicked();

    void on_pushButton_17_clicked();

    void on_pushButton_3_clicked();

    void on_pushButton_18_clicked();

    void on_comboBox_activated(int index);

    void on_pushButton_19_clicked();

    void on_pushButton_20_clicked();

private:
    Ui::LoginScreen *ui;
    int currentHouseIndex;
};
#endif // LOGINSCREEN_H
