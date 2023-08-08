#ifndef DUNELOGIN_H
#define DUNELOGIN_H

#include <QMainWindow>
#include "../Common/Sockets.h"

QT_BEGIN_NAMESPACE
namespace Ui { class DuneLogin; }
QT_END_NAMESPACE

class DuneLogin : public QMainWindow
{
    Q_OBJECT
private:
    Socket* socket;
public:
    DuneLogin(Socket* skt, QWidget *parent = nullptr);
    ~DuneLogin();
    void selectHouse();
    void selectHouseJoin();

private slots:
    void on_newGameButton_clicked();

    void on_backNew_clicked();

    void on_startNewGame_clicked();

    void on_nextHouse_clicked();

    void on_prevHouse_clicked();

    void on_joinGameButton_clicked();

    void on_backjoin_clicked();

    void on_startJoin_clicked();

    void on_prevHouseJoin_clicked();

    void on_nextHouseJoin_clicked();

    void on_reloadButton_clicked();

    void on_progressBar_valueChanged(int value);

private:
    Ui::DuneLogin *ui;
    int currentHouseIndex;
    int currentHouseIndexJoin;
};
#endif // DUNELOGIN_H
