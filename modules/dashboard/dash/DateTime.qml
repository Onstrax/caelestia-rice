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
            Layout.bottomMargin: -(font.pointSize * 0.4)
            Layout.alignment: Qt.AlignHCenter
            text: Time.hourStr
            color: Colours.palette.m3primary
            font: Tokens.font.clock.size(28).weight(Font.DemiBold).build()
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: "•••"
            color: Colours.palette.m3tertiary
            font: Tokens.font.clock.size(28 * 0.9).build()
        }

        StyledText {
            Layout.topMargin: -(font.pointSize * 0.4)
            Layout.alignment: Qt.AlignHCenter
            text: Time.minuteStr
            color: Colours.palette.m3secondary
            font: Tokens.font.clock.size(28).weight(Font.DemiBold).build()
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Tokens.spacing.extraSmall
            text: "•"
            color: Colours.palette.m3tertiary
            font: Tokens.font.clock.size(16).weight(Font.DemiBold).build()
        }

        StyledRect {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: -Tokens.spacing.extraSmall
            implicitWidth: secondsText.implicitWidth + Tokens.padding.medium
            implicitHeight: secondsText.implicitHeight + Tokens.padding.extraSmall
            radius: height / 2
            color: Colours.palette.m3tertiary

            StyledText {
                id: secondsText

                anchors.centerIn: parent
                text: Time.format("ss")
                color: Colours.palette.m3onTertiary
                font: Tokens.font.clock.size(12).weight(Font.Bold).build()
            }
        }

        Loader {
            asynchronous: true
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Tokens.spacing.extraSmall

            active: GlobalConfig.services.useTwelveHourClock
            visible: active

            sourceComponent: StyledText {
                text: Time.amPmStr
                color: Colours.palette.m3primary
                font: Tokens.font.clock.size(18).weight(Font.DemiBold).build()
            }
        }
    }
}
