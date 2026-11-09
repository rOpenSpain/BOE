var desplegablesHandler = (function() {
	
	Array.prototype.contains = function(obj) {
		var i = this.length;
		while (i--) {
			if (this[i] === obj) {
				return true;
			}
		}
		return false;
	};
	
	var desplegables={
		sumario      : ['dropDownEmi','dropDownSec'],
		menu         : ['activar-idiomas','activar-menu'],
		menu_movil   : ['activar-idiomas','activar-menu-movil'],
		consolidada_1: ['activar-versiones'],
		consolidada_2: ['activar-marcadores'],
	};
	
	var boeHandler = {
			
			//---------------------------------------------------------------------
			is_array: function(input)
			{
				return typeof(input)=='object' && (input instanceof Array);
			},
			
			//---------------------------------------------------------------------
			is_object: function(input)
			{
				return typeof(input)=='object' && !(input instanceof Array);
			},
			
			//---------------------------------------------------------------------
			
			init:function(){
				if (window.addEventListener) {
					//IE > IE9 o FF o CH ...
					boeHandler.find();
					document.body.onclick = boeHandler.plegar;
					//CH Ipad!
					var miBoeLabel = document.querySelector('span.botonMiBOE');
					if(miBoeLabel){
						miBoeLabel.addEventListener("touchstart", function(){return false;}, false);
					}
				}
			},
			
			inhabilitar: function(event){
				event.stopPropagation();
			},
			
			plegar: function(event){
				var desplegable, grupo;
				for (var nombreGrupo in desplegables){
						grupo = desplegables[nombreGrupo];
						for (var i=0; i<grupo.length; i++){
							desplegable = grupo[i];
							desplegable.input.checked = false;
						}
				}
			},
			
      //---------------------------------------------------------------------
      addGrupo: function(grupo, nombre, machacar)
      {
				var id, input, label, elGrupo = [];

        nombre   = typeof nombre   !== "undefined" ? nombre   : "grp_" + Math.round(100000*Math.random());
        machacar = typeof machacar !== "undefined" ? machacar : false;

//        console.log("addGrupo(" + nombre + "): ", grupo);

        if(!boeHandler.is_array(grupo)) {
//          console.log("addGrupo(): Parametros erroneos");
          return false;
        }
        
        if((machacar == false) && (typeof desplegables[nombre] !== "undefined")) {
//          console.log("addGrupo(): Intento de definicion de grupo duplicado");
          return true;
        }
        
        for(var indice in grupo) {
          if(grupo.hasOwnProperty(indice)) {
            id    = grupo[indice];
            label = document.querySelector('label[for="' + id + '"]');
            input = document.querySelector('input#' + id);

//          if((input == null) || (label == null)) {
//          return false;
//        }
//        else 
          if(input != null && label != null) {
              elGrupo.push({input: input, label: label});
            }
          }
        }
        
        // Si hemos pasado la prueba instalamos los manejadores
        for(var i=0; i<elGrupo.length; i++){
          var desplegable = elGrupo[i];
          desplegable.label.onclick = boeHandler.clickExclusivo;
          desplegable.input.onclick = boeHandler.inhabilitar;
        }
        
        desplegables[nombre] = elGrupo;

//        console.log("elGrupo:", elGrupo);
//        console.log("desplegables:", desplegables);
        
        return true;

      },  // addGrupo()
			
      //---------------------------------------------------------------------
			find: function(){
				
				var gruposNoEncontrados = [];
				
				for (var nombreGrupo in desplegables){
					grupo = desplegables[nombreGrupo];
          if(!boeHandler.addGrupo(grupo, nombreGrupo, true)) {
            gruposNoEncontrados.push(nombreGrupo);
          }
				}

				for(var i=0; i < gruposNoEncontrados.length; i++){
					grupo = gruposNoEncontrados[i];
					delete desplegables[grupo];
				}
				
			},
			
			clickExclusivo: function(event){
				var found = false;
				var desplegable, grupo;
				
				for (var nombreGrupo in desplegables){
					if(!found){
						grupo = desplegables[nombreGrupo];
						for (var i=0; i<grupo.length && !found; i++){
							desplegable = grupo[i];
							if(event.currentTarget.outerHTML == desplegable.label.outerHTML){
//								found = true;
								for (var j=0; j<grupo.length; j++){
									desplegable = grupo[j];
									if(event.currentTarget.outerHTML != desplegable.label.outerHTML){
										desplegable.input.checked = false;
									}
								}
							}
							
						}
					}
				}
				
				event.stopPropagation();
				
			},
	};
	
		boeHandler.init();
	
  var pub = {
    addGrupo: boeHandler.addGrupo,
    plegar:   boeHandler.plegar
  };
  
  return pub;
	
})();

