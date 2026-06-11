import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Caelestia.Config
import qs.components

Item {
    id: root

    implicitWidth: 840
    implicitHeight: layout.implicitHeight

    property int stopwatchMs: 0
    property bool stopwatchRunning: false

    property int timerTotalSeconds: 5 * 60
    property int timerRemainingSeconds: timerTotalSeconds
    property bool timerRunning: false
    property bool timerFinished: false

    function two(n: int): string {
        return n < 10 ? "0" + n : "" + n;
    }

    function formatMs(ms: int): string {
        const totalSeconds = Math.floor(ms / 1000);
        const hours = Math.floor(totalSeconds / 3600);
        const minutes = Math.floor((totalSeconds % 3600) / 60);
        const seconds = totalSeconds % 60;
        return hours > 0 ? hours + ":" + two(minutes) + ":" + two(seconds) : two(minutes) + ":" + two(seconds);
    }

    function formatSeconds(totalSeconds: int): string {
        const safe = Math.max(0, totalSeconds);
        const hours = Math.floor(safe / 3600);
        const minutes = Math.floor((safe % 3600) / 60);
        const seconds = safe % 60;
        return hours > 0 ? hours + ":" + two(minutes) + ":" + two(seconds) : two(minutes) + ":" + two(seconds);
    }

    Timer {
        id: stopwatchTick
        interval: 1000
        repeat: true
        running: root.stopwatchRunning
        onTriggered: root.stopwatchMs += 1000
    }

    Timer {
        id: countdownTick
        interval: 1000
        repeat: true
        running: root.timerRunning
        onTriggered: {
            if (root.timerRemainingSeconds > 1) {
                root.timerRemainingSeconds -= 1;
            } else {
                root.timerRemainingSeconds = 0;
                root.timerRunning = false;
                root.timerFinished = true;
            }
        }
    }

    ColumnLayout {
        id: layout

        anchors.fill: parent
        spacing: Tokens.spacing.normal

        StyledText {
            text: qsTr("Cronómetro y temporizador")
            font.pointSize: Tokens.font.size.extraLarge
            font.weight: 700
            color: Colours.palette.m3onSurface
        }

        StyledText {
            Layout.topMargin: -Tokens.spacing.small
            text: qsTr("Herramientas locales, sin conexión ni servicios externos.")
            font.pointSize: Tokens.font.size.small
            color: Colours.palette.m3onSurfaceVariant
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.normal

            TimerCard {
                Layout.fillWidth: true
                title: qsTr("Cronómetro")
                icon: "timer"
                value: root.formatMs(root.stopwatchMs)
                accent: Colours.palette.m3primary

                RowLayout {
                    spacing: Tokens.spacing.small

                    Button {
                        text: root.stopwatchRunning ? qsTr("Pausar") : qsTr("Iniciar")
                        onClicked: root.stopwatchRunning = !root.stopwatchRunning
                    }

                    Button {
                        text: qsTr("Reiniciar")
                        onClicked: {
                            root.stopwatchRunning = false;
                            root.stopwatchMs = 0;
                        }
                    }
                }
            }

            TimerCard {
                Layout.fillWidth: true
                title: qsTr("Temporizador")
                icon: "hourglass"
                value: root.formatSeconds(root.timerRemainingSeconds)
                accent: root.timerFinished ? Colours.palette.m3error : Colours.palette.m3tertiary

                ColumnLayout {
                    spacing: Tokens.spacing.small

                    RowLayout {
                        spacing: Tokens.spacing.small
                        enabled: !root.timerRunning

                        SpinBox {
                            id: minutesBox
                            from: 0
                            to: 180
                            value: Math.floor(root.timerTotalSeconds / 60)
                            editable: true
                            onValueModified: {
                                root.timerTotalSeconds = value * 60 + secondsBox.value;
                                root.timerRemainingSeconds = root.timerTotalSeconds;
                                root.timerFinished = false;
                            }
                        }

                        StyledText {
                            text: qsTr("min")
                            color: Colours.palette.m3onSurfaceVariant
                        }

                        SpinBox {
                            id: secondsBox
                            from: 0
                            to: 59
                            value: root.timerTotalSeconds % 60
                            editable: true
                            onValueModified: {
                                root.timerTotalSeconds = minutesBox.value * 60 + value;
                                root.timerRemainingSeconds = root.timerTotalSeconds;
                                root.timerFinished = false;
                            }
                        }

                        StyledText {
                            text: qsTr("s")
                            color: Colours.palette.m3onSurfaceVariant
                        }
                    }

                    RowLayout {
                        spacing: Tokens.spacing.small

                        Button {
                            text: root.timerRunning ? qsTr("Pausar") : qsTr("Iniciar")
                            enabled: root.timerRemainingSeconds > 0
                            onClicked: {
                                root.timerFinished = false;
                                root.timerRunning = !root.timerRunning;
                            }
                        }

                        Button {
                            text: qsTr("Reiniciar")
                            onClicked: {
                                root.timerRunning = false;
                                root.timerFinished = false;
                                root.timerRemainingSeconds = root.timerTotalSeconds;
                            }
                        }
                    }

                    StyledText {
                        visible: root.timerFinished
                        text: qsTr("Tiempo terminado")
                        color: Colours.palette.m3error
                        font.weight: 700
                    }
                }
            }
        }
    }

    component TimerCard: StyledRect {
        id: card

        property string title
        property string icon
        property string value
        property color accent

        default property alias content: contentColumn.data

        Layout.preferredHeight: 260
        radius: Tokens.rounding.large * 2
        color: Colours.tPalette.m3surfaceContainer

        ColumnLayout {
            id: contentColumn

            anchors.fill: parent
            anchors.margins: Tokens.padding.large
            spacing: Tokens.spacing.normal

            RowLayout {
                Layout.fillWidth: true

                MaterialIcon {
                    text: card.icon
                    font.pointSize: Tokens.font.size.extraLarge
                    color: card.accent
                }

                StyledText {
                    text: card.title
                    font.pointSize: Tokens.font.size.large
                    font.weight: 700
                    color: Colours.palette.m3onSurface
                }

                Item {
                    Layout.fillWidth: true
                }
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: card.value
                font.pointSize: Tokens.font.size.extraLarge * 2
                font.family: Tokens.font.family.clock
                font.weight: 700
                color: card.accent
            }
        }
    }
}
