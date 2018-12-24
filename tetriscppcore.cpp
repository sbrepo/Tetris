#include "tetriscppcore.h"

TetrisCppCore::TetrisCppCore(QObject *parent) : QObject(parent)
{
    timer = new QTimer();
    connect(timer, SIGNAL(timeout()), this, SLOT(next()));
}

void TetrisCppCore::startGame() {
    field.init();
    timer->start(500);
    emit repaintField(field.getFieldData(), field.width(), field.height());
}

void TetrisCppCore::next() {
    field.next();
    if (field.isGameOver()) {
        emit gameOver();
    }
    emit repaintField(field.getFieldData(), field.width(), field.height());
}

void TetrisCppCore::turnLeft() {
    field.turnLeft();
    emit repaintField(field.getFieldData(), field.width(), field.height());
}

void TetrisCppCore::turnRight() {
    field.turnRight();
    emit repaintField(field.getFieldData(), field.width(), field.height());
}

void TetrisCppCore::moveLeft() {
    field.moveLeft();
    emit repaintField(field.getFieldData(), field.width(), field.height());
}

void TetrisCppCore::moveRight() {
    field.moveRight();
    emit repaintField(field.getFieldData(), field.width(), field.height());
}
