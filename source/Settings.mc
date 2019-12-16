using Toybox.Application as Application;
using Toybox.System as System;

//! Settings utility.
module Settings {

    //! Store auth token
    function setToken(token) {
        Application.getApp().setProperty(TOKEN, token);
        System.println("Settings: token set to " + token);
    }

    //! Get auth token
    function getToken() {
        var value = _getStringProperty(TOKEN);
        System.println("Settings: token value is " + value);
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

    hidden function _getStringProperty(propertyName) {
        var value = Application.getApp().getProperty(propertyName);
        if (value == null || !(value instanceof Toybox.Lang.String) || "".equals(value)) {
            value = null;
        } else {
            value = value.toString();
        }
        return value;
    }

    // Settings name, see resources/settings/settings.xml
    const TOKEN = "token";
    const EMAIL = "email";
    const PASSWORD = "password";
}
