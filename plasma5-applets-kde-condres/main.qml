import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.private.archUpdate 1.0

Item {
	SystemCalls {
		id: backend
	}
	id: main
	property string appName: "Condres Updater"
	property string version: "1.0"
	property int iconSize: units.iconSizes.smallMedium
	property int leftColumnWidth: iconSize + Math.round(units.gridUnit / 2)
	property string appletIcon: "archLogo.png"
	property int updatesPending: 0
	property var theModel: updateListModel
	property var namesOnly: plasmoid.configuration.hideVersion
	property var aurSupport: plasmoid.configuration.aurSupportFlag
	onNamesOnlyChanged: refresh()
	onAurSupportChanged: refresh()
	Plasmoid.icon: plasmoid.file("images", appletIcon)

	Plasmoid.compactRepresentation: CompactRepresentation {}

	Plasmoid.fullRepresentation: FullRepresentation {}

	PlasmaCore.DataSource {
		id: notificationSource
		engine: "notifications"
		connectedSources: "org.freedesktop.Notifications"
	}
	ListModel {
		id: updateListModel


	}

	//used to initialize start up
	Timer {
		interval: 10000
		running: true
		repeat: false
		onTriggered: refresh()
	}



	function refresh() {
			updateListModel.clear();
			var packageList;
			console.log("NAMES ONLY " + plasmoid.configuration.hideVersion);
			console.log("AUR SUPORT" + plasmoid.configuration.aurSupportFlag);
			//logic to show either names only, AUR, both or none
			backend.checkUpdates(plasmoid.configuration.hideVersion,plasmoid.configuration.aurSupportFlag);
			//append packages to full representation list
			packageList=backend.readCheckUpdates();
			for (var i = 0; i < packageList.length; i++) {
				updateListModel.append({"text": packageList[i]});
			}
			//counter on CompactRepresentation
			updatesPending = packageList.length;
		}
}
