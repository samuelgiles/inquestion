// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require best_in_place
//= require best_in_place.purr
//= require jquery.ui.datepicker
//= require_tree .


function inquestion_admin(){
	
	var self = this;

	self.init = function(){

		if($("#admin-user-search").length > 0){

			$("#admin-user-search").selectize({
			    highlight: true,
			    create: false,
			    onItemAdd: function(value) {
			        self.findUser(value);
			    }
			});

		}
		if($("#employer-map").length > 0){
			self.employerMap.init();
		}

	}
	self.findUser = function(userid)
	{
		$.ajax({
			type: "GET",
			url: ("/admin/users/" + parseFloat(userid)),
			success: function(data){

				$("#admin-user-name").html(data.forename + " " + data.surname);
				$("#admin-user-email").html(data.email);
				$("#admin-user-lastseen").html(data.last_seen_in_days);
				$("#admin-user-yearsold").html(data.age);
				$("#admin-user-admin").html(data.admin ? "Yes" : "No");
				$("#admin-user-employername").html(data.employerName);
				$("#admin-user-employeraddress").html(data.employerAddress);
				$("#admin-user-employerphone").html(data.employerPhone);
				$("#admin-user-notes").html(data.notes);

				$("#view dd:empty").html("----")
			}
		})
	}
	self.employerMap = {
		element: null,
		map: null,
		marker: null,
		geocoder: null,
		options: {
			zoom: 12
		},
		init: function(){
			self.employerMap.element = $("#employer-map");
			self.employerMap.geocoder = new google.maps.Geocoder();
			//get address:
			var address = $(self.employerMap.element).data("address");
			self.employerMap.doGeocode(address);

			//bind update of address:
			$('.employer-address').bind("ajax:success", function(){
				self.employerMap.doGeocode($('.employer-address').text());
			});

		},
		doGeocode: function(address){
			self.employerMap.geocoder.geocode({ 'address': address}, function(results, status) {
				if(status == google.maps.GeocoderStatus.OK){
					self.employerMap.options.center = results[0].geometry.location;
					self.employerMap.createMap();
				}
				else{
					self.employerMap.fail();
				}
			});
		},
		createMap: function(){
			self.employerMap.map = new google.maps.Map($(self.employerMap.element).get(0), self.employerMap.options);
			self.employerMap.marker = new google.maps.Marker({ map: self.employerMap.map, position: self.employerMap.options.center });
		},
		fail: function(){
			$(self.employerMap.element).remove();
		}
	}

}

var inquestionAdmin = new inquestion_admin();

