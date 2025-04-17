# Initialisation du groupe pour les contrôles (ex : Heading Control, etc)
var hdg = null;
var vel = null;
var alt = null;

# Créer un groupe d'AP pour gérer les différentes commandes
Group = {
  new: func(name, options) {
    var m = { parents: [Group] };
    m.name = name;
    m.enabled = 0;
    m.mode = options[0];
    m.options = [];
    var locks = props.globals.getNode("/autopilot/locks", 1);
    if (locks.getNode(name) == nil or locks.getNode(name, 1).getValue() == nil) {
      locks.getNode(name, 1).setValue("");
    }
    m.lock = locks.getNode(name);
    m.active = dlg.getNode(name ~ "-active", 1);
    
    foreach (var o; options) {
      var node = dlg.getNode(o);
      if (node == nil) {
        node = dlg.getNode(o, 1);
        node.setBoolValue(0);
      }
      append(m.options, node);
      if (m.lock.getValue() == o) {
        m.mode = o;
      }
    }
    
    m.listener = setlistener(m.lock, func(n) { m.update(n.getValue()) }, 1);
    return m;
  },
  
  del: func {
    removelistener(me.listener);
  },

  # Activer / Désactiver le groupe
  enable: func {
    me.enabled = me.active.getBoolValue();
    me.lock.setValue(me.enabled ? me.mode : "");
  },
  
  # Changer l'état d'un mode spécifique
  set: func(mode) {
    me.mode = mode;
    foreach (var o; me.options) {
      o.setBoolValue(o.getName() == mode);
    }
    if (me.enabled) {
      me.lock.setValue(mode);
    }
  },
  
  # Mettre à jour les options du groupe
  update: func(mode) {
    me.enabled = (mode != "");
    me.active.setBoolValue(me.enabled);
    if (mode == "") {
      mode = me.mode;
    }
    foreach (var o; me.options) {
      o.setBoolValue(o.getName() == mode);
    }
  }
};

# Initialiser les groupes d'AP
hdg = Group.new("heading", ["dg-heading-hold", "wing-leveler", "true-heading-hold", "nav1-hold"]);
vel = Group.new("speed", ["speed-with-throttle"]);
alt = Group.new("altitude", ["altitude-hold", "vertical-speed-hold", "pitch-hold", "agl-hold", "gs1-hold"]);

# Fermer les groupes quand on quitte
var dlg = props.globals.getNode("/sim/gui/dialogs/autopilot", 1);
hdg.del();
vel.del();
alt.del();
