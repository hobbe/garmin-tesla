using Toybox.WatchUi as Ui;
using Toybox.Timer;
using Toybox.Communications as Communications;

class SecondDelegate extends Ui.BehaviorDelegate {
    hidden var _dummy_mode;
    hidden var _handler;
    hidden var _token;
    hidden var _tesla;
    hidden var _sleep_timer;
    hidden var _vehicle_id;
    hidden var _need_wake;
    hidden var _wake_done;

    hidden var _get_climate;
    hidden var _set_climate_on;
    hidden var _set_climate_off;
    hidden var _get_charge;
    hidden var _get_vehicle;
    hidden var _flash_lights;
    hidden var _honk_horn;
    hidden var _open_frunk;
    hidden var _open_trunk;
    hidden var _unlock;
    hidden var _lock;
    hidden var _open_charge_port;
    hidden var _close_charge_port;
    hidden var _stop_charge;

    hidden var _data;

    function initialize(data, handler) {
        BehaviorDelegate.initialize();
        _dummy_mode = false;
        _data = data;
        _token = Settings.getToken();
        _vehicle_id = Settings.getVehicleId();
        _sleep_timer = new Timer.Timer();
        _handler = handler;
        _tesla = null;

        _need_wake = false;
        _wake_done = true;

        _set_climate_on = false;
        _set_climate_off = false;
        _get_climate = true;
        _get_charge = true;
        _get_vehicle = true;
        _honk_horn = false;
        _open_frunk = false;
        _open_trunk = false;
        _unlock = false;
        _lock = false;
        _open_charge_port = false;
        _close_charge_port = false;
        _stop_charge = false;

        if(_dummy_mode) {
            _data.setVehicle({
                "vehicle_name" => "Janet"
            });
            _data.setCharge({
                "battery_level" => 65,
                "charge_limit_soc" => 80
            });
            _data.setClimate({
                "inside_temp" => 25,
                "is_climate_on" => true
            });
        }
        _stateMachine();
    }

    //! Scenario to reset the authentication token.
    function resetToken() {
        Settings.setToken(null);
        Settings.setVehicleId(null);
    }

    //! Scenario to toggle temperature units from °C to °F.
    function toggleUnits() {
        Settings.setImperialUnits(!Settings.isImperialUnits());
    }

    //! Scenario to honk the horn.
    function honkHorn() {
        _honk_horn = true;
        _stateMachine();
     }

    //! Scenario to flash the lights.
    function flashLights() {
        _flash_lights = true;
        _stateMachine();
     }

    //! Scenario to turn climate on or off.
    function toggleClimate() {
        var climate = _data.getClimate();
        if (climate != null && !climate.isOn()) {
            _set_climate_on = true;
        } else {
            _set_climate_off = true;
        }
        _stateMachine();
    }

    //! Scenario to lock or unlock the doors.
    function toggleDoorLock() {
        var vehicle = _data.getVehicle();
        if (vehicle != null && !vehicle.get("locked")) {
            _lock = true;
        } else {
            _unlock = true;
        }
        _stateMachine();
    }

    //! Scenario to open the frunk (front trunk).
    function openFrunk() {
        _open_frunk = true;
        _stateMachine();
     }

    //! Scenario to open the rear trunk.
    function openTrunk() {
        _open_trunk = true;
        _stateMachine();
     }

    //! Scenario to open the charge port door.
    function openChargePort() {
        _open_charge_port = true;
        _stateMachine();
     }

    //! Scenario to close the charge port door.
    function closeChargePort() {
        _close_charge_port = true;
        _stateMachine();
     }

    //! Scenario to unplug the vehicle, which means:
    //!   - Stop the charge
    //!   - Unlock the doors
    //!   - Open the trunk to store the cable
    //!   - Open the charge port door
    function unplugVehicle() {
        _stop_charge = true;
        _unlock = true;
        _open_trunk = true;
        _open_charge_port = true;
        _stateMachine();
    }