function inquestion_frontend(){
	
	var self = this;

	self.init = function(){

		if($("#question-help").length > 0){

			self.setupAsk();

		}

		if($("#notifications").length > 0){
			self.notifications.setup();
		}

		$('.best_in_place').best_in_place();
		$.datepicker.setDefaults({
		    dateFormat: 'dd/mm/yy'
		});
		$('.datepicker').datepicker();
		
		self.knowledgeAreas.init();

	}
	self.oneInit = function(){

	}

	//Setup the ask a question page
	self.setupAsk = function(){

		$("#question-similar-answers, #question-similar-questions").hide();
		$("#new_question input, #new_question textarea").keydown(function(){
			self.askSimilarLookup();
		});

	}

	//Method that gets called every time a field changes in the ask a question form
	//Gets potentially relevant questions and answers and displays them alongside the form
	self.askSimilarLookup = function(){
		$("#question-help").slideUp(400,function(){
			$("#question-similar-answers, #question-similar-questions").fadeIn(1000);
		})
	}

	self.notifications = {
		currentCount: 0,
		setup: function(){

			var popover = $("#notifications-popover");
			//Hide notifications
			$(popover).hide();

			self.notifications.currentCount = $("li[data-notification-id]", "#notifications-popover ul").length
			//Notifications button in header
			$("#notifications").click(function(event){

				$(popover).show();
				if($(popover).hasClass("active")){
					$(popover).removeClass("animated bounceInDown bounceOutUp").addClass("animated bounceOutUp");
					$(popover).removeClass("active");
				}
				else{
					$(popover).removeClass("animated bounceInDown bounceOutUp").addClass("animated bounceInDown");
					$(popover).addClass("active");
				}

				event.preventDefault();
				return false;

			});
			//Notifications clear button:
			$("#notifications-clear").click(function(event){

				var iCurrentDelay = 0;
				var iCurrent = 0;
				$("li", popover).each(function(){

					
					$(this).fadeIn(1).delay(iCurrentDelay).fadeIn(1,function(){
						$(this).addClass("animated flipOutX")
					}).slideUp(500, function(){
						iCurrent++;
						if(iCurrent == $("li", popover).length){
							$("li", popover).remove();
							var noNotifications = $("<li><a href=\"\"><strong>You have no notifications</strong></a></li>");
							$("ul", popover).append(noNotifications);
							$(noNotifications).hide().addClass("animated flipInX").slideDown(400);
						}
					});
					
					iCurrentDelay += 200;

				});

				self.notifications.clear();

				event.preventDefault();
				return false;
			});

			self.notifications.setTick();

		},
		setTick: function(){
			window.clearInterval(window.inquestionNotificationInterval);
			window.inquestionNotificationInterval = window.setInterval(function(){ inquestionFrontend.notifications.check(); }, 6000);
		},
		check: function(){
			$.ajax({
				type: "GET",
				url: ("/notifications/check"),
				success: function(data){
					
					if(data.notifications != self.notifications.currentCount){
						self.notifications.fetch();
					}

				}
			});
		},
		fetch: function(){
			$.ajax({
				type: "GET",
				url: ("/notifications?js=true"),
				success: function(data){

					$("li", "#notifications-popover ul").remove();
					$("ul", $("#notifications-popover")).append($(data));

					self.notifications.currentCount = $("li[data-notification-id]", "#notifications-popover ul").length;
					self.notifications.updateCurrentCountDisplay();
					$("#notifications").removeClass("animated wobble").fadeIn(1).addClass("animated wobble");
				}
			});
		},
		updateCurrentCountDisplay: function(){
			$("#notifications").text("Notifications [" + self.notifications.currentCount + "]")
		},
		clear: function(){

			var clearIDList = []
			$("li[data-notification-id]", "#notifications-popover ul").each(function(){
				clearIDList.push(parseFloat($(this).data("notification-id")));
			});


			if(clearIDList.length > 0){
				$.ajax({
					type: "POST",
					data: {"notifications": clearIDList},
					url: ("/notifications/clear"),
					success: function(data){
						self.notifications.currentCount = 0;
						self.notifications.updateCurrentCountDisplay();
					}
				});
			}

		}
	}
	self.knowledgeAreas = {
		knowledgeList: null,
		editMode: null,
		init: function(){
			//Run attach, sets the knowledgeList and the click event
			self.knowledgeAreas.attach();
			self.knowledgeAreas.editMode = false;
		},
		attach: function(){
			self.knowledgeAreas.knowledgeList = $(".knowledge-list");
			$(".knowledge-list-btn").click(function(){
				//If not edit mode, then change to, otherwise save the current list:
				if(self.knowledgeAreas.editMode){
					self.knowledgeAreas.save();
				}
				else{
					self.knowledgeAreas.changeToEdit();
				}
				event.preventDefault();
				return false;
			});
		},
		changeToEdit: function(){
			//Add a input box below, change mode to true
			self.knowledgeAreas.editMode = true;
			$(".knowledge-list-btn").html("Save Knowledge Areas")
			self.knowledgeAreas.addKnowledge();
		},
		addKnowledge: function(){
			//Spawn a new input box and button
			$(self.knowledgeAreas.knowledgeList).append("<li><form class=\"form\"><div class=\"form-control\"><input type=\"text\" name=\"knowledge-list-new\" placeholder=\"Add new area\"></input></div></form></li>");
			var addKnowledgeButton = $("<li><button class=\"btn btn-block\">Add Knowledge Area</button></li>");
			$(self.knowledgeAreas.knowledgeList).append($(addKnowledgeButton));
			$("button", addKnowledgeButton).click(function(){

				//Validation:
				if($("input", self.knowledgeAreas.knowledgeList).val().length > 0){
					//Add self to list
					//-Remove hashtag incase user has entered it and get value into variable
					var newArea = "#" + ($("input", self.knowledgeAreas.knowledgeList).val()).replace("#", "");
					var newAreaListItem = $("<li></li>").text(newArea);
					$(self.knowledgeAreas.knowledgeList).append($(newAreaListItem));

					//Remove self
					self.knowledgeAreas.removeKnowledgeInput();

					//Repeat the process, add a new button
					self.knowledgeAreas.addKnowledge();
				}
				
				event.preventDefault();
				return false;
			});
		},
		removeKnowledgeInput: function(){
			$("button", self.knowledgeAreas.knowledgeList).parent().remove();
			$("input", self.knowledgeAreas.knowledgeList).parent().remove();
		},
		save: function(){
			editMode = false;
			self.knowledgeAreas.removeKnowledgeInput();
			$(".knowledge-list-btn").html("Change Knowledge Areas");

			//Turn ul into a list and remove hashes:
			var knowledge = new Array();
			var knowledgeListItems = $("li", self.knowledgeAreas.knowledgeList)

			$(knowledgeListItems).each(function(){

				if($(this).text().length > 0){
					knowledge.push(($(this).text()).replace("#", ""))
				}
				
			});

			$.ajax({
				type: "POST",
				data: {"knowledge": knowledge},
				url: ($(self.knowledgeAreas.knowledgeList).data("url")),
				success: function(data){

					console.log(data);
					
				}
			})

		}
	}

}

var inquestionFrontend = new inquestion_frontend();
$(document).on('ready page:load', function () {

	$(".selectize").selectize({
		highlight: true,
		create: false
	});

	inquestionAdmin.init();
	inquestionFrontend.init();

}).on("page:change", function(){
	$("#main").removeClass("animated fadeInDown fadeOutUp").addClass("animated fadeInDown");
	NProgress.done();
}).on("page:fetch", function(){
	$("#main").removeClass("animated fadeInDown fadeOutUp").addClass("animated fadeOutUp");
	NProgress.start();
}).on('page:restore', function(){
	NProgress.remove();
});