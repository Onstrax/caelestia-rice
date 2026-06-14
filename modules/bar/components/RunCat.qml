pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services

Item {
    id: root

    readonly property real cpu: Math.max(0, Math.min(1, SystemUsage.cpuPerc || 0))
    readonly property int cpuPercent: Math.round(cpu * 100)

    readonly property var frames: ["\uE900", "\uE901", "\uE902", "\uE903", "\uE904"]
    readonly property int fpsLow: 6
    readonly property int fpsHigh: 90
    readonly property real fps: fpsLow + (fpsHigh - fpsLow) * cpu
    readonly property int frameDuration: Math.max(16, Math.round(1000 / fps))

    property int frame: 0

    implicitWidth: Tokens.sizes.bar.innerWidth
    implicitHeight: Math.max(Tokens.sizes.bar.innerWidth, cat.implicitHeight + Tokens.padding.large)

    Component.onCompleted: SystemUsage.refCount++
    Component.onDestruction: SystemUsage.refCount--

    Timer {
        interval: root.frameDuration
        repeat: true
        running: true
        onTriggered: root.frame = (root.frame + 1) % root.frames.length
    }

    StyledText {
        id: cat

        anchors.centerIn: parent
        text: root.frames[root.frame]

        // Blanco para contrastar con el fondo oscuro de la barra.
        color: Colours.palette.m3onSurface

        font.family: "runcat"
        font.pointSize: Tokens.font.size.extraLarge * 1.85
        font.weight: 400
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        opacity: root.cpuPercent >= 90 ? 1 : 0.92
    }
}