    hidden function _stateMachine() {
        if(_dummy_mode) {
            _handler.invoke(null);
            return;
        }

        if (_token == null) {
            var email = Settings.getEmail();
            var password = Settings.getPassword();

            if (email != null && password != null) {
                // Use Tesla authenticate API
                _tesla = new Tesla(null);
                _tesla.authenticate(email, password, method(:onAuthentication));
            } else {
                // Use custom web site for authentication
                _handler.invoke(Ui.loadResource(Rez.Strings.label_login_on_phone));
                Communications.registerForOAuthMessages(method(:onOAuthMessage));
                Communications.makeOAuthRequest(
                    "https://dasbrennen.org/tesla/tesla.html",
                    {},
                    "https://dasbrennen.org/tesla/tesla-done.html",
                    Communications.OAUTH_RESULT_TYPE_URL,
                    {
                        "responseCode" => "OAUTH_CODE",
                        "responseError" => "OAUTH_ERROR"
                    }
                );
            }

            return;
        }

        if (_tesla == null) {
            _tesla = new Tesla(_token);
        }

        if (_vehicle_id == null) {
            _handler.invoke(Ui.loadResource(Rez.Strings.label_getting_vehicles));
            _tesla.getVehicleId(method(:onReceiveVehicles));
            return;
        }

        if (_need_wake) {
            _need_wake = false;
            _wake_done = false;
            _handler.invoke(Ui.loadResource(Rez.Strings.label_waking_vehicle));
            _tesla.wakeVehicle(_vehicle_id, method(:onReceiveAwake));
            return;
        }

        if (!_wake_done) {
            return;
        }

        if (_get_vehicle) {
            _get_vehicle = false;
            _tesla.getVehicleState(_vehicle_id, method(:onReceiveVehicle));
        }

        if (_get_climate) {
            _get_climate = false;
            _tesla.getClimateState(_vehicle_id, method(:onReceiveClimate));
        }

        if (_get_charge) {
            _get_charge = false;
            _tesla.getChargeState(_vehicle_id, method(:onReceiveCharge));
        }

        if (_stop_charge) {
            _stop_charge = false;
            _handler.invoke(Ui.loadResource(Rez.Strings.label_charge_stopped));
            _tesla.stopCharge(_vehicle_id, method(:genericHandler));
        }

        if (_set_climate_on) {
            _set_climate_on = false;
            _handler.invoke(Ui.loadResource(Rez.Strings.label_hvac_on));
            _tesla.climateOn(_vehicle_id, method(:onClimateDone));
        }

        if (_set_climate_off) {
            _set_climate_off = false;
            _handler.invoke(Ui.loadResource(Rez.Strings.label_hvac_off));
            _tesla.climateOff(_vehicle_id, method(:onClimateDone));
        }

        if (_flash_lights) {
            _flash_lights = false;
            _handler.invoke(Ui.loadResource(Rez.Strings.label_lights_flashed));
            _tesla.flashLights(_vehicle_id, method(:genericHandler));
        }

        if (_honk_horn) {
            _honk_horn = false;
            _handler.invoke(Ui.loadResource(Rez.Strings.label_honk));
            _tesla.honkHorn(_vehicle_id, method(:genericHandler));
        }

        if (_unlock) {
            _unlock = false;
            _handler.invoke(Ui.loadResource(Rez.Strings.label_unlock_doors));
            _tesla.doorUnlock(_vehicle_id, method(:onLockDone));
        }

        if (_lock) {
            _lock = false;
            _handler.invoke(Ui.loadResource(Rez.Strings.label_lock_doors));
            _tesla.doorLock(_vehicle_id, method(:onLockDone));
        }

        if (_open_frunk) {
            _open_frunk = false;
            var view = new Ui.Confirmation(Ui.loadResource(Rez.Strings.label_open_frunk));
            var delegate = new SimpleConfirmDelegate(method(:frunkConfirmed));
            Ui.pushView(view, delegate, Ui.SLIDE_UP);
        }

        if (_open_trunk) {
            _open_trunk = false;
            _handler.invoke(Ui.loadResource(Rez.Strings.label_trunk));
            _tesla.actuateTrunk(_vehicle_id, method(:genericHandler));
        }

        if (_open_charge_port) {
            _open_charge_port = false;
            _handler.invoke(Ui.loadResource(Rez.Strings.label_charge_port_opened));
            _tesla.openChargePortDoor(_vehicle_id, method(:genericHandler));
        }

        if (_close_charge_port) {
            _close_charge_port = false;
            _handler.invoke(Ui.loadResource(Rez.Strings.label_charge_port_closed));
            _tesla.closeChargePortDoor(_vehicle_id, method(:genericHandler));
        }
    }

    function frunkConfirmed() {
        _handler.invoke(Ui.loadResource(Rez.Strings.label_frunk));
        _tesla.openFrunk(_vehicle_id, method(:genericHandler));
    }

    function delayedWake() {
        _need_wake = true;
        _stateMachine();
    }

    //! When select button is pressed or screen is touched
    function onSelect() {
        toggleClimate();
        return true;
    }

    //! When down button is pressed or screen is swipped up
    function onNextPage() {
        toggleDoorLock();
        return true;
    }

    //! When up button is pressed or screen is swipped down
    function onPreviousPage() {
        openFrunk();
        return true;
    }

    //! When back button is pressed or screen is swipped right
    function onBack() {
        Ui.popView(Ui.SLIDE_DOWN);
        return true;
    }

    //! When up button is long-pressed or screen is long-touched
    function onMenu() {
        Ui.pushView(new Rez.Menus.OptionMenu(), new OptionMenuDelegate(self), Ui.SLIDE_UP);
        return true;
    }

    function onReceiveVehicles(responseCode, data) {
        if (responseCode == 200) {
            System.println("Got vehicles");
            _vehicle_id = data.get("response")[0].get("id");
            Settings.setVehicleId(_vehicle_id);
            _stateMachine();
        } else {
            _handleErrorResponse("onReceiveVehicles", responseCode, false, _handler);
            if (responseCode == 408) {
                _stateMachine();
            }
        }
    }

