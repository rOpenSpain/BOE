var openDataHandler = (function() {
	var _ = {
		
		$operation: null,
		lock: false,
		
		init: function(){
			
			$('div.operation-output').hide();
			
			$('div.api-button-bar input.boton').each(function(index, element){
				$(element).click(_.onSubmitTest);
			});
			
			$('select[name=fmt]').change(function(event){
				_.toogleXSD(event.currentTarget);
			});
			
			$('select[name=fmt]').each(function(index, element){
				_.toogleXSD(element);
			});
			
		}, //init
    
		onSubmitTest: function(event){
			
			event.preventDefault();
			
			if (!_.lock) {
				
				var $button = $(event.currentTarget);
				var $form   = $button.closest('form');
				
				var operation_id = $form.find('input[name="operation-id"]');
				var $operation = $button.closest('div.operation');
				var $mask = $operation.find('label[for="operation-details-input-' + $(operation_id).val() + '"]');
				
				var parameters = _.getInputs($($form.find('div.parameters')));
				
				if (_.validateParams(parameters)) {
					
					_.$operation = $form.closest('div.operation-details');
					
					var url =_.buildUrl(parameters, $mask.text());
					
					var responseFormat = '';
					
					var responseFormatInput = _.getInputs($($form.find('div.response-formats')));
					if (responseFormatInput.hasOwnProperty('fmt')) {
						responseFormat = $(responseFormatInput.fmt).val();
		
					} else {
						responseFormat = 'application/xml';
					}
				
					$button.closest('div.api-button-bar')
						.append(
							$("<div>")
								.attr("id","div-loading")
						)
					;
					
					$('input[type="submit"]').prop("disabled",true);
					_.lock = true;
					
					$.ajax({
						type: "GET",
						url: url,
						headers: {
							Accept : responseFormat,
						},
						beforeSend: function(jqXHR, settings) {
							jqXHR.url = settings.url;
						},
						success: _.onSuccesSubmitTest,
						error:   _.onErrorSubmitTest,
					});
					
				} //validate
			} //lock
			
		}, //onSubmitTest
		
		validateParams: function(parameters) {
			
			var valid = true;
			
			for (var param in parameters) {
        if(parameters.hasOwnProperty(param)) {
          let $value = $(parameters[param]);
          $value.removeClass("required-error");
          if ($value.prop("required") && $value.val().trim() == "") {
            $value.addClass("required-error").focus();
            valid = false;
          }
        }
			}
			
			return valid;
			
		}, //validateParams

		buildUrl: function(parameters, mask){
			
			var url = mask;
			var firstParam = true;
			for(var param in parameters){
				if ($(parameters[param]).hasClass('query') && $(parameters[param]).val().trim() !== '') {
					let separator = firstParam ? '?': '&';
					try {
						url += separator + param + '=' + JSON.stringify(JSON.parse($(parameters[param]).val()));
					} catch (e) {
						url += separator + param + '=' + $(parameters[param]).val();
					}
					firstParam = false;
				} else if (!$(parameters[param]).hasClass('query')) {
					url = url.replace('{' + param + '}', $(parameters[param]).val());
				}
			}
			
			return url;
			
		}, //buildUrl
		
		onSuccesSubmitTest: function(data, status, jqXHR){
			
			$("#div-loading").remove();
			$('input[type="submit"]').prop("disabled",false);
			_.lock = false;
			
			var $oos = _.$operation.find('div.operation-output');
			
			$oos.show();
			
			_.displayOutput(jqXHR);
			
		}, //onSuccesSubmitTest
		
		onErrorSubmitTest: function (jqXHR, status, textStatus){
			
			_.onSuccesSubmitTest(textStatus,status, jqXHR);
			
		}, //onErrorSubmitTest

		getInputs: function($haystack){
			
			var $inputs  = $haystack.find('input[type=text], select, textarea');
			var inputsValue = {};
			$inputs.each(function(index, element){
				let $element = $(element);
				inputsValue[$element.attr('name')] = $element;
			});
			
			return inputsValue;
		
		},
		
		displayOutput : function(jqXHR){
			var response = '';
			if(jqXHR.responseJSON){
				response = JSON.stringify(jqXHR.responseJSON, null, 4);
			}else{
				response = jqXHR.responseText;
			}
			
			//console.log (jqXHR, response);
			//var completeUrl = location.protocol + '//' + location.hostname + jqXHR.url;
			var completeUrl = location.protocol + '//' + location.hostname + jqXHR.url;
			var acceptHeader = _.$operation.find('div.response-formats select[name=fmt]').val();
			var curl ='curl -L -X GET -H "Accept: ' + acceptHeader + '" "' + completeUrl + '"';
			
			_.$operation.find('div.body > code > pre').text(response);
			_.$operation.find('pre[name=response-code]').text(jqXHR.status);
			_.$operation.find('div.headers > code > pre').text(jqXHR.getAllResponseHeaders());
			_.$operation.find('pre[name=url]').text(completeUrl);
			_.$operation.find('pre[name=curl]').text(curl);
			
		},
		
		renderResponseFormat: function(formats, operationId){
			
			var $parameterSelect = $('<select name="fmt">');
			
			if (formats.hasOwnProperty('content')) {
				$.each(formats.content, function(option, value) {
					$parameterSelect
									.append(
										$('<option>').text(option)
									);
				});
				
			} else {
				
				$parameterSelect
								.append(
									$('<option>').text('application/xml')
								);
				
			}

			
			var $responseFormat =   $('<div>').addClass('response-formats');
			var $subtitle = $('<div>').addClass('subtitle').html('Formato de la respuesta');
			var $divContent = $('<div>').addClass('content');
			
			$divContent.append($parameterSelect);
			$responseFormat.append($subtitle);
			$responseFormat.append($divContent);
			
			if(openApiSchemas[operationId]){
				var $xsdIconContainer = $('<div>').addClass('xsd-icon-container');
				var $xsdIcon = $('<a>').addClass('xsd-icon').attr({href: '/datosabiertos/definitions/download_schema.php?id=' + operationId});
				$xsdIconContainer.append($xsdIcon);
				$divContent.append($xsdIconContainer);
				
				$parameterSelect.change(function(){
					_.toogleXSD(this);
				});
			}
			
			return $responseFormat;
		},
		
		toogleXSD: function(element){
			let $this = $(element);
			let text = $this.find( "option:selected" ).text();
			let $xsd = $this.parent().find('a');
			if(text == 'application/xml'){
				$xsd.show();
			}else{
				$xsd.hide();
			}
		},
		
		
		renderParameters: function(operationDetails){
			
			var $parametersContent   =  $('<div>').addClass('content');
			
			var $parametersTable	 =  $('<div>')
											.addClass('tabla')
											.addClass('method-specs')
											.addClass('parameters')
											.append(
												_.renderParametersTableHead()
											)
										;
										
			var $parametersTableBody =  $('<div>').addClass('body');
			
			if (operationDetails.hasOwnProperty('parameters')){
				var parameters = operationDetails.parameters;
				$.each(parameters, function(i, parameter) {
					$parametersTableBody.append(_.renderParameter(parameter));
				});
			}
			
			$parametersTable.append($parametersTableBody);
			
			$parametersContent.append($parametersTable);
			
			$parameters =   $('<div>')
								.addClass('parameters')
								.append(
									$('<div>')
										.addClass('subtitle')
										.text('Par\u{00e1}metros')
								)
								.append(
									$parametersContent
								);
			
			return $parameters;
			
		}, //renderParameters
		
//*********************************
		renderResponses: function(operationDetails){
			
			var $responsesContent   =   $('<div>').addClass('content');
			var $responsesTable	 =   $('<div>')
											.addClass('tabla')
											.addClass('method-specs')
											.addClass('responses')
											.append(
												_.renderResponsesTableHead()
											)
										;
										
			var $responsesTableBody =   $('<div>').addClass("body");
			
			if (operationDetails.hasOwnProperty('responses')){
				$.each(operationDetails.responses, function(i, response) {
					$responsesTableBody.append(_.renderResponse(i,response));
				});
			}
			
			$responsesTable.append($responsesTableBody);
			
			$responsesContent.append($responsesTable);
			
			$responses =	$('<div>')
								.addClass('responses')
								.append(
									$('<div>')
										.addClass('subtitle')
										.text('Mensajes de la respuesta')
								)
								.append(
									$responsesContent
								);
			
			return $responses;
			
		}, //renderResponses
		
//*********************************
		renderExternalDocs: function(externalDocs){
			
			var $external =	 $('<div>')
									.addClass('externaldoc-link')
									.append(
										$('<a>')
											.attr({
												href   : externalDocs.url,
												title  : externalDocs.description,
												target : "_blank"
											})
											//.text(externalDocs.description)
											.text("Documentación del API")
									);
			
			return $external;
			
		}, //renderExternalDocs
//*********************************
		getObjectFromPath: function(path){
			
			var target;
			
			var arrayPath = path.split('/');
			
			arrayPath.forEach(function (item, index) {
				target = (item=='#') ? openApiFile : target[item];
			  });
			
			return target;
			
		}, //getObjectFromPath
	};
	
	$(_.init);
	
	var pub = {
	};
	
	return pub;
	
})();