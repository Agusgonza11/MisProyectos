#ifndef FIRSTWINDOW_H
#define FIRSTWINDOW_H

#include <QMainWindow>
#include <QMediaPlayer>


QT_BEGIN_NAMESPACE
namespace Ui { class FIrstWindow; }
QT_END_NAMESPACE

class FIrstWindow : public QMainWindow
{
    Q_OBJECT

public:
    FIrstWindow(std::string&,std::string&, QWidget *parent = nullptr);
    ~FIrstWindow();

private slots:
    void on_FIrstWindow_iconSizeChanged(const QSize &iconSize);

    void on_checkBox_stateChanged(int arg1);

    void on_pushButton_clicked();

private:
    std::string& host;
    std::string& port;
    Ui::FIrstWindow *ui;
    QMediaPlayer *music;
    bool playing;
};
#endif // FIRSTWINDOW_H
