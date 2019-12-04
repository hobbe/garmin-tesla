class Tesla {
    hidden var _token;
    hidden var _notify;
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


    //function authCallback(responseCode, data) {
    //    if (responseCode == 200) {
    //        Application.getApp().setProperty("token", data.get("access_token"));
    //        _token = "Bearer " + data.get("access_token");
    //    }
    //    _notify.invoke(responseCode, data);
    //}
}
