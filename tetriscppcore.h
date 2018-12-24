#ifndef TETRISCPPCORE_H
#define TETRISCPPCORE_H

#include <QObject>
#include <QString>
#include <QTimer>
#include "TetrisCore.h"

class TetrisCppCore : public QObject {
    Q_OBJECT
public:
    explicit TetrisCppCore(QObject *parent = nullptr);

private:
    Field field;
    QTimer *timer;

signals:
    void repaintField(QString f_data, int f_width, int f_height);
    void gameOver();

public slots:
    void startGame();
    void next();
    void turnLeft();
    void turnRight();
    void moveLeft();
    void moveRight();
};

#endif // TETRISCPPCORE_H
