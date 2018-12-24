#include <ctime>
#include <cstdlib>
#include <QString>
#include <QDebug>

class Field {
private:
    static const int WIDTH = 20, HEIGHT = 20;
    static const int NUM_FIGURES = 7;
    static const bool figure[NUM_FIGURES][4][4];
    
    static const char FILLED_CELL = '#';
    
    int field[HEIGHT][WIDTH];
    // figure settings
    int figure_type;
    int figure_x, figure_y;
    int rotate;
    // game data
    int figure_rand_num; // 1 - 6
    bool game_over, game_pause;
    int lines_completed;
    
    // inside functions
    bool checkCollision(int figure_type, int figure_x, int figure_y, int rot);
	int checkLine();
	void deleteLine(int num_line);
    bool getFigureCell(int type, int x, int y, int rot);
    
public:
    Field() {srand(time(NULL));}
    void init();
    void spawnFigure();
    void turnLeft();
    void turnRight();
    void moveLeft();
    void moveRight();
    void next();
    void pause(bool is_pause) {this->game_pause = is_pause;}

    bool isGameOver() {return game_over;}
    QString getFieldData();  // specially for qt
    int width() {return WIDTH;}
    int height() {return HEIGHT;}
    int linesCompleted() {return lines_completed;}
};
