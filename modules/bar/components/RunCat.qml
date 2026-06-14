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

    // runcat-text usa una fuente propia con 5 glyphs privados.
    readonly property var frames: ["\uE900", "\uE901", "\uE902", "\uE903", "\uE904"]

    // Similar a runcat-text: mínimo lento, máximo rápido.
    readonly property int fpsLow: 6
    readonly property int fpsHigh: 90
    readonly property real fps: fpsLow + (fpsHigh - fpsLow) * cpu
    readonly property int frameDuration: Math.max(16, Math.round(1000 / fps))

    readonly property color stateColour: cpuPercent >= 90
        ? Colours.palette.m3error
        : (cpuPercent >= 40
            ? Colours.palette.m3primary
            : Colours.palette.m3tertiary)

    property int frame: 0

    implicitWidth: Tokens.sizes.bar.innerWidth
    implicitHeight: Math.max(Tokens.sizes.bar.innerWidth, cat.implicitHeight + Tokens.padding.small)

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
        color: root.stateColour
        font.family: "runcat"
        font.pointSize: Tokens.font.size.extraLarge
        font.weight: 400
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        Behavior on color {
            Anim {
                type: Anim.StandardSmall
            }
        }
    }
}