    function onReceiveVehicle(responseCode, data) {
        if (responseCode == 200) {
            var vehicle = new VehicleData(data.get("response"));
            System.println("Got vehicle");
            _data.setVehicle(vehicle);
            _handler.invoke(null);
        } else {
            _handleErrorResponse("onReceiveVehicle", responseCode, true, _handler);
        }
    }

    function onReceiveClimate(responseCode, data) {
        if (responseCode == 200) {
            var climate = new ClimateData(data.get("response"));
            _data.setClimate(climate);
            if (climate.isValid()) {
                System.println("Got climate: " + climate.getInsideTemp() + "C " + (climate.isOn() ? "(on)" : "(off)"));
                _handler.invoke(null);
            } else {
                _wake_done = false;
                _sleep_timer.start(method(:delayedWake), 500, false);
            }
        } else {
            _handleErrorResponse("onReceiveClimate", responseCode, true, _handler);
        }
    }

    function onReceiveCharge(responseCode, data) {
        if (responseCode == 200) {
            var charge = new ChargeData(data.get("response"));
            _data.setCharge(charge);
            if (charge.isValid()) {
                System.println("Got charge: " + (charge.isCharging() ? "on" : "off") + " " + charge.getBatteryLevel() + "/" + charge.getChargeLimitSoc() + "%");
                _handler.invoke(null);
            } else {
                _wake_done = false;
                _sleep_timer.start(method(:delayedWake), 500, false);
            }
        } else {
            _handleErrorResponse("onReceiveCharge", responseCode, true, _handler);
        }
    }

    function onReceiveAwake(responseCode, data) {
        if (responseCode == 200) {
            _wake_done = true;
            _get_vehicle = true;
            _get_climate = true;
            _get_charge = true;
            _stateMachine();
        } else {
            _handleErrorResponse("onReceiveAwake", responseCode, true, _handler);
        }
    }

    function onClimateDone(responseCode, data) {
        if (responseCode == 200) {
            _get_climate = true;
            _handler.invoke(null);
            _stateMachine();
        } else {
            _handleErrorResponse("onClimateDone", responseCode, false, _handler);
        }
    }

    function onLockDone(responseCode, data) {
        if (responseCode == 200) {
            _get_vehicle = true;
            _handler.invoke(null);
            _stateMachine();
        } else {
            _handleErrorResponse("onLockDone", responseCode, false, _handler);
        }
    }

    function genericHandler(responseCode, data) {
        if (responseCode == 200) {
            _handler.invoke(null);
            _stateMachine();
        } else {
            _handleErrorResponse("genericHandler", responseCode, false, _handler);
        }
    }

    function onAuthentication(token) {
        _handleAuthenticationResponse(token);
    }

    function onOAuthMessage(message) {
        var token = null;
        if (message != null && message.data != null) {
            token = message.data["OAUTH_CODE"];
        }
        _handleAuthenticationResponse(token);
    }

    function _handleAuthenticationResponse(token) {
        if (token != null) {
            _saveToken(token);
            _stateMachine();
        } else {
            _resetToken();
            _handler.invoke(Ui.loadResource(Rez.Strings.label_oauth_error));
        }
    }

    function _handleErrorResponse(methodName, responseCode, retryOnTimeout, handler) {
        System.println(methodName + " - Error " + responseCode.toString());
        if (responseCode == -101) {
            // BLE_QUEUE_FULL
            handler.invoke(Ui.loadResource(Rez.Strings.label_error__101));
            return;
        }
        if (responseCode == -103) {
            // BLE_UNKNOWN_SEND_ERROR
            handler.invoke(Ui.loadResource(Rez.Strings.label_error__103));
            return;
        }
        if (responseCode == -104) {
            // BLE_CONNECTION_UNAVAILABLE
            handler.invoke(Ui.loadResource(Rez.Strings.label_error__104));
            return;
        }
        if (responseCode == -403) {
            // NETWORK_RESPONSE_OUT_OF_MEMORY
            handler.invoke(Ui.loadResource(Rez.Strings.label_error__403));
            return;
        }
        if (responseCode == 401) {
            // Unauthorized
            _resetToken();
            handler.invoke(Ui.loadResource(Rez.Strings.label_error_401));
            return;
        }
        if (responseCode == 404) {
            // Not Found
            handler.invoke(Ui.loadResource(Rez.Strings.label_error_404));
            return;
        }
        if (responseCode == 408) {
            // Request Timeout
            if (retryOnTimeout) {
                _wake_done = false;
                _sleep_timer.start(method(:delayedWake), 500, false);
            } else {
                handler.invoke(Ui.loadResource(Rez.Strings.label_error_408));
            }
            return;
        }
        handler.invoke(Ui.loadResource(Rez.Strings.label_error) + responseCode.toString());
    }

    hidden function _saveToken(token) {
        _token = token;
        Settings.setToken(token);
    }

    hidden function _resetToken() {
        _token = null;
        Settings.setToken(null);
    }

}