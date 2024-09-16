#ifndef EDITORMAINWINDOW_H
#define EDITORMAINWINDOW_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
namespace Ui { class EditorMainWindow; }
QT_END_NAMESPACE

class EditorMainWindow : public QMainWindow
{
    Q_OBJECT

public:
    EditorMainWindow(QWidget *parent = nullptr);
    ~EditorMainWindow();

private slots:
    void on_new_2_clicked();

    void on_back1_clicked();

    void on_load_clicked();

    void on_back_2_clicked();

    void on_startLoad_clicked();

    void on_startnew_clicked();

private:
    Ui::EditorMainWindow *ui;
};
#endif // EDITORMAINWINDOW_H
