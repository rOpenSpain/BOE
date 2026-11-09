function ParametrosGlobales() {
};

//***************************************************************************
var Util = (function(undefined) { //(function($, _prototype, undefined) {
  // Parte privada
  // *************
  var _ = {
    
    logActivo: true,
    MAX_TRACE_LEVEL: 2,
    NUM_SUCCESS_CODE: 0,
    NUM_WARNING_CODE: -1000000001,
    NUM_ERROR_CODE:   1,
    
    URL_EREG_PATTERN: '^(https?:\\/\\/)?'+ // protocolo
        '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'+ // nombre del dominio
        '((\\d{1,3}\\.){3}\\d{1,3}))'+ // O ip (v4) direccion
        '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*'+ // puerto y path
        '(\\?[;&a-z\\d%_.,~+=-]*)?'+ // query string
        '(\\#[-a-z\\d_]*)?$',
        
    URL_REGEXP: null,
    
    jqBlockDlg: null,
    blockDlg:   null,
    blockLevel: 0,
    debugPostMode: false,
    
    //-----------------------------------------------------------------------
    initBlockDlg: function()
    {
      if(_.jqBlockDlg !== null) {
        return;
      }

      _.jqBlockDlg = jQuery('<div id="wait"><p class="wait-message"></p><img src="/ajax/ajax-loader-bar.gif" alt="Cargando"></div>');

      _.jqBlockDlg.dialog({
        modal     : true,
        title     : 'Espere',
        maxHeight : Math.floor(jQuery(document).height()/3),
        width     : Math.min(Math.floor(jQuery(document).width()/2),600),
        resizable : false,
        autoOpen  : false,
        draggable : false,
      });

      _.blockDlg = _.jqBlockDlg.dialog("instance");

		},  // initLockDlg

    //------------------------------------------------------------------------
    blockUI: function(msg)
    {
      msg = (msg == undefined ? "Cargando..." : msg);
      
      _.initBlockDlg();
      
      if(_.blockLevel++ == 0) {
        _.jqBlockDlg.find(".wait-message").text(msg);
        _.blockDlg.open();
      }

    },

    //------------------------------------------------------------------------
    unBlockUI: function()
    {
      if(!_.blockDlg || (_.blockLevel == 0)) {
        return;
      }

      if(--_.blockLevel == 0) {
        _.blockDlg.close();
      }

    },

    //-----------------------------------------------------------------------
    getFilename: function(url)
    {
      if(url) {
        var m = url.toString().match(/.*\/(.+?)\./);
        if(m && m.length > 1) {
          return m[1];
        }
      }

      return "";

    },

    //-----------------------------------------------------------------------
    traceObject: function (obj, level)
    {
      var msg = '', espacios = '';
      
      level = level == undefined ? 1 : level;
      
      for(var j=0; j<level-1; j++)
        espacios += '  ';
      
       for(var i in obj)
        if(is_object(obj[i]) || is_array(obj[i])) {
          if(level < _.MAX_TRACE_LEVEL)
            msg += ("Objeto " + i + "{\n" + _.traceObject(obj[i], level+1) + "}\n");
          else
            msg += (espacios + i + ": Objeto");
        }
        else
          msg += (espacios + i + ": " + obj[i] + '\n');
    
      return msg;

    },
    
    //-----------------------------------------------------------------------
    callerDelegate: function(scope, func, userParams) {
      return function() {
        if(typeof userParams != 'undefined'){
         var copy = [];
         for(var i = 0; i<arguments.length; i++){
           copy.push(arguments[i]);
         }
         for(var i = 0; i<userParams.length; i++){
           copy.push(userParams[i]);
         }
         arguments = copy;
        }
        return func.apply(scope, arguments); 
      };
    },

    //-----------------------------------------------------------------------
    selectOption: function(selectId, value)
    {
      $(selectId).childElements().each(function(option){
        if(option.value==value){
          option.selected=true;
        }
      });
    },

    //-----------------------------------------------------------------------
    sort: function(array,primero,ultimo,asc)
    {
      var i=primero;
      var j=ultimo;
      var pivote=array[((i+j)-(i+j)%2)/2];
      var auxiliar;
      do{
        if(asc){
          while(array[i]<pivote) i++;    		
          while(array[j]>pivote) j--;
        }else{
          while(array[i]>pivote) i++;    		
          while(array[j]<pivote) j--;
        }
        if (i<=j){
          auxiliar=array[j];
          array[j]=array[i];
          array[i]=auxiliar;
          i++;
          j--;
        }
      }while(i<=j);
      
      if(primero<j) Util.sort(array,primero,j,asc);
      if(ultimo>i) Util.sort(array,i,ultimo,asc);
    },

    //-----------------------------------------------------------------------
    encodeObject: function(jsObject) {
      if(Object.toJSON){
        jsonString = Object.toJSON(jsObject);
      }else{
    	  jsonString = JSON.stringify(jsObject);
      }
      return encodeURI(jsonString);
    },

    //-----------------------------------------------------------------------
    log: function() {
      if(_.logActivo && (typeof(console) != 'undefined')) {
        console.log.apply(console, arguments);
      }
    },
    
    trace: function() {
      
      if(_.logActivo && (typeof(console.trace) != 'undefined')) {
        console.trace.apply(console, arguments);
      }
      _.log.apply(_, arguments);
      
    },
    
    //-----------------------------------------------------------------------
    getCuerpoSelect: function(arrValores, valorActual)
    {
      
      var sz_body = '';
      
      var id = '';
      var descripcion = '';
      for(var i=0; i<arrValores.length; i++) {
        if(arrValores[i].ID){
          id = arrValores[i].ID
        }else{
          id = arrValores[i].id
        }
        if(arrValores[i].DESCRIPCION){
        	descripcion = arrValores[i].DESCRIPCION
        }else{
        	descripcion = arrValores[i].descripcion
        }
        sz_body += '<option value="' + id + '"';
        sz_body += valorActual != undefined && (valorActual == id) ? ' selected="selected"' : '';
        sz_body +=">" + descripcion + '</option>';
      }
      
      return sz_body;
      
    },

    //-----------------------------------------------------------------------
    colocarDialogo: function(dialogo)
    {
      var
        jqDialogo = $(dialogo),
        ventana   = jqDialogo.closest('.dialog_content'),
        ancho     = $(ventana).width(),
        alto      = $(ventana).height();
        
        jqDialogo.width(ancho-30);
        jqDialogo.height(alto-30);
      
    },

    //-----------------------------------------------------------------------
    abrir_en_ventana: function(url)
    {
      window.open(url, '_blank');
      window.focus();
    },
    
    //-----------------------------------------------------------------------
    blockUI_OLD: function() {
      var elDiv = $('#div_blockUI');
      
      if(!elDiv.length) {
        var szDIV =  '<div id="div_blockUI" style="display:none">\n';
            szDIV += '  <div id="blockUI_loading">&#160;</div>\n';
            szDIV += '  <div id="blockUI_loading_text">Espere...</div>\n';
            szDIV += '</div>\n';
            
        elDiv = $(szDIV);
        $('body').append(elDiv);
      }
      
      Modalbox.hide();
      Modalbox.show(_prototype('div_blockUI'), {width: 300,transitions:false,header:false,overlayClose:false,verticallyCentered:true});
      
    },
    
    //-----------------------------------------------------------------------
    unBlockUI_OLD: function() {
      Modalbox.hide();
      _prototype('div_blockUI').hide();
    },
    
    //-----------------------------------------------------------------------
    setDebugPostMode: function(setDebug)
    {
      _.debugPostMode = setDebug !== undefined ? setDebug : true;
    },

    //-----------------------------------------------------------------------
    isDebugPostMode: function()
    {
      return _.debugPostMode;
    },

    //-----------------------------------------------------------------------
    encodeForPost: function(obj, setDebugMode)
    {
      if(setDebugMode !== undefined) {
        _.setDebugPostMode(setDebugMode);
      }
      
      if(_.isDebugPostMode()) {
        return obj;
      }
      else {
        return _.encodeObject(obj);
      }
      
    },  // encodeForPost()

    //-----------------------------------------------------------------------
    post: function(url, objDatos, opciones)
    {
      var
        $ = jQuery,
        opts = $.extend({
            callback:  Util.is_function(opciones) ? opciones : function(ok, msgErr, data) {},
            lock:      true,
            err_comm:  "Error de comunicaci?n con el servidor",
            obj_resp:  true,   // Si la respuesta debe ser siempre un objeto o no
            ver_error: true,   // Si se muestran los errores.
            ver_err_comm: true,  // Si se muestran los errores de comunicaci?n.
            context:   null
          },
          opciones
        );
    
      if(opts.lock === true) {
        Util.blockUI();
      }

      $.post(
        url,
        objDatos,
        function (data) {
          var
            boolOK   = false,
            msgErr   = 'Error en la peticion',
            datos    = null,
            respCode = -1;

          if(opts.lock) {
            Util.unBlockUI();
          }
          
          respCode = _.is_object(data) && (data.responseCode !== undefined) ? parseInt(data.responseCode) : parseInt(data);
          boolOK   = ((parseInt(data) == 1) && !opts.obj_resp);
          boolOK   = boolOK || (Util.is_object(data) && ((respCode == _.NUM_SUCCESS_CODE) || (respCode == _.NUM_WARNING_CODE)));
          msgErr   = Util.is_object(data) && (data.message  !== undefined) ? data.message : msgErr;
          datos    = Util.is_object(data) && (data.response !== undefined) ? data.response : datos;
          
          if(typeof(msgBoxUtil) !== "undefined") {
            if(!boolOK && opts.ver_error) {
              msgBoxUtil.MsgErrorBox(msgErr, function() {
                if(Util.is_function(opts.callback)) {
                  opts.callback.apply(opts.context !== null ? opts.context : this, [ boolOK, msgErr, datos, respCode ]);
                }
              });
            }
            else {
              if(Util.is_function(opts.callback)) {
                opts.callback.apply(opts.context !== null ? opts.context : this, [ boolOK, msgErr, datos, respCode ]);
              }
            }
          }
          else {
            if(!boolOK && opts.ver_error) {
              alert(msgErr);
            }
            
            if(Util.is_function(opts.callback)) {
              opts.callback.apply(opts.context !== null ? opts.context : this, [ boolOK, msgErr, datos, respCode ]);
            }
          }
    
        },
        'json'
      ).error(function (msg) {
        if(opts.lock) {
          Util.unBlockUI();
        }
    
        var mi_msg_error = Util.is_object(msg) && (msg.responseText !== undefined) ? msg.responseText : opts.err_comm;
        opts.err_comm = mi_msg_error;

        if(typeof(msgBoxUtil) !== "undefined") {
          if(opts.ver_err_comm) {
            msgBoxUtil.MsgErrorBox(opts.err_comm, function() {
              if(Util.is_function(opts.callback)) {
                opts.callback.apply(opts.context !== null ? opts.context : this, [ false, opts.ver_err_comm, null, -1 ]);
              }
            });
          }
          else {
            if(Util.is_function(opts.callback)) {
              opts.callback.apply(opts.context !== null ? opts.context : this, [ false, opts.ver_err_comm, null, -1 ]);
            }
          }
        }
        else {
          if(opts.ver_err_comm) {
            alert(opts.err_comm);
          }
          
          if(Util.is_function(opts.callback)) {
            opts.callback.apply(opts.context !== null ? opts.context : this, [ false, opts.ver_err_comm, null, -1 ]);
          }
        }
        
      });
    
    },  // post()

    //-----------------------------------------------------------------------
    doPost: function(url, objDatos, fnOnSuccess, fnOnFail)
    {
      var $ = jQuery;
      
      $.post(
        url,
        objDatos,
        function (data) {
          
          if(is_object(data) || is_array(data)) {
            if(data.OK == 1) {
              fnOnSuccess(data);
            }
            else {
              fnOnFail(1, data);
            }
            
          } else {
            fnOnFail(2, data);
          }
    
        },
        'json'
      ).error(function (msg) {
        fnOnFail(-1);
      });
    
    },
    
    //---------------------------------------------------------------------------
    doPostObj: function(url, objDatos, opciones)
    {
      var
        $ = jQuery,
        opts = $.extend({
            callback:  _.is_function(opciones) ? opciones : function(ok, msgErr, data) {},
            lock:      true,
            err_comm:  "Error de comunicacion con el servidor",
            obj_resp:  true,   // Si la respuesta debe ser siempre un objeto o no
            ver_error: true,   // Si se muestran los errores.
            ver_err_comm: true,  // Si se muestran los errores de comunicacion.
            context:   null
          },
          opciones
        );
    
      if(opts.lock) {
        Util.blockUI();
      }
      
      $.post(
        url,
        objDatos,
        function (data) {
          var
            boolOK = false,
            msgErr = 'Error en la peticion',
            datos  = null;
        
          if(opts.lock) {
            Util.unBlockUI();
          }
          
          boolOK = ((parseInt(data) == 1) && !opts.obj_resp);
          boolOK = boolOK || (is_object(data) && (typeof(data.OK) !== "undefined") && (parseInt(data.OK) == 1));
          msgErr = is_object(data) && (typeof(data.msg) !== "undefined") ? data.msg : msgErr;
          datos  = is_object(data) ? data : datos;
          
          if(typeof(msgBoxUtil) !== "undefined") {
            if(!boolOK && opts.ver_error) {
              msgBoxUtil.MsgErrorBox(msgErr, function() {
                if(_.is_function(opts.callback)) {
                  opts.callback.apply(opts.context != null ? opts.context : this, [ boolOK, msgErr, datos ]);
                }
              });
            }
            else {
              if(_.is_function(opts.callback)) {
                opts.callback.apply(opts.context != null ? opts.context : this, [ boolOK, msgErr, datos ]);
              }
            }
          }
          else {
            if(!boolOK && opts.ver_error) {
              alert(msgErr);
            }
            
            if(_.is_function(opts.callback)) {
              opts.callback.apply(opts.context != null ? opts.context : this, [ boolOK, msgErr, datos ]);
            }
          }
    
        },
        'json'
      ).error(function (msg) {
        if(opts.lock) {
          Util.unBlockUI();
        }
    
        if(typeof(msgBoxUtil) !== "undefined") {
          if(opts.ver_err_comm) {
            msgBoxUtil.MsgErrorBox(opts.err_comm, function() {
              if(_.is_function(opts.callback)) {
                opts.callback.apply(opts.context !== null ? opts.context : this, [ false, opts.ver_err_comm, null ]);
              }
            });
          }
          else {
            if(_.is_function(opts.callback)) {
              opts.callback.apply(opts.context !== null ? opts.context : this, [ false, opts.ver_err_comm, null ]);
            }
          }
        }
        else {
          if(opts.ver_err_comm) {
            alert(opts.err_comm);
          }
          
          if(_.is_function(opts.callback)) {
            opts.callback.apply(opts.context !== null ? opts.context : this, [ false, opts.ver_err_comm, null ]);
          }
        }
        
      });
    
    },  // doPostObj()

    //-----------------------------------------------------------------------
    getAttrCount: function(obj) {
    
      var count = 0;
    
      for(var k in obj) {
        if(obj.hasOwnProperty(k)) {
          ++count;
        }
      }
      
      return count;
    
    },
    
    //-----------------------------------------------------------------------
    is_array: function(input)
    {
      return typeof(input)=='object' && (input instanceof Array);
    },
     
    //-----------------------------------------------------------------------
    is_object: function(input)
    {
      return typeof(input)=='object' && !(input instanceof Array);
    },
     
    //-----------------------------------------------------------------------
    is_int: function(x)
    {
      var y = parseInt(x);
      if (isNaN(y))
        return false;
      return x == y && x.toString() == y.toString();
    },

    //-----------------------------------------------------------------------
    is_function: function(functionToCheck)
    {
     var getType = {};
     return functionToCheck && getType.toString.call(functionToCheck) === '[object Function]';
    },
    
    //-----------------------------------------------------------------------
    parseUri: function(sourceUri)
    {
      var uriPartNames = ["source","protocol","authority","domain","port","path","directoryPath","fileName","query","anchor"];
      var uriParts = new RegExp("^(?:([^:/?#.]+):)?(?://)?(([^:/?#]*)(?::(\\d*))?)?((/(?:[^?#](?![^?#/]*\\.[^?#/.]+(?:[\\?#]|$)))*/?)?([^?#/]*))?(?:\\?([^#]*))?(?:#(.*))?").exec(sourceUri);
      var uri = {};
      
      for(var i = 0; i < 10; i++){
        uri[uriPartNames[i]] = (uriParts[i] ? uriParts[i] : "");
      }
      
      if(uri.directoryPath.length > 0){
        uri.directoryPath = uri.directoryPath.replace(/\/?$/, "/");
      }

      if(uri.query!==null){
        uri.queryString = uri.query
        uri.query = {};
        if(uri.queryString != ''){
	        var parameters = uri.queryString.split('&');
	        for(var i=0; i<parameters.length;i++){
	          var paramTokens = parameters[i].split('=');
	          var paramName   = paramTokens[0];
	          var paramValue  = null;
	          if(paramTokens.length>1){
	            paramValue = paramTokens[1];
	          }
	          uri.query[paramName] = paramValue;
	        }
        }else{
        	uri.queryString = null;
        }
      }
      
      return uri;

    },  // parseUri
    
    //-----------------------------------------------------------------------
    formatXML: function formatXml(xml) {
      var formatted = '';
      var reg = /(>)(<)(\/*)/g;
      xml = xml.replace(reg, '$1\r\n$2$3');
      var pad = 0;
      jQuery.each(xml.split('\r\n'), function(index, node) {
        var indent = 0;
        if (node.match(/.+<\/\w[^>]*>$/)) {
          indent = 0;
        } else if (node.match(/^<\/\w/)) {
          if (pad !== 0) {
            pad -= 1;
          }
        } else if (node.match(/^<\w[^>]*[^\/]>.*$/)) {
          indent = 1;
        } else {
          indent = 0;
        }
    
        var padding = '';
        for (var i = 0; i < pad; i++) {
          padding += '  ';
        }
    
        formatted += padding + node + '\r\n';
        pad += indent;
      });
    
      return formatted;
    },

    //-----------------------------------------------------------------------
    reload: function()
    {
      Util.blockUI();
      window.location = window.location;
    },

    //-----------------------------------------------------------------------
    redirect: function(url)
    {
      Util.blockUI();
      window.location = url;
    },

    //---------------------------------------------------------------------------
    guardarValorPrevio: function($campos)
    {
    
      $campos.each(function() {
        
        if(!jQuery(this).hasClass("ignorar_campo")) {
          var
            $this = jQuery(this),
            type  = $this.attr("type"),
            valor = '',
            previo = $this.data("prev");
            
          type = type === undefined ? "" : type.toLowerCase();
      
          switch(type) {
            case "checkbox":
            case "radio":
              valor = $this.is(":checked") ? 1 : 0;
              break;
            
            default:
              valor = $this.val();
              break;
          }
          
          $this.data("prev", valor);
        }
        
      });
    
    },  // guardarValorPrevio()
    
    //---------------------------------------------------------------------------
    getCamposGrabar: function($campos)
    {
      var
        campos = {};
      
      $campos.each(function() {
        
        if(!jQuery(this).hasClass("ignorar_campo")) {
          var
            $this = jQuery(this),
            name  = $this.attr("name"),
            type  = $this.attr("type"),
            valor = null,
            previo = $this.data("prev");
            
          if(typeof(previo) !== "undefined") {
            type = typeof(type) === "undefined" ? "" : type.toLowerCase();
        
            switch(type) {
              case "checkbox":
                valor = $this.is(":checked") ? 1 : 0;
                break;
              
              case "radio":
                valor = previo;   // Evitamos que se mande
                if($this.is(":checked")) {
                  if(previo != 1) {  // Si ha pasado a ser el boton activo...
                    valor  = $this.val();
                    previo = '-' + valor + '-';  // Fuerzo la actualiacion
                  }
                }
                break;
              
              default:
                valor = $this.val();
                break;
            }
            
            if((valor !== null) && (valor != previo)) {
              campos[name] = valor;
            }
          }
    
        }
        
      });
      
      return campos;
    
    },  // getCamposGrabar()
        
    //---------------------------------------------------------------------------
    revertirCambios: function($campos)
    {
      $campos.each(function() {
        
        if(!jQuery(this).hasClass("ignorar_campo")) {
          var
            $this = jQuery(this),
            type  = $this.attr("type"),
            valor = '',
            previo = $this.data("prev");
            
          type = typeof(type) === "undefined" ? "" : type.toLowerCase();
      
          switch(type) {
            case "checkbox":
            case "radio":
              if(previo > 0) {
                $this.attr("checked", "checked");
              }
              else {
                $this.removeAttr("checked");
              }
              break;
            
            default:
              $this.val(previo);
              break;
          }
        }
        
      });
    
    },  // revertirCambios()

    //-----------------------------------------------------------------------
    validURL: function(str)
    {
      if(!_.URL_REGEXP) {
        _.URL_REGEXP = new RegExp(_.URL_EREG_PATTERN, 'i');
      }
    
      if(!_.URL_REGEXP.test(str)) {
        return false;
      } else {
        return true;
      }
    
    },  // validURL()

    //---------------------------------------------------------------------------
    define: function(name, value)
    {
      var defn, replace, script, that = this,
          d = this.window.document;
      var toString = function (name, value) {
          return 'const ' + name + '=' + (/^(null|true|false|(\+|\-)?\d+(\.\d+)?)$/.test(value = String(value)) ? value : '"' + replace(value) + '"');
      };
      try {
          eval('const e=1');
          replace = function (value) {
              var replace = {
                  "\x08": "b",
                  "\x0A": "\\n",
                  "\x0B": "v",
                  "\x0C": "f",
                  "\x0D": "\\r",
                  '"': '"',
                  "\\": "\\"
              };
              return value.replace(/\x08|[\x0A-\x0D]|"|\\/g, function (value) {
                  return "\\" + replace[value];
              });
          };
          defn = function (name, value) {
              if (d.createElementNS) {
                  script = d.createElementNS('http://www.w3.org/1999/xhtml', 'script');
              } else {
                  script = d.createElement('script');
              }
              script.type = 'text/javascript';
              script.appendChild(d.createTextNode(toString(name, value)));
              d.documentElement.appendChild(script);
              d.documentElement.removeChild(script);
          };
      } catch (e) {
          replace = function (value) {
              var replace = {
                  "\x0A": "\\n",
                  "\x0D": "\\r"
              };
              return value.replace(/"/g, '""').replace(/\n|\r/g, function (value) {
                  return replace[value];
              });
          };
          defn = (this.execScript ?
          function (name, value) {
              try {
                /* Hack para Explorer
                 */
                if(name == 'SELECT') {
                  eval(toString(name, value).substring(6));
                }
                else {
                  that.execScript(toString(name, value), 'VBScript');
                }
              } catch(e) {
                alert('Por aqui andamos: ' + name);
              }
          } : function (name, value) {
              eval(toString(name, value).substring(6));
          });
      }
      defn(name, value);
    
    },  // define()

    //-----------------------------------------------------------------------
    loadJSfile: function(src, callback) {
      jsLoader.loadScript(src, callback);
    },

    //-----------------------------------------------------------------------
    htmlDecode: function(str)
    {
      var e = document.createElement('div');
      e.innerHTML = str;
      return e.childNodes.length === 0 ? "" : e.childNodes[0].nodeValue;
    },

    //-----------------------------------------------------------------------
		today : function() {
			var today = new Date();
			var dd = today.getDate();
			var mm = today.getMonth() + 1; // January is 0!
			var yyyy = today.getFullYear();

			if (dd < 10) {
				dd = '0' + dd
			}

			if (mm < 10) {
				mm = '0' + mm
			}

			today = dd + '/' + mm + '/' + yyyy;
			return today;
		},
    
    //-----------------------------------------------------------------------
    decodeObject: function($str)
    {
      return JSON.parse(Base64.decode($str));
    },

    //-----------------------------------------------------------------------
    
  };
  
  // Parte p?blica
  var pub = {
    NUM_SUCCESS_CODE:   _.NUM_SUCCESS_CODE,
    NUM_WARNING_CODE:   _.NUM_WARNING_CODE,
    NUM_ERROR_CODE:     _.NUM_ERROR_CODE,

    traceObject:        _.traceObject,
    getFilename:        _.getFilename,
    callerDelegate:     _.callerDelegate,
    selectOption:       _.selectOption,
    sort:               _.sort,
    encodeObject:       _.encodeObject,
    formatXML:          _.formatXML,
    log:                _.log,
    getCuerpoSelect:    _.getCuerpoSelect,
    colocarDialogo:     _.colocarDialogo,
    abrir_en_ventana:   _.abrir_en_ventana,
    blockUI:            _.blockUI,
    unBlockUI:          _.unBlockUI,
    setDebugPostMode:   _.setDebugPostMode,
    isDebugPostMode:    _.isDebugPostMode,
    encodeForPost:      _.encodeForPost,
    post:               _.post,
    doPost:             _.doPost,
    doPostObj:          _.doPostObj,
    getAttrCount:       _.getAttrCount,
    is_int:             _.is_int,
    is_array:           _.is_array,
    is_object:          _.is_object,
    is_function:        _.is_function,
    isFunction:         _.is_function,
    parseUri:           _.parseUri,
    reload:             _.reload,
    redirect:           _.redirect,
    guardarValorPrevio: _.guardarValorPrevio,
    getCamposGrabar:    _.getCamposGrabar,
    revertirCambios:    _.revertirCambios,
    validURL:           _.validURL,
    loadJSfile:         _.loadJSfile,
    htmlDecode:         _.htmlDecode,
    today:              _.today,
    trace:              _.trace,
    decodeObject:       _.decodeObject,
  };
  
  return pub;

})();
//})(jQuery, $);


