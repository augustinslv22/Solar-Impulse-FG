var canvas_hud = func {
    var width = 512;
    var height = 128;

    var window = canvas.create({
        "name": "SI2 HUD",
        "size": [width, height],
        "view": [width, height],
        "mipmapping": 1
    });

    window.set("visible", 1);
    window.set("transparency", 0.0);
    window.set("location", [0, 0]);

    var root = window.createGroup();

    var text = root.createChild("text");
    text.setFont("LiberationFonts/LiberationSans-Regular.ttf");
    text.setFontSize(20);
    text.setColor(1,1,1,1);
    text.setTranslation(10, 100);

    var update = func {
        var alt = getprop("/position/altitude-ft");
        var spd = getprop("/velocities/airspeed-kt");
        var hdg = getprop("/orientation/heading-deg");
        text.setText(sprintf("ALT: %.0f ft  SPD: %.0f kt  HDG: %.0f°", alt, spd, hdg));
    };

    settimer(update, 0.5);
};

setlistener("/sim/signals/nasal-dir-initialized", canvas_hud, 1);