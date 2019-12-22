using Toybox.WatchUi as Ui;

class SecondView extends Ui.View {

    hidden const LabelVehicleName = "vehicle";
    hidden const LabelLocked = "locked";
    hidden const LabelCharge = "charge";
    hidden const LabelTemp = "temp";
    hidden const LabelClimate = "climate";

    hidden var _display;
    hidden var _data;

    function initialize(data) {
        View.initialize();
        _data = data;
        _display = Ui.loadResource(Rez.Strings.label_requesting_data);
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.TeslaLayout(dc));
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        var view = null;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        if (_display != null) {
            // Informative message
            var center_x = dc.getWidth()/2;
            var center_y = dc.getHeight()/2;
            dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_BLACK);
            dc.drawText(center_x, center_y, Graphics.FONT_SMALL, _display, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        } else {
            // Tesla layout

            var vehicle = _data.getVehicle();
            if (vehicle != null) {
                drawVehicleName(vehicle.getName());
                drawLockedStatus(vehicle.isLocked());
            }

            var charge = _data.getCharge();
            drawBatteryLevel(charge);

            var climate = _data.getClimate();
            drawTemperature(climate);
            drawClimateStatus(climate);

            // Call the parent onUpdate function to redraw the layout
            View.onUpdate(dc);

            // Draw additional info on dc
            drawDefaultGauge(dc);
            if (charge != null) {
                drawBatteryLevelGauge(dc, charge);
            }
        }
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

    function onReceive(args) {
        _display = args;
        WatchUi.requestUpdate();
    }

    //! Fill in vehicle name field
    hidden function drawVehicleName(vehicleName) {
        var view = View.findDrawableById(LabelVehicleName);
        view.setText(vehicleName);
    }

    //! Fill in status of door locking
    hidden function drawLockedStatus(locked) {
        var view = View.findDrawableById(LabelLocked);
        if (locked) {
            view.setColor(Graphics.COLOR_GREEN);
            view.setText(Ui.loadResource(Rez.Strings.label_locked));
        } else {
            view.setColor(Graphics.COLOR_RED);
            view.setText(Ui.loadResource(Rez.Strings.label_unlocked));
        }
    }

    //! Draw a half-arc representing the battery gauge
    hidden function drawDefaultGauge(dc) {
        var center_x = dc.getWidth()/2;
        var center_y = dc.getHeight()/2;
        var radius = calculateRadius(center_x, center_y);

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
        dc.setPenWidth(5);
        dc.drawArc(center_x, center_y, radius, Graphics.ARC_CLOCKWISE, 180, 0);
    }

    //! Draw a half-arc gauge corresponding to the battery level
    hidden function drawBatteryLevelGauge(dc, charge) {
        var center_x = dc.getWidth()/2;
        var center_y = dc.getHeight()/2;
        var radius = calculateRadius(center_x, center_y);

        var batteryLevel = charge.getBatteryLevel();
        var angle = calculateAngle(batteryLevel);
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
        dc.drawArc(center_x, center_y, radius, Graphics.ARC_CLOCKWISE, 180, angle);

        var requestedCharge = charge.getChargeLimitSoc();
        angle = calculateAngle(requestedCharge);
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        dc.drawArc(center_x, center_y, radius, Graphics.ARC_CLOCKWISE, angle-1, angle-4);
    }

    //! Fill in the battery level field
    hidden function drawBatteryLevel(charge) {
        var view = View.findDrawableById(LabelCharge);

        if (charge != null) {
            var batteryLevel = charge.getBatteryLevel();

            if (charge.isCharging()) {
                view.setColor(Graphics.COLOR_RED);
            }

            view.setText(Ui.loadResource(Rez.Strings.label_charge) + batteryLevel.toString() + "%");
        } else {
            view.setText(Ui.loadResource(Rez.Strings.label_charge) + "--%");
        }
    }

    //! Fill in the temperature field
    hidden function drawTemperature(climate) {
        var view = View.findDrawableById(LabelTemp);

        if (climate != null) {
            var insideTemp = climate.getInsideTemp();

            var imperial = Settings.isImperialUnits();
            if (imperial) {
                insideTemp = (insideTemp * 9 / 5) + 32;
            }

            view.setText(Ui.loadResource(Rez.Strings.label_cabin) + insideTemp.toString() + (imperial ? "°F" : "°C"));
         } else {
            view.setText(Ui.loadResource(Rez.Strings.label_cabin) + "-");
         }
    }

    //! Fill in the climate status field
    hidden function drawClimateStatus(climate) {
        var view = View.findDrawableById(LabelClimate);

        if (climate != null) {
            var on = climate.isOn() ? Ui.loadResource(Rez.Strings.label_on) : Ui.loadResource(Rez.Strings.label_off);
            view.setText(Ui.loadResource(Rez.Strings.label_climate) + on);
        } else {
            view.setText(Ui.loadResource(Rez.Strings.label_climate) + "-");
        }
    }

    hidden function calculateRadius(x, y) {
        return (x < y) ? x-2 : y-2;
    }

    hidden function calculateAngle(value) {
        return (180 - (value * 180 / 100)) % 360;
    }
}
