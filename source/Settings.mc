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
        var value = Application.getApp().getProperty(TOKEN);
        if (value == "") {
            value = null;
        }
        System.println("Settings: token value is " + value);
        return value;
    }

    //! Get Tesla account email
    function getEmail() {
        var value = Application.getApp().getProperty(EMAIL);
        System.println("Settings: account email is " + value);
        return value;
    }

    //! Get Tesla account password
    function getPassword() {
        var value = Application.getApp().getProperty(PASSWORD);
        System.println("Settings: account password is *****");
        return value;
    }


    // Settings name, see resources/settings/settings.xml
    const TOKEN = "token";
    const EMAIL = "email";
    const PASSWORD = "password";
}
