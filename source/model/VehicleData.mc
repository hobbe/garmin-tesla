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

//! Represents the vehicle data from the Tesla API.
//! Only provides the fields necessary for the application.
class VehicleData {

    //! Initialize a vehicle data model based on the Tesla API response.
    function initialize(vehicle) {
        _name = "-";
        _isLocked = false;

        if (vehicle != null) {
            if (vehicle.hasKey("vehicle_name")) {
                _name = vehicle.get("vehicle_name");
            }
            if (vehicle.hasKey("locked")) {
                _isLocked = vehicle.get("locked");
            }
        }
    }

    //! Get the vehicle name.
    function getName() {
        return _name;
    }

    //! Returns true if the vehicle is locked, else false.
    function isLocked() {
        return _isLocked;
    }


    hidden var _name;
    hidden var _isLocked;
}