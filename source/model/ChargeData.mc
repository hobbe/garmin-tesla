//! The MIT License (MIT)
//!
//! Copyright (c) 2019 Olivier Bagot
//!
//! Permission is hereby granted, free of charge, to any person obtaining a copy of
//! this software and associated documentation files (the "Software"), to deal in
//! the Software without restriction, including without limitation the rights to
//! use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//! the Software, and to permit persons to whom the Software is furnished to do so,
//! subject to the following conditions:
//!
//! The above copyright notice and this permission notice shall be included in all
//! copies or substantial portions of the Software.
//!
//! THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//! IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//! FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//! COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//! IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//! CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//! Represents the charge data from the Tesla API.
//! Only provides the fields necessary for the application.
class ChargeData {

    //! Initialize a charge data model based on the Tesla API response.
    function initialize(charge) {
        _isValid = false;
        _batteryLevel = 0;
        _chargeLimitSoc = 100;
        _isCharging = false;

        if (charge != null) {
            _isValid = true;

            if (charge.hasKey("battery_level")) {
                _batteryLevel = charge.get("battery_level");
            }
            if (charge.hasKey("charge_limit_soc")) {
                _chargeLimitSoc = charge.get("charge_limit_soc");
            }
            if (charge.hasKey("charging_state")) {
                _isCharging = "Charging".equals(charge.get("charging_state"));
            }
        }
    }

    //! Data model is valid
    function isValid() {
        return _isValid;
    }

    //! Returns true if the vehicle is charging, else false.
    function isCharging() {
        return _isCharging;
    }

    //! Get the vehicle battery level.
    function getBatteryLevel() {
        return _batteryLevel;
    }

    //! Get the vehicle charge limit SOC.
    function getChargeLimitSoc() {
        return _chargeLimitSoc;
    }


    hidden var _isValid = false;
    hidden var _isCharging;
    hidden var _batteryLevel;
    hidden var _chargeLimitSoc;
}