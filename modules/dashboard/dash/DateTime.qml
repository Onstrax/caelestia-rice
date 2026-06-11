pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services

Item {
    id: root

    anchors.top: parent.top
    anchors.bottom: parent.bottom
    implicitWidth: Tokens.sizes.dashboard.dateTimeWidth

    StyledRect {
        id: clockCard

        anchors.centerIn: parent
        width: Math.max(72, parent.width - Tokens.padding.small)
        implicitHeight: clockColumn.implicitHeight + Tokens.padding.normal * 2
        radius: Tokens.rounding.large * 1.5
        color: Colours.tPalette.m3surfaceContainer

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: parent.radius - 1
            color: "transparent"
            border.width: 1
            border.color: Colours.palette.m3primary
            opacity: 0.18
        }

        ColumnLayout {
            id: clockColumn

            anchors.centerIn: parent
            width: parent.width
            spacing: -2

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: Time.hourStr
                color: Colours.palette.m3secondary
                font.pointSize: Tokens.font.size.extraLarge
                font.family: Tokens.font.family.clock
                font.weight: 700
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: -(font.pointSize * 0.40)
                Layout.bottomMargin: -(font.pointSize * 0.45)
                text: "⋮"
                color: Colours.palette.m3primary
                font.pointSize: Tokens.font.size.extraLarge
                font.family: Tokens.font.family.clock
                font.weight: 700
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: Time.minuteStr
                color: Colours.palette.m3secondary
                font.pointSize: Tokens.font.size.extraLarge
                font.family: Tokens.font.family.clock
                font.weight: 700
            }

            StyledRect {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: Tokens.spacing.small
                implicitWidth: secondsText.implicitWidth + Tokens.padding.normal
                implicitHeight: secondsText.implicitHeight + Tokens.padding.small
                radius: height / 2
                color: Colours.palette.m3primary

                StyledText {
                    id: secondsText

                    anchors.centerIn: parent
                    text: Time.format("ss")
                    color: Colours.palette.m3onPrimary
                    font.pointSize: Tokens.font.size.small
                    font.family: Tokens.font.family.clock
                    font.weight: 800
                }
            }

            Loader {
                asynchronous: true
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: Tokens.spacing.small

                active: GlobalConfig.services.useTwelveHourClock
                visible: active

                sourceComponent: StyledText {
                    text: Time.amPmStr
                    color: Colours.palette.m3primary
                    font.pointSize: Tokens.font.size.small
                    font.family: Tokens.font.family.clock
                    font.weight: 700
                }
            }
        }
    }
}
