import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services

Item {
    id: root

    implicitWidth: 840
    implicitHeight: layout.implicitHeight

    ColumnLayout {
        id: layout

        anchors.fill: parent
        spacing: Tokens.spacing.normal

        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.normal

            MaterialIcon {
                text: "timer"
                color: Colours.palette.m3primary
                font.pointSize: Tokens.font.size.extraLarge
            }

            ColumnLayout {
                spacing: 0

                StyledText {
                    text: qsTr("Timer")
                    font.pointSize: Tokens.font.size.extraLarge
                    font.weight: 800
                    color: Colours.palette.m3onSurface
                }

                StyledText {
                    text: qsTr("Stopwatch and countdown tools")
                    font.pointSize: Tokens.font.size.small
                    color: Colours.palette.m3onSurfaceVariant
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.normal

            TimeToolCard {
                Layout.fillWidth: true
                title: qsTr("Stopwatch")
                subtitle: TimerState.stopwatchRunning ? qsTr("Running") : qsTr("Paused")
                icon: "timer"
                accent: Colours.palette.m3primary
                value: TimerState.formatMs(TimerState.stopwatchDisplayMs)

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: Tokens.spacing.small

                    ActionButton {
                        text: TimerState.stopwatchRunning ? qsTr("Pause") : qsTr("Start")
                        icon: TimerState.stopwatchRunning ? "pause" : "play_arrow"
                        accent: Colours.palette.m3primary
                        primary: true
                        onClicked: TimerState.toggleStopwatch()
                    }

                    ActionButton {
                        text: qsTr("Reset")
                        icon: "restart_alt"
                        accent: Colours.palette.m3secondary
                        onClicked: TimerState.resetStopwatch()
                    }
                }
            }

            TimeToolCard {
                Layout.fillWidth: true
                title: qsTr("Countdown")
                subtitle: TimerState.timerFinished
                    ? qsTr("Finished")
                    : (TimerState.timerRunning ? qsTr("Running") : qsTr("Ready"))
                icon: TimerState.timerFinished ? "notifications_active" : "hourglass"
                accent: TimerState.timerFinished ? Colours.palette.m3error : Colours.palette.m3tertiary
                value: TimerState.formatSeconds(TimerState.timerDisplaySeconds)

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Tokens.spacing.small

                    StyledText {
                        Layout.alignment: Qt.AlignHCenter
                        text: qsTr("Duration: ") + TimerState.formatSeconds(TimerState.timerDurationSeconds)
                        color: Colours.palette.m3onSurfaceVariant
                        font.pointSize: Tokens.font.size.small
                        font.weight: 600
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: Tokens.spacing.small

                        SmallButton {
                            text: "-5m"
                            enabled: !TimerState.timerRunning
                            onClicked: TimerState.addTimerMinutes(-5)
                        }

                        SmallButton {
                            text: "-1m"
                            enabled: !TimerState.timerRunning
                            onClicked: TimerState.addTimerMinutes(-1)
                        }

                        SmallButton {
                            text: "+1m"
                            enabled: !TimerState.timerRunning
                            onClicked: TimerState.addTimerMinutes(1)
                        }

                        SmallButton {
                            text: "+5m"
                            enabled: !TimerState.timerRunning
                            onClicked: TimerState.addTimerMinutes(5)
                        }
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: Tokens.spacing.small

                        SmallButton {
                            text: "5m"
                            enabled: !TimerState.timerRunning
                            onClicked: TimerState.setPresetMinutes(5)
                        }

                        SmallButton {
                            text: "25m"
                            enabled: !TimerState.timerRunning
                            onClicked: TimerState.setPresetMinutes(25)
                        }

                        SmallButton {
                            text: "50m"
                            enabled: !TimerState.timerRunning
                            onClicked: TimerState.setPresetMinutes(50)
                        }
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: Tokens.spacing.small

                        ActionButton {
                            text: TimerState.timerRunning ? qsTr("Pause") : qsTr("Start")
                            icon: TimerState.timerRunning ? "pause" : "play_arrow"
                            accent: TimerState.timerFinished ? Colours.palette.m3error : Colours.palette.m3tertiary
                            primary: true
                            onClicked: TimerState.toggleTimer()
                        }

                        ActionButton {
                            text: qsTr("Reset")
                            icon: "restart_alt"
                            accent: Colours.palette.m3secondary
                            onClicked: TimerState.resetTimer()
                        }
                    }

                    StyledText {
                        Layout.alignment: Qt.AlignHCenter
                        visible: TimerState.timerFinished
                        text: qsTr("Time is up")
                        color: Colours.palette.m3error
                        font.weight: 800
                    }
                }
            }
        }
    }

    component TimeToolCard: StyledRect {
        id: card

        property string title
        property string subtitle
        property string icon
        property string value
        property color accent

        default property alias content: actionArea.data

        Layout.preferredHeight: 300
        radius: Tokens.rounding.large * 2
        color: Colours.tPalette.m3surfaceContainer

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: parent.radius - 1
            color: "transparent"
            border.width: 1
            border.color: card.accent
            opacity: 0.16
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Tokens.padding.large
            spacing: Tokens.spacing.normal

            RowLayout {
                Layout.fillWidth: true
                spacing: Tokens.spacing.small

                StyledRect {
                    implicitWidth: 42
                    implicitHeight: 42
                    radius: height / 2
                    color: card.accent

                    MaterialIcon {
                        anchors.centerIn: parent
                        text: card.icon
                        color: Colours.palette.m3onPrimary
                        font.pointSize: Tokens.font.size.large
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    StyledText {
                        text: card.title
                        color: Colours.palette.m3onSurface
                        font.pointSize: Tokens.font.size.large
                        font.weight: 800
                    }

                    StyledText {
                        text: card.subtitle
                        color: card.accent
                        font.pointSize: Tokens.font.size.small
                        font.weight: 700
                    }
                }
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: Tokens.spacing.small
                text: card.value
                color: card.accent
                font.pointSize: Tokens.font.size.extraLarge * 2
                font.family: Tokens.font.family.clock
                font.weight: 800
            }

            ColumnLayout {
                id: actionArea

                Layout.fillWidth: true
                Layout.topMargin: Tokens.spacing.small
                spacing: Tokens.spacing.small
            }
        }
    }

    component ActionButton: StyledRect {
        id: button

        signal clicked

        property string text
        property string icon
        property color accent
        property bool primary: false
        property bool enabled: true

        implicitWidth: label.implicitWidth + iconItem.implicitWidth + Tokens.padding.large * 2
        implicitHeight: 38
        radius: height / 2
        color: primary ? accent : Colours.tPalette.m3surfaceContainer
        opacity: enabled ? (hover.hovered ? 0.95 : 1) : 0.45

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.width: primary ? 0 : 1
            border.color: button.accent
            opacity: primary ? 0 : 0.45
        }

        RowLayout {
            anchors.centerIn: parent
            spacing: Tokens.spacing.small

            MaterialIcon {
                id: iconItem

                text: button.icon
                color: button.primary ? Colours.palette.m3onPrimary : button.accent
                font.pointSize: Tokens.font.size.normal
            }

            StyledText {
                id: label

                text: button.text
                color: button.primary ? Colours.palette.m3onPrimary : Colours.palette.m3onSurface
                font.weight: 800
                font.pointSize: Tokens.font.size.small
            }
        }

        HoverHandler {
            id: hover
            enabled: button.enabled
        }

        TapHandler {
            enabled: button.enabled
            onTapped: button.clicked()
        }
    }

    component SmallButton: StyledRect {
        id: button

        signal clicked

        property string text
        property bool enabled: true

        implicitWidth: label.implicitWidth + Tokens.padding.normal * 2
        implicitHeight: 30
        radius: height / 2
        color: Colours.tPalette.m3surfaceContainer
        opacity: enabled ? (hover.hovered ? 1 : 0.82) : 0.35

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.width: 1
            border.color: Colours.palette.m3outline
            opacity: 0.35
        }

        StyledText {
            id: label

            anchors.centerIn: parent
            text: button.text
            color: Colours.palette.m3onSurface
            font.pointSize: Tokens.font.size.small
            font.weight: 700
        }

        HoverHandler {
            id: hover
            enabled: button.enabled
        }

        TapHandler {
            enabled: button.enabled
            onTapped: button.clicked()
        }
    }
}
