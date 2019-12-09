using Toybox.WatchUi as Ui;

class OptionMenuDelegate extends Ui.MenuInputDelegate {
    var _controller;

    function initialize(controller) {
        Ui.MenuInputDelegate.initialize();
        _controller = controller;
    }

    function onMenuItem(item) {
        if (item == :reset) {
            _controller.resetToken();
        } else if (item == :honk) {
            _controller.honkHorn();
        } else if (item == :frunk) {
            _controller.openFrunk();
        } else if (item == :trunk) {
            _controller.openTrunk();
        } else if (item == :open_charge_port) {
            _controller.openChargePort();
        } else if (item == :close_charge_port) {
            _controller.closeChargePort();
        } else if (item == :unplug) {
            _controller.unplugVehicle();
        } else if (item == :toggle_units) {
            _controller.toggleUnits();
        }
    }
}
