var debug = {
    enable_free_flight: func {
        setprop("/controls/flight/aileron", 0);
        setprop("/controls/flight/elevator", 0);
        setprop("/controls/flight/rudder", 0);
        setprop("/controls/engines/engine[0]/throttle", 1);
        print("Vol libre activé.");
    },

    teleport: func(lat, lon, alt_ft) {
        setprop("/position/latitude-deg", lat);
        setprop("/position/longitude-deg", lon);
        setprop("/position/altitude-ft", alt_ft);
        print(sprintf("Téléportation vers %.4f, %.4f à %.0f ft", lat, lon, alt_ft));
    }
};

setlistener("/sim/signals/nasal-dir-initialized", func { debug.enable_free_flight(); }, 1);
