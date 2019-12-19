using Toybox.Application as Application;
using Toybox.System as System;

//! Settings utility.
module Settings {

    //! Store auth token
    function setToken(token) {
        var value = null;
        if (token != null) {
            value = token.toString();
        }
        Application.getApp().setProperty(TOKEN, value);
        System.println("Settings: token set to " + value);
    }

    //! Get auth token
    function getToken() {
        var value = _getStringProperty(TOKEN);
        System.println("Settings: token is " + value);
        return value;
    }

    //! Get Tesla account email
    function getEmail() {
        var value = _getStringProperty(EMAIL);
        System.println("Settings: account email is " + value);
        return value;
    }

    //! Get Tesla account password
    function getPassword() {
        var value = _getStringProperty(PASSWORD);
        System.println("Settings: account password is *****");
        return value;
    }

    //! Store the units for temperature, true if imperial (statute) else false (metric)
    function setImperialUnits(imperial) {
        Application.getApp().setProperty(IMPERIAL, imperial);
    }

    //! Get the units for temperature, true if imperial (statute) else false (metric)
    function isImperialUnits() {
        return _getBooleanProperty(IMPERIAL, System.getDeviceSettings().temperatureUnits == System.UNIT_STATUTE);
    }

    //! Store vehicle ID
    function setVehicleId(id) {
        var value = null;
        if (id != null) {
            value = id.toString();
        }
        Application.getApp().setProperty(VEHICLE, value);
        System.println("Settings: vehicle ID set to " + value);
    }

    //! Get vehicle ID
    function getVehicleId() {
        var value = _getStringProperty(VEHICLE);
        System.println("Settings: vehicle ID is " + value);
        return value;
    }

    function _getStringProperty(propertyName) {
        var value = Application.getApp().getProperty(propertyName);
        if (value == null || !(value instanceof Toybox.Lang.String) || "".equals(value)) {
            value = null;
        } else {
            value = value.toString();
        }
        return value;
    }

    function _getBooleanProperty(propertyName, defaultValue) {
        var app = Application.getApp();
        var value = app.getProperty(propertyName);

        if (value != null && value instanceof Toybox.Lang.Boolean) {
            return value;
        }

        // Else default value
        app.setProperty(propertyName, defaultValue);
        return defaultValue;
    }

    // Stored properties
    const IMPERIAL = "imperial";
    const VEHICLE = "vehicle";

    // Settings name, see resources/settings/settings.xml
    const TOKEN = "token";
    const EMAIL = "email";
    const PASSWORD = "password";

}
