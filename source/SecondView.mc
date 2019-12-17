using Toybox.WatchUi as Ui;

class SecondView extends Ui.View {

    hidden const LabelVehicleName = "label_vehicle";
    hidden const LabelLocked = "label_locked";
    hidden const LabelCharge = "label_charge";
    hidden const LabelTemp = "label_temp";
    hidden const LabelClimate = "label_climate";

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

            var _vehicle = _data.getVehicle();
            if (_vehicle != null) {
                drawVehicleName(_vehicle.get("vehicle_name"));
                drawLockedStatus(_vehicle.get("locked"));
            }

            var _charge = _data.getCharge();
            drawBatteryLevel(_charge);

            var _climate = _data.getClimate();
            drawTemperature(_climate);
            drawClimateStatus(_climate);

            // Call the parent onUpdate function to redraw the layout
            View.onUpdate(dc);

            // Draw additional info on dc
            drawDefaultGauge(dc);
            if (_charge != null) {
                drawBatteryLevelGauge(dc, _charge);
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

    hidden function drawVehicleName(vehicleName) {
        var view = View.findDrawableById(LabelVehicleName);
        view.setText(vehicleName);
    }

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
        var radius = null;

        if (center_x < center_y) {
            radius = center_x-5;
        } else {
            radius = center_y-5;
        }

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
        dc.setPenWidth(5);
        dc.drawArc(center_x, center_y, radius, Graphics.ARC_CLOCKWISE, 180, 0);
    }

    //! Draw a half-arc gauge corresponding to the battery level
    hidden function drawBatteryLevelGauge(dc, charge) {
        var center_x = dc.getWidth()/2;
        var center_y = dc.getHeight()/2;
        var radius = null;

        if (center_x < center_y) {
            radius = center_x-5;
        } else {
            radius = center_y-5;
        }

        var batteryLevel = charge.get("battery_level");
        var requested_charge = charge.get("charge_limit_soc");
        var angle = (180 - (batteryLevel * 180 / 100)) % 360;

        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
        dc.drawArc(center_x, center_y, radius, Graphics.ARC_CLOCKWISE, 180, angle);

        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        angle = 180 - (requested_charge * 180 / 100);
        dc.drawArc(center_x, center_y, radius, Graphics.ARC_CLOCKWISE, angle-1, angle-4);
    }

    hidden function drawBatteryLevel(charge) {
        var view = View.findDrawableById(LabelCharge);

        if (charge != null) {
            var batteryLevel = charge.get("battery_level");
            var chargingState = charge.get("charging_state");

            if ("Charging".equals(chargingState)) {
                view.setColor(Graphics.COLOR_RED);
            }

            view.setText(Ui.loadResource(Rez.Strings.label_charge) + batteryLevel.toString() + "%");
        } else {
            view.setText(Ui.loadResource(Rez.Strings.label_charge) + "--%");
        }
    }

    hidden function drawTemperature(climate) {
        var view = View.findDrawableById(LabelTemp);

        if (climate != null) {
            var temp = climate.get("inside_temp").toNumber();

            var imperial = Application.getApp().getProperty("imperial");
            if (imperial) {
                temp = temp * 9 / 5;
                temp = temp + 32;
            }

            view.setText(Ui.loadResource(Rez.Strings.label_cabin) + temp.toString() + (imperial ? "°F" : "°C"));
         } else {
            view.setText(Ui.loadResource(Rez.Strings.label_cabin) + "-");
         }
    }

    hidden function drawClimateStatus(climate) {
        var view = View.findDrawableById(LabelClimate);

        if (climate != null) {
            // Climate status
            var on = climate.get("is_climate_on") ? Ui.loadResource(Rez.Strings.label_on) : Ui.loadResource(Rez.Strings.label_off);
            view.setText(Ui.loadResource(Rez.Strings.label_climate) + on);
        } else {
            view.setText(Ui.loadResource(Rez.Strings.label_climate) + "-");
        }
    }

}