//----------------------------------------------------------------------------
// Plugin para insertar texto en la posicion actual del cursor
//----------------------------------------------------------------------------
if(typeof(jQuery) !== "undefined") {
  jQuery.fn.extend({
    insertAtCaret: function(myValue){
      return this.each(function(i) {
        if(document.selection) {
          //For browsers like Internet Explorer
          this.focus();
          var sel = document.selection.createRange();
          sel.text = myValue;
          this.focus();
        }
        else if(this.selectionStart || this.selectionStart == '0') {
          //For browsers like Firefox and Webkit based
          var startPos = this.selectionStart;
          var endPos = this.selectionEnd;
          var scrollTop = this.scrollTop;
          this.value = this.value.substring(0, startPos)+myValue+this.value.substring(endPos,this.value.length);
          this.focus();
          this.selectionStart = startPos + myValue.length;
          this.selectionEnd = startPos + myValue.length;
          this.scrollTop = scrollTop;
        } else {
          this.value += myValue;
          this.focus();
        }
      });
    }
  });
}

//----------------------------------------------------------------------------
// Plugin para padding de strings...
//----------------------------------------------------------------------------
if(typeof(jQuery) !== "undefined") {
	jQuery.strPad = function(input, pad_length, pad_string, pad_type){
		var output = input.toString();
		if (pad_string === undefined) { pad_string = ' '; }
		if (pad_type === undefined) { pad_type = 'STR_PAD_RIGHT'; }
		if (pad_type == 'STR_PAD_RIGHT') {
			while (output.length < pad_length) {
				output = output + pad_string;
			}
		} else if (pad_type == 'STR_PAD_LEFT') {
			while (output.length < pad_length) {
				output = pad_string + output;
			}
		} else if (pad_type == 'STR_PAD_BOTH') {
			var j = 0;
			while (output.length < pad_length) {
				if (j % 2) {
					output = output + pad_string;
				} else {
					output = pad_string + output;
				}
				j++;
			}
		}
		return output;
	};
}

//---------------------------------------------------------------------------
