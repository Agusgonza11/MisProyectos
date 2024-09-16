/****************************************************************************
** Meta object code from reading C++ file 'loginscreen.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.12.8)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../loginscreen.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'loginscreen.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.12.8. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_LoginScreen_t {
    QByteArrayData data[16];
    char stringdata0[312];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_LoginScreen_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_LoginScreen_t qt_meta_stringdata_LoginScreen = {
    {
QT_MOC_LITERAL(0, 0, 11), // "LoginScreen"
QT_MOC_LITERAL(1, 12, 21), // "on_pushButton_clicked"
QT_MOC_LITERAL(2, 34, 0), // ""
QT_MOC_LITERAL(3, 35, 23), // "on_pushButton_4_clicked"
QT_MOC_LITERAL(4, 59, 23), // "on_pushButton_7_clicked"
QT_MOC_LITERAL(5, 83, 23), // "on_pushButton_6_clicked"
QT_MOC_LITERAL(6, 107, 11), // "selectHouse"
QT_MOC_LITERAL(7, 119, 15), // "selectHouseJoin"
QT_MOC_LITERAL(8, 135, 24), // "on_pushButton_15_clicked"
QT_MOC_LITERAL(9, 160, 24), // "on_pushButton_17_clicked"
QT_MOC_LITERAL(10, 185, 23), // "on_pushButton_3_clicked"
QT_MOC_LITERAL(11, 209, 24), // "on_pushButton_18_clicked"
QT_MOC_LITERAL(12, 234, 21), // "on_comboBox_activated"
QT_MOC_LITERAL(13, 256, 5), // "index"
QT_MOC_LITERAL(14, 262, 24), // "on_pushButton_19_clicked"
QT_MOC_LITERAL(15, 287, 24) // "on_pushButton_20_clicked"

    },
    "LoginScreen\0on_pushButton_clicked\0\0"
    "on_pushButton_4_clicked\0on_pushButton_7_clicked\0"
    "on_pushButton_6_clicked\0selectHouse\0"
    "selectHouseJoin\0on_pushButton_15_clicked\0"
    "on_pushButton_17_clicked\0"
    "on_pushButton_3_clicked\0"
    "on_pushButton_18_clicked\0on_comboBox_activated\0"
    "index\0on_pushButton_19_clicked\0"
    "on_pushButton_20_clicked"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_LoginScreen[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
      13,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: name, argc, parameters, tag, flags
       1,    0,   79,    2, 0x08 /* Private */,
       3,    0,   80,    2, 0x08 /* Private */,
       4,    0,   81,    2, 0x08 /* Private */,
       5,    0,   82,    2, 0x08 /* Private */,
       6,    0,   83,    2, 0x08 /* Private */,
       7,    0,   84,    2, 0x08 /* Private */,
       8,    0,   85,    2, 0x08 /* Private */,
       9,    0,   86,    2, 0x08 /* Private */,
      10,    0,   87,    2, 0x08 /* Private */,
      11,    0,   88,    2, 0x08 /* Private */,
      12,    1,   89,    2, 0x08 /* Private */,
      14,    0,   92,    2, 0x08 /* Private */,
      15,    0,   93,    2, 0x08 /* Private */,

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
    QMetaType::Void, QMetaType::Int,   13,
    QMetaType::Void,
    QMetaType::Void,

       0        // eod
};

void LoginScreen::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<LoginScreen *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->on_pushButton_clicked(); break;
        case 1: _t->on_pushButton_4_clicked(); break;
        case 2: _t->on_pushButton_7_clicked(); break;
        case 3: _t->on_pushButton_6_clicked(); break;
        case 4: _t->selectHouse(); break;
        case 5: _t->selectHouseJoin(); break;
        case 6: _t->on_pushButton_15_clicked(); break;
        case 7: _t->on_pushButton_17_clicked(); break;
        case 8: _t->on_pushButton_3_clicked(); break;
        case 9: _t->on_pushButton_18_clicked(); break;
        case 10: _t->on_comboBox_activated((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 11: _t->on_pushButton_19_clicked(); break;
        case 12: _t->on_pushButton_20_clicked(); break;
        default: ;
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject LoginScreen::staticMetaObject = { {
    &QMainWindow::staticMetaObject,
    qt_meta_stringdata_LoginScreen.data,
    qt_meta_data_LoginScreen,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *LoginScreen::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *LoginScreen::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_LoginScreen.stringdata0))
        return static_cast<void*>(this);
    return QMainWindow::qt_metacast(_clname);
}

int LoginScreen::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QMainWindow::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 13)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 13;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 13)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 13;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
