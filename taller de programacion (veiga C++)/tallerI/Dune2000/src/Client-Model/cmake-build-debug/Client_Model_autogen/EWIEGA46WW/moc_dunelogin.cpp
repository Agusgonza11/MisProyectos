/****************************************************************************
** Meta object code from reading C++ file 'dunelogin.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.12.8)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../dunelogin.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'dunelogin.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.12.8. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_DuneLogin_t {
    QByteArrayData data[15];
    char stringdata0[296];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_DuneLogin_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_DuneLogin_t qt_meta_stringdata_DuneLogin = {
    {
QT_MOC_LITERAL(0, 0, 9), // "DuneLogin"
QT_MOC_LITERAL(1, 10, 24), // "on_newGameButton_clicked"
QT_MOC_LITERAL(2, 35, 0), // ""
QT_MOC_LITERAL(3, 36, 18), // "on_backNew_clicked"
QT_MOC_LITERAL(4, 55, 23), // "on_startNewGame_clicked"
QT_MOC_LITERAL(5, 79, 20), // "on_nextHouse_clicked"
QT_MOC_LITERAL(6, 100, 20), // "on_prevHouse_clicked"
QT_MOC_LITERAL(7, 121, 25), // "on_joinGameButton_clicked"
QT_MOC_LITERAL(8, 147, 19), // "on_backjoin_clicked"
QT_MOC_LITERAL(9, 167, 20), // "on_startJoin_clicked"
QT_MOC_LITERAL(10, 188, 24), // "on_prevHouseJoin_clicked"
QT_MOC_LITERAL(11, 213, 24), // "on_nextHouseJoin_clicked"
QT_MOC_LITERAL(12, 238, 23), // "on_reloadButton_clicked"
QT_MOC_LITERAL(13, 262, 27), // "on_progressBar_valueChanged"
QT_MOC_LITERAL(14, 290, 5) // "value"

    },
    "DuneLogin\0on_newGameButton_clicked\0\0"
    "on_backNew_clicked\0on_startNewGame_clicked\0"
    "on_nextHouse_clicked\0on_prevHouse_clicked\0"
    "on_joinGameButton_clicked\0on_backjoin_clicked\0"
    "on_startJoin_clicked\0on_prevHouseJoin_clicked\0"
    "on_nextHouseJoin_clicked\0"
    "on_reloadButton_clicked\0"
    "on_progressBar_valueChanged\0value"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_DuneLogin[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
      12,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: name, argc, parameters, tag, flags
       1,    0,   74,    2, 0x08 /* Private */,
       3,    0,   75,    2, 0x08 /* Private */,
       4,    0,   76,    2, 0x08 /* Private */,
       5,    0,   77,    2, 0x08 /* Private */,
       6,    0,   78,    2, 0x08 /* Private */,
       7,    0,   79,    2, 0x08 /* Private */,
       8,    0,   80,    2, 0x08 /* Private */,
       9,    0,   81,    2, 0x08 /* Private */,
      10,    0,   82,    2, 0x08 /* Private */,
      11,    0,   83,    2, 0x08 /* Private */,
      12,    0,   84,    2, 0x08 /* Private */,
      13,    1,   85,    2, 0x08 /* Private */,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Int,   14,

       0        // eod
};

void DuneLogin::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<DuneLogin *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->on_newGameButton_clicked(); break;
        case 1: _t->on_backNew_clicked(); break;
        case 2: _t->on_startNewGame_clicked(); break;
        case 3: _t->on_nextHouse_clicked(); break;
        case 4: _t->on_prevHouse_clicked(); break;
        case 5: _t->on_joinGameButton_clicked(); break;
        case 6: _t->on_backjoin_clicked(); break;
        case 7: _t->on_startJoin_clicked(); break;
        case 8: _t->on_prevHouseJoin_clicked(); break;
        case 9: _t->on_nextHouseJoin_clicked(); break;
        case 10: _t->on_reloadButton_clicked(); break;
        case 11: _t->on_progressBar_valueChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        default: ;
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject DuneLogin::staticMetaObject = { {
    &QMainWindow::staticMetaObject,
    qt_meta_stringdata_DuneLogin.data,
    qt_meta_data_DuneLogin,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *DuneLogin::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *DuneLogin::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_DuneLogin.stringdata0))
        return static_cast<void*>(this);
    return QMainWindow::qt_metacast(_clname);
}

int DuneLogin::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QMainWindow::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 12)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 12;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 12)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 12;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
