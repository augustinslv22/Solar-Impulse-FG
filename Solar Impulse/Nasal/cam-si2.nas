var cam = {
    offset: [0, 0, 0], # x, y, z en mètres

    init: func {
        setprop("/sim/view/config/offset-x-m", cam.offset[0]);
        setprop("/sim/view/config/offset-y-m", cam.offset[1]);
        setprop("/sim/view/config/offset-z-m", cam.offset[2]);
        print("Caméra personnalisée SI2 initialisée.");
    },

    set_offset: func(x, y, z) {
        cam.offset = [x, y, z];
        cam.init();
    }
};

setlistener("/sim/signals/nasal-dir-initialized", func { cam.init(); }, 1);