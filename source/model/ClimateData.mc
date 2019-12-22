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

//! Represents the climate data from the Tesla API.
//! Only provides the fields necessary for the application.
class ClimateData {

    //! Initialize a climate data model based on the Tesla API response.
    function initialize(climate) {
        _isValid = false;
        _isOn = false;
        _insideTemp = 0;

        if (climate != null) {
            _isValid = true;

            if (climate.hasKey("is_climate_on")) {
                _isOn = climate.get("is_climate_on");
            }
            if (climate.hasKey("inside_temp")) {
                _insideTemp = climate.get("inside_temp").toNumber();
            }
        }
    }

    //! Data model is valid
    function isValid() {
        return _isValid;
    }

    //! Returns true if the climate is on, else false.
    function isOn() {
        return _isOn;
    }

    //! Get the vehicle inside temperature in celcius
    function getInsideTemp() {
        return _insideTemp;
    }


    hidden var _isValid = false;
    hidden var _isOn;
    hidden var _insideTemp;
}