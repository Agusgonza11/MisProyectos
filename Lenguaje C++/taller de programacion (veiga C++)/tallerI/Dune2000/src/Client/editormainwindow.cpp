#include "editormainwindow.h"
#include "./ui_editormainwindow.h"

EditorMainWindow::EditorMainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::EditorMainWindow)
{
    ui->setupUi(this);
    ui->stackedWidget->setCurrentIndex(0);
    ui->MapX->setValidator( new QIntValidator(0, 9999, this) );
    ui->MapY->setValidator( new QIntValidator(0, 9999, this) );
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

}


void EditorMainWindow::on_startnew_clicked()
{

}

