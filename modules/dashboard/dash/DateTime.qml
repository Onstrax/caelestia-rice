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

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        StyledText {
            Layout.bottomMargin: -(font.pointSize * 0.35)
            Layout.alignment: Qt.AlignHCenter
            text: Time.hourStr
            color: Colours.palette.m3primary
            font.pointSize: Tokens.font.size.extraLarge
            font.family: Tokens.font.family.clock
            font.weight: 650
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: "••"
            color: Colours.palette.m3tertiary
            font.pointSize: Tokens.font.size.extraLarge * 0.75
            font.family: Tokens.font.family.clock
            font.weight: 650
        }

        StyledText {
            Layout.topMargin: -(font.pointSize * 0.35)
            Layout.bottomMargin: -(font.pointSize * 0.25)
            Layout.alignment: Qt.AlignHCenter
            text: Time.minuteStr
            color: Colours.palette.m3secondary
            font.pointSize: Tokens.font.size.extraLarge
            font.family: Tokens.font.family.clock
            font.weight: 650
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: "•"
            color: Colours.palette.m3tertiary
            font.pointSize: Tokens.font.size.large
            font.family: Tokens.font.family.clock
            font.weight: 650
        }

        StyledRect {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: -(Tokens.spacing.small / 2)
            implicitWidth: secondsText.implicitWidth + Tokens.padding.normal
            implicitHeight: secondsText.implicitHeight + Tokens.padding.small
            radius: height / 2
            color: Colours.palette.m3tertiary

            StyledText {
                id: secondsText

                anchors.centerIn: parent
                text: Time.format("ss")
                color: Colours.palette.m3onTertiary
                font.pointSize: Tokens.font.size.small
                font.family: Tokens.font.family.clock
                font.weight: 750
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
                font.weight: 650
            }
        }
    }
}
