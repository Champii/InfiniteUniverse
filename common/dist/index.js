// Generated by LiveScript 1.4.0
(function(){
  var Player, Planet, Entity, Research, Building, Mine, player, planet, metalmine;
  Player = (function(){
    Player.displayName = 'Player';
    var prototype = Player.prototype, constructor = Player;
    function Player(id, username){
      this.id = id;
      this.username = username;
    }
    return Player;
  }());
  Planet = (function(){
    Planet.displayName = 'Planet';
    var prototype = Planet.prototype, constructor = Planet;
    function Planet(id, player, buildingLevels){
      var this$ = this;
      this.id = id;
      this.player = player;
      this.buildingLevels = buildingLevels;
      map(function(){})(
      objToPairs(
      this.buildingLevels));
    }
    prototype.findBuilding = function(name){};
    return Planet;
  }());
  Entity = (function(){
    Entity.displayName = 'Entity';
    var prototype = Entity.prototype, constructor = Entity;
    function Entity(id, level, planet){
      this.id = id;
      this.level = level;
      this.planet = planet;
      this.price = this._price();
      this.available = this._availability();
    }
    prototype._buildingTime = function(){
      var ref$;
      if (!((ref$ = this.planet) != null && ref$.roboticfactory)) {
        return 0;
      }
      return Math.floor(((this.price.metal * this.price.crystal) / (25000 * (1 + this.planet.roboticfactory.level) * Math.pow(2, 0) * 1)) * 3600);
    };
    prototype._price = function(){
      return formulas[this.displayName].price(this.level);
    };
    prototype._availability = function(){
      var allBuildings, allResearches, this$ = this;
      allBuildings = all(function(it){
        return this$.planet[it[0]].level >= it[0];
      })(
      objToPairs(
      formulas[this.displayName].buildings != null));
      allResearches = all(function(it){
        return this$.planet.player.researches[it[0]].level >= it[0];
      })(
      objToPairs(
      formulas[this.displayName].researches != null));
      return allBuildings && allResearches;
    };
    return Entity;
  }());
  Research = (function(superclass){
    var prototype = extend$((import$(Research, superclass).displayName = 'Research', Research), superclass).prototype, constructor = Research;
    function Research(){
      Research.superclass.apply(this, arguments);
    }
    return Research;
  }(Entity));
  Building = (function(superclass){
    var prototype = extend$((import$(Building, superclass).displayName = 'Building', Building), superclass).prototype, constructor = Building;
    function Building(){
      Building.superclass.apply(this, arguments);
    }
    return Building;
  }(Entity));
  Mine = (function(superclass){
    var prototype = extend$((import$(Mine, superclass).displayName = 'Mine', Mine), superclass).prototype, constructor = Mine;
    function Mine(){
      Mine.superclass.apply(this, arguments);
    }
    return Mine;
  }(Building));
  player = new Player(1, 'toto');
  planet = new Planet(1, player);
  metalmine = new Mine(1, 0, planet);
  function extend$(sub, sup){
    function fun(){} fun.prototype = (sub.superclass = sup).prototype;
    (sub.prototype = new fun).constructor = sub;
    if (typeof sup.extended == 'function') sup.extended(sub);
    return sub;
  }
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);
