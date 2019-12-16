class TeslaData {

    function getCharge() {
        return _charge;
    }

    function setCharge(charge) {
        _charge = charge;
    }

    function getClimate() {
        return _climate;
    }

    function setClimate(climate) {
        _climate = climate;
    }

    function getVehicle() {
        return _vehicle;
    }

    function setVehicle(vehicle) {
        _vehicle = vehicle;
    }


    hidden var _charge;
    hidden var _climate;
    hidden var _vehicle;
}