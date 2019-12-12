class Tesla {
    hidden var _token;
    hidden var _callback;
    hidden const TESLA_API = "https://owner-api.teslamotors.com/api/1/vehicles/";


    function initialize(token) {
        if (token != null) {
            _token = "Bearer " + token;
        }
    }

    function getVehicleId(notify) {
        _genericGet(TESLA_API, notify);
    }

    function getClimateState(vehicle, notify) {
        var url = TESLA_API + vehicle.toString() + "/data_request/climate_state";
        _genericGet(url, notify);
    }

    function getChargeState(vehicle, notify) {
        var url = TESLA_API + vehicle.toString() + "/data_request/charge_state";
        _genericGet(url, notify);
    }

    function getVehicleState(vehicle, notify) {
        var url = TESLA_API + vehicle.toString() + "/data_request/vehicle_state";
        _genericGet(url, notify);
    }

    function wakeVehicle(vehicle, notify) {
        var url = TESLA_API + vehicle.toString() + "/wake_up";
        _genericPost(url, null, notify);
    }

    function climateOn(vehicle, notify) {
        var url = TESLA_API + vehicle.toString() + "/command/auto_conditioning_start";
        _genericPost(url, null, notify);
    }

    function climateOff(vehicle, notify) {
        var url = TESLA_API + vehicle.toString() + "/command/auto_conditioning_stop";
        _genericPost(url, null, notify);
    }

    function honkHorn(vehicle, notify) {
        var url = TESLA_API + vehicle.toString() + "/command/honk_horn";
        _genericPost(url, null, notify);
    }

    function flashLights(vehicle, notify) {
        var url = TESLA_API + vehicle.toString() + "/command/flash_lights";
        _genericPost(url, null, notify);
    }

    function doorUnlock(vehicle, notify) {
        var url = TESLA_API + vehicle.toString() + "/command/door_unlock";
        _genericPost(url, null, notify);
    }

    function doorLock(vehicle, notify) {
        var url = TESLA_API + vehicle.toString() + "/command/door_lock";
        _genericPost(url, null, notify);
    }

    //! Opens the front trunk (frunk).
    function openFrunk(vehicle, notify) {
        var url = TESLA_API + vehicle.toString() + "/command/actuate_trunk";
        var params = {
            "which_trunk" => "front"
        };
        _genericPost(url, params, notify);
    }

    //! Opens the rear trunk. On the Model S and X, it will also close the rear trunk.
    function actuateTrunk(vehicle, notify) {
        var url = TESLA_API + vehicle.toString() + "/command/actuate_trunk";
        var params = {
            "which_trunk" => "rear"
        };
        _genericPost(url, params, notify);
    }

    //! Opens the charge port door.
    function openChargePortDoor(vehicle, notify) {
        var url = TESLA_API + vehicle.toString() + "/command/charge_port_door_open";
        _genericPost(url, null, notify);
    }

    //! Close the charge port door for vehicles with a motorized charge port.
    function closeChargePortDoor(vehicle, notify) {
        var url = TESLA_API + vehicle.toString() + "/command/charge_port_door_close";
        _genericPost(url, null, notify);
    }

    //! If the car is currently charging, this will stop it.
    function stopCharge(vehicle, notify) {
        var url = TESLA_API + vehicle.toString() + "/command/charge_stop";
        _genericPost(url, null, notify);
    }

    //! Authenticate against the Tesla servers, request for a token which is
    //! returned as argument of the callback: notify(token)
    function authenticate(email, password, notify) {
        _callback = notify;
        var url = "https://owner-api.teslamotors.com/oauth/token/";
        var params = {
            "grant_type" => "password",
            "client_id" => "81527cff06843c8634fdc09e8ac0abefb46ac849f38fe1e431c2ef2106796384",
            "client_secret" => "c7257eb71a564034f9419ee651c7d0e5f7aa6bfbd18bafb5c5c033b093bb2fa3",
            "email" => email,
            "password" => password
        };

        Communications.makeWebRequest(
            url,
            params,
            {
                :method => Communications.HTTP_REQUEST_METHOD_POST,
                :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
            },
            method(:_onAuthenticateResult)
        );
    }

    function _onAuthenticateResult(responseCode, data) {
        var token = null;
        if (responseCode == 200) {
            token = data.get("access_token");
            System.println("Authentication token: " + token);
            _token = "Bearer " + data.get("access_token");
        } else {
            System.println("Authentication error: " + responseCode.toString());
        }
        if (_callback != null) {
            _callback.invoke(token);
        }
    }

    hidden function _genericGet(url, notify) {
        System.println("GET: " + url);
        Communications.makeWebRequest(
            url,
            null,
            {
                :method => Communications.HTTP_REQUEST_METHOD_GET,
                :headers => {
                    "Authorization" => _token
                },
                :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
            },
            notify
        );
    }

    hidden function _genericPost(url, params, notify) {
        System.println("POST: " + url);
        Communications.makeWebRequest(
            url,
            params,
            {
                :method => Communications.HTTP_REQUEST_METHOD_POST,
                :headers => {
                    "Authorization" => _token
                },
                :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
            },
            notify
        );
    }

}
