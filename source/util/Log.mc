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

using Toybox.Lang as Lang;
using Toybox.System as System;

//! Basic logging utility. Only supports DEBUG for now.
//! Check for log level before calling the API:
//!   if (Log.DEBUG) {
//!       Log.debug(message);
//!   }
module Log {

    const DEBUG = false;

    //! Writes a debug message on system console
    function debug(message) {
        if (DEBUG) {
            var clock = System.getClockTime();
            var msg = Lang.format("$1$:$2$:$3$ - $4$", [
                clock.hour.format("%02d"),
                clock.min.format("%02d"),
                clock.sec.format("%02d"),
                message
            ]);
            System.println(msg);
        }
    }

}
