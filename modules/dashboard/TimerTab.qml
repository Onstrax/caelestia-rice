import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services

Item {
    id: root

    implicitWidth: 840
    implicitHeight: layout.implicitHeight

    readonly property int durationMinutes: Math.floor(TimerState.timerDurationSeconds / 60)
    readonly property int durationSeconds: TimerState.timerDurationSeconds % 60

    function setDurationParts(minutes: int, seconds: int): void {
        TimerState.setTimerDuration(Math.max(1, minutes * 60 + seconds));
    }

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
                    font.weight: 700
                    color: Colours.palette.m3onSurface
                }

                StyledText {
                    text: qsTr("Stopwatch and countdown tools")
                    font.pointSize: Tokens.font.size.small
                    font.weight: 500
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
                    Layout.fillWidth: true
                    spacing: Tokens.spacing.small

                    Item { Layout.fillWidth: true }

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

                    Item { Layout.fillWidth: true }
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
                        text: qsTr("Duration")
                        color: Colours.palette.m3onSurfaceVariant
                        font.pointSize: Tokens.font.size.small
                        font.weight: 550
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: Tokens.spacing.small
                        enabled: !TimerState.timerRunning
                        opacity: enabled ? 1 : 0.5

                        NumberStepper {
                            label: qsTr("min")
                            value: root.durationMinutes
                            from: 0
                            to: 180
                            accent: Colours.palette.m3tertiary
                            onRequested: value => root.setDurationParts(value, root.durationSeconds)
                        }

                        StyledText {
                            text: ":"
                            color: Colours.palette.m3tertiary
                            font.pointSize: Tokens.font.size.large
                            font.family: Tokens.font.family.clock
                            font.weight: 600
                        }

                        NumberStepper {
                            label: qsTr("sec")
                            value: root.durationSeconds
                            from: 0
                            to: 59
                            accent: Colours.palette.m3tertiary
                            onRequested: value => root.setDurationParts(root.durationMinutes, value)
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Tokens.spacing.small

                        Item { Layout.fillWidth: true }

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

                        Item { Layout.fillWidth: true }
                    }

                    StyledText {
                        Layout.alignment: Qt.AlignHCenter
                        visible: TimerState.timerFinished
                        text: qsTr("Time is up")
                        color: Colours.palette.m3error
                        font.weight: 650
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
            anchors.margins: Tokens.padding.normal
            spacing: Tokens.spacing.small

            RowLayout {
                Layout.fillWidth: true
                spacing: Tokens.spacing.small

                StyledRect {
                    implicitWidth: 40
                    implicitHeight: 40
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
                        font.weight: 700
                    }

                    StyledText {
                        text: card.subtitle
                        color: card.accent
                        font.pointSize: Tokens.font.size.small
                        font.weight: 600
                    }
                }
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: Tokens.spacing.small
                text: card.value
                color: card.accent
                font.pointSize: Tokens.font.size.extraLarge * 1.62
                font.family: Tokens.font.family.clock
                font.weight: 700
            }

            ColumnLayout {
                id: actionArea

                Layout.fillWidth: true
                Layout.topMargin: 0
                spacing: Tokens.spacing.small
            }
        }
    }

    component NumberStepper: StyledRect {
        id: stepper

        signal requested(int value)

        property string label
        property int value: 0
        property int from: 0
        property int to: 59
        property color accent

        function two(n: int): string {
            return n < 10 ? "0" + n : "" + n;
        }

        implicitWidth: 88
        implicitHeight: 72
        radius: Tokens.rounding.large
        color: Colours.tPalette.m3surfaceContainer

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.width: 1
            border.color: stepper.accent
            opacity: 0.22
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 4
            spacing: -1

            StepArrow {
                Layout.alignment: Qt.AlignHCenter
                icon: "keyboard_arrow_up"
                enabled: stepper.value < stepper.to
                accent: stepper.accent
                onClicked: stepper.requested(Math.min(stepper.to, stepper.value + 1))
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: stepper.two(stepper.value)
                color: stepper.accent
                font.pointSize: Tokens.font.size.large
                font.family: Tokens.font.family.clock
                font.weight: 650
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: stepper.label
                color: Colours.palette.m3onSurfaceVariant
                font.pointSize: Tokens.font.size.small
                font.weight: 500
            }

            StepArrow {
                Layout.alignment: Qt.AlignHCenter
                icon: "keyboard_arrow_down"
                enabled: stepper.value > stepper.from
                accent: stepper.accent
                onClicked: stepper.requested(Math.max(stepper.from, stepper.value - 1))
            }
        }
    }

    component StepArrow: StyledRect {
        id: arrow

        signal clicked

        property string icon
        property color accent
        property bool enabled: true

        implicitWidth: 30
        implicitHeight: 16
        radius: height / 2
        color: arrow.accent
        opacity: arrow.enabled ? (hover.hovered ? 0.95 : 0.72) : 0.25

        MaterialIcon {
            anchors.centerIn: parent
            text: arrow.icon
            color: Colours.palette.m3onTertiary
            font.pointSize: Tokens.font.size.small
        }

        HoverHandler {
            id: hover
            enabled: arrow.enabled
        }

        TapHandler {
            enabled: arrow.enabled
            onTapped: arrow.clicked()
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
        implicitHeight: 36
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
                font.weight: 650
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
}
