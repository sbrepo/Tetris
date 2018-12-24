import QtQuick 2.7
import QtQuick.Window 2.1
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

ApplicationWindow {
    id: mw
    visible: true
    width: 540
    height: 960
    title: qsTr("Tetris")

    property double wp: width / 100
    property double hp: height / 100
    property int pd: Screen.pixelDensity

    function dp(x) {
        return pd * x;
    }

    StackLayout {
        id: mainStackLayout
        currentIndex: 0
        anchors.fill: parent

        Item {
            id: page1
            ColumnLayout {
                id: startLayout
                x: 20 * mw.wp
                y: 20 * mw.hp
                width: 60 * mw.wp
                height: 60 * mw.hp

                Button {
                    id: singleplayerButton
                    anchors.left: parent.left
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: qsTr("Одиночная игра")
                    font.pointSize: 25

                    onClicked: {
                        TetrisCppCore.startGame();
                        mainStackLayout.currentIndex = 2
                    }
                }

                Button {
                    id: multiplayerButton
                    anchors.left: parent.left
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: qsTr("Мультиплеер")
                    font.pointSize: 25

                    onClicked: {
                        mainStackLayout.currentIndex = 1
                    }
                }
            }
        }

        Item {
            id: page2
            ColumnLayout {
                id: connectionLayout
                x: 20 * mw.wp
                y: 20 * mw.hp
                width: 60 * mw.wp
                height: 60 * mw.hp

                Button {
                    id: connectButton
                    anchors.left: parent.left
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: qsTr("Присоединиться")
                    font.pointSize: 25
                }

                Button {
                    id: createButton
                    anchors.left: parent.left
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: qsTr("Создать")
                    font.pointSize: 25
                }
            }
        }

        Item {
            id: page3

            Rectangle {
                id: fieldRectangle
                property string field_data;
                property int field_width;
                property int field_height;

                x: 96 * mw.wp / field_width * field_height < 90 * mw.hp ? 2 * mw.wp : (mw.wp * 100 - 90 * mw.hp / field_height * field_width) / 2
                y: 2 * mw.hp
                width: 96 * mw.wp / field_width * field_height < 90 * mw.hp ? 96 * mw.wp : 90 * mw.hp / field_height * field_width
                height: 90 * mw.hp - 4 * mw.hp

                color: "#eee"
                border.width: 0

                Canvas  {
                    id: canv
                    anchors.fill: parent;

                    property double sym_width: canv.width / fieldRectangle.field_width
                    property double sym_height: canv.height / fieldRectangle.field_height
                    property double sym_margin: 0.05

                    onPaint: {
                        var ctx =  getContext("2d");
                        var color;

                        color = Qt.rgba(255 / 255, 165 / 255, 0, 255 / 255);
                        ctx.fillStyle = color;
                        ctx.fillRect(canv.x, canv.y + canv.height - sym_width * (fieldRectangle.field_height - 1) - dp(2), canv.width, dp(2));

                        var x, y;
                        var data = fieldRectangle.field_data.split('');
                        for (y = 0; y < fieldRectangle.field_height; y++) {
                            for (x = 0; x < fieldRectangle.field_width; x++) {
                                if (data[y * fieldRectangle.field_width + x] != '0') {
                                    if (data[y * fieldRectangle.field_width + x] == '1')
                                        color = Qt.rgba(255 / 255, 0, 0, 255 / 255);
                                    if (data[y * fieldRectangle.field_width + x] == '2')
                                        color = Qt.rgba(0, 255 / 255, 0, 255 / 255);
                                    if (data[y * fieldRectangle.field_width + x] == '3')
                                        color = Qt.rgba(0, 0, 255 / 255, 255 / 255);
                                    if (data[y * fieldRectangle.field_width + x] == '4')
                                        color = Qt.rgba(255 / 255, 255 / 255, 0, 255 / 255);
                                    if (data[y * fieldRectangle.field_width + x] == '5')
                                        color = Qt.rgba(255 / 255, 0, 255 / 255, 255 / 255);
                                    if (data[y * fieldRectangle.field_width + x] == '6')
                                        color = Qt.rgba(0, 255 / 255, 255 / 255, 255 / 255);
                                    ctx.fillStyle = color;
                                    ctx.fillRect(canv.x + x * sym_width + sym_width * sym_margin, canv.y + canv.height - sym_width * fieldRectangle.field_height + y * sym_width + sym_width * sym_margin, sym_width - sym_width * sym_margin * 2, sym_width - sym_width * sym_margin * 2);
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: gameOverRect
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.verticalCenterOffset: parent.height / 2 + height
                    visible: false
                    state: "state1"

                    color: "#fff"
                    radius: dp(4)
                    width: mw.widht < mw.height ? gameOverText.width +  10 * mw.wp : gameOverText.width +  10 * mw.hp
                    height: mw.widht < mw.height ? gameOverText.height + 10 * mw.wp : gameOverText.height +  10 * mw.hp
                    layer.enabled: true
                    layer.effect: DropShadow {
                        anchors.fill: gameOverRect
                        //cached: true
                        verticalOffset: dp(4)
                        spread: 0
                        radius: dp(12)
                        samples: dp(48)
                        color: "#80000000"
                        source: gameOverRect
                    }
                    states: [
                        State {
                            name: "state1"
                            PropertyChanges {
                                target:gameOverRect
                                anchors.verticalCenterOffset: fieldRectangle.height / 2 + height
                            }
                        },
                        State {
                            name: "state2"
                            PropertyChanges {
                                target:gameOverRect
                                anchors.verticalCenterOffset: 0
                            }
                        }
                    ]

                    transitions: [
                        Transition {
                            from: "state1"
                            to: "state2"
                            PropertyAnimation {
                                target: gameOverRect
                                properties: "anchors.verticalCenterOffset"
                                duration: 1000
                                easing.type: Easing.OutBack
                                easing.amplitude: 0.45
                            }
                        }
                    ]

                    Label {
                        id: gameOverText
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter;
                        text: qsTr("Поражение!")
                        font.pointSize: 30
                    }
                }

                Connections {
                    target: TetrisCppCore

                    onRepaintField: {
                        fieldRectangle.field_data = f_data;
                        fieldRectangle.field_width = f_width;
                        fieldRectangle.field_height = f_height;

                        var ctx = canv.getContext("2d");
                        ctx.reset();
                        canv.requestPaint();
                    }

                    onGameOver: {
                        gameOverRect.visible = true;
                        gameOverRect.state = "state2"
                    }
                }
            }

            Button {
                id: turnRightButton
                text: qsTr("")
                padding: 0

                x: mw.width / 5 * 0
                y: mw.height - 10 * mw.hp
                width: mw.width / 5
                height: 10 * mw.hp

                Image {
                    anchors.fill: parent
                    smooth: true
                    source: "qrc:/textures/rotate_right.svg"
                    sourceSize: Qt.size(parent.width, parent.height)
                }

                onClicked: {
                    TetrisCppCore.turnRight();
                }
            }

            Button {
                id: moveLeftButton
                text: qsTr("")
                padding: 0

                x: mw.width / 5 * 1
                y: mw.height - 10 * mw.hp
                width: mw.width / 5
                height: 10 * mw.hp

                Image {
                    anchors.fill: parent
                    smooth: true
                    source: "qrc:/textures/move_left.svg"
                    sourceSize: Qt.size(parent.width, parent.height)
                }

                onClicked: {
                    TetrisCppCore.moveLeft();
                }
            }

            Button {
                id: nextButton
                text: qsTr("")
                padding: 0

                x: mw.width / 5 * 2
                y: mw.height - 10 * mw.hp
                width: mw.width / 5
                height: 10 * mw.hp

                Image {
                    anchors.fill: parent
                    smooth: true
                    source: "qrc:/textures/next.svg"
                    sourceSize: Qt.size(parent.width, parent.height)
                }

                onClicked: {
                    TetrisCppCore.next();
                }
            }

            Button {
                id: moveRightButton
                text: qsTr("")
                padding: 0

                x: mw.width / 5 * 3
                y: mw.height - 10 * mw.hp
                width: mw.width / 5
                height: 10 * mw.hp

                Image {
                    anchors.fill: parent
                    smooth: true
                    source: "qrc:/textures/move_right.svg"
                    sourceSize: Qt.size(parent.width, parent.height)
                }

                onClicked: {
                    TetrisCppCore.moveRight();
                }
            }

            Button {
                id: turnLeftButton
                text: qsTr("")
                padding: 0

                x: mw.width / 5 * 4
                y: mw.height - 10 * mw.hp
                width: mw.width / 5
                height: 10 * mw.hp

                Image {
                    anchors.fill: parent
                    smooth: true
                    source: "qrc:/textures/rotate_left.svg"
                    sourceSize: Qt.size(parent.width, parent.height)
                }

                onClicked: {
                    TetrisCppCore.turnLeft();
                }
            }
        }
    }
}
