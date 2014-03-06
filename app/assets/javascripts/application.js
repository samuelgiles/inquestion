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
//= require jquery.turbolinks
//= require jquery_ujs
//= require best_in_place
//= require best_in_place.purr
//= require jquery.ui.datepicker
//= require turbolinks
//= require_tree .

function inquestion_admin(){

	var self = this;

	self.init = function(){

		if($("#employer-map").length > 0){
			self.employerMap.init();
		}
		if($("#admin-users-index").length > 0){
			$("#admin-users-index form select").change(function(){
				$("#admin-users-index form").submit();
			});
		}

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
			$(self.employerMap.element).hide();

			self.employerMap.doGeocode(address);

			//bind update of address:
			$('.employer-address').bind("ajax:success", function(){
				self.employerMap.doGeocode($('.employer-address').text());
			});

		},
		doGeocode: function(address){
			self.employerMap.geocoder.geocode({ 'address': address}, function(results, status) {
				if(status == google.maps.GeocoderStatus.OK){
					$(self.employerMap.element).fadeIn(200);
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
			$(self.employerMap.element).hide();
		}
	}
	self.init();

}

var inquestionAdmin = null;

function inquestion_frontend(){

	var self = this;

	self.init = function(){

		if($("#question-help").length > 0){

			self.setupAsk();

		}

		self.notifications.setup();

		$(".best_in_place").best_in_place();
		$.datepicker.setDefaults({
		    dateFormat: 'dd/mm/yy'
		});
		$("[data-sort-menu]").each(function(){
			self.sortMenu($(this));
		});
		$(".vote").each(function(){
			new self.vote($(this));
		})

		$(".datepicker").datepicker();

		self.knowledgeAreas.init();

	}
	self.oneInit = function(){

	}

	//Setup the ask a question page
	self.setupAsk = function(){

		$("#question-similar-loading").hide();
		$("#question-similar-answers, #question-similar-questions").hide();
		$("#new_question input, #new_question textarea").keydown(function(){
			
			if(self.askSimilarLookupTimeout != 0){
				clearTimeout(self.askSimilarLookupTimeout);
			}
			$("#question-similar-loading").slideDown(300);
			self.askSimilarLookupTimeout = setTimeout(self.askSimilarLookup, 1000);
			
		});

	}

	self.askSimilarLookupTimeout = null;

	//Method that gets called every time a field changes in the ask a question form
	//Gets potentially relevant questions and answers and displays them alongside the form
	self.askSimilarLookup = function(){

		//Hide help
		if(!$("#question-help").hasClass("done")){
			$("#question-help").addClass("done");
			$("#question-help").slideUp(400);
		}

		$("#question-similar-answers").slideUp(300);
		$("#question-similar-questions").slideUp(300);

		//Combine title, tags and question as its a trigram search
		$.ajax({
			type: "POST",
			data: {"search": $("#question_title").val() + $("#question_tag_list").val() + $("#question_content").val()},
			url: ("/solver"),
			success: function(data){

				var newAnswers = $(".answers li", $(data));
				var newQuestions = $(".question_list li", $(data));

				if(!$(".answers li", $(data)).length > 0){
					newAnswers = $("<li class=\"no-data\">We couldn't find any possible answers.</li>");
				}
				if(!$(".question_list li", $(data)).length > 0){
					newQuestions = $("<li class=\"no-data\">We couldn't find any possible questions.</li>");
				}
				
				$("li", "#question-similar-answers .answers").remove();
				$("#question-similar-answers .answers").append(newAnswers);
				$("#question-similar-answers").slideDown(300);
			
				$("li", "#question-similar-questions .question_list").remove();
				$("#question-similar-questions .question_list").append(newQuestions);
				$("#question-similar-questions").slideDown(300);

				$("#question-similar-loading").slideUp(300);

			}
		});
		
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
			window.inquestionNotificationInterval = window.setInterval(function(){ inquestionFrontend.notifications.check(); }, 5000);
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
			$(".knowledge-help").hide();
			$(self.knowledgeAreas.knowledgeList).on("click", "li.knowledge", function(){
				if(self.knowledgeAreas.editMode){
					$(this).remove();
				}
			});
		},
		changeToEdit: function(){
			//Add a input box below, change mode to true
			self.knowledgeAreas.editMode = true;
			$(".knowledge-list-btn").html("Save Knowledge Areas");
			$(".knowledge-help").show();
			self.knowledgeAreas.addKnowledge();
		},
		addKnowledge: function(){
			//Spawn a new input box and button
			$(self.knowledgeAreas.knowledgeList).append("<li><form class=\"form\"><div class=\"form-control\"><input type=\"text\" name=\"knowledge-list-new\" placeholder=\"Add new area\"></input></div></form></li>");
			var addKnowledgeButton = $("<li><button class=\"btn btn-block btn-x-small\">Add Knowledge Area</button></li>");
			$(self.knowledgeAreas.knowledgeList).append($(addKnowledgeButton));
			$("button", addKnowledgeButton).click(function(){

				//Validation:
				if($("input", self.knowledgeAreas.knowledgeList).val().length > 0){
					//Add self to list
					//-Remove hashtag incase user has entered it and get value into variable
					var newArea = "#" + ($("input", self.knowledgeAreas.knowledgeList).val()).replace("#", "");
					var newAreaListItem = $("<li class=\"knowledge\"></li>").text(newArea);
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
			$(".knowledge-help").hide();

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
				success: function(){
					self.knowledgeAreas.editMode = false;
				}
			})

		}
	}
	self.sortMenu = function(menu){

		var self = this;

		self.menu = null;
		self.content = null;
		self.visible = false;
		self.init = function(o){

			self.menu = $(o);
			//Find content:
			self.content = $($(self.menu).data("sort-menu"));
			//Attach events:
			self.attachEvents();

		}
		self.attachEvents = function(){
			$(self.menu).click(function(){
				if(self.visible){
					self.doClose();
				}
				else{
					self.doOpen();
				}
				event.preventDefault();
				return false;
			});
			$(window).resize(function(){
				self.resize();
			});
		}
		self.doOpen = function(){

			self.visible = true;
			//Position to the menu
			self.setPosition();
			$(self.content).addClass("active").removeClass("animated flipInX flipOutX").addClass("animated flipInX");

		}
		self.doClose = function(){
			self.visible = false;
			$(self.content).removeClass("animated flipInX flipOutX").addClass("animated flipOutX");
		}
		self.resize = function(){
			self.setPosition();
		}
		self.setPosition = function(){
			var top, right;
			//Get menu position:
			top = ($(self.menu).position()).top + $(self.menu).height() + 10;
			right = $(self.menu).css("right");

			$(self.content).css({"top": top, "right": right});
		}
		self.init(menu);

	}
	//Method to run on every kind of voting link:
	self.vote = function(link){

		var self = this;
		self.element = null;
		self.vote_url = null;
		self.init = function(element){
			self.element = $(element);
			self.vote_url = $(self.element).attr("href");
			self.attachEvents();
		}
		self.attachEvents = function(){
			$(self.element).click(function(){
				self.doVote();
				event.preventDefault();
				return false;
			});
		}
		self.doVote = function(){
			
			$.ajax({
				type: "POST",
				url: (self.vote_url),
				success: function(data){
					$(self.element).text("+" + data.vote_count).removeClass("animated wobble").fadeIn(1).addClass("animated wobble");
				}
			});

		}
		self.init(link);
	}

	self.init();

}

var inquestionFrontend = null;
$(document).ready(function () {

	$(".selectize").selectize({
		highlight: true,
		create: false
	});

	inquestionAdmin = new inquestion_admin();
	inquestionFrontend = new inquestion_frontend();


}).on("page:change", function(){
	$("#main").removeClass("animated fadeInDown fadeOutUp").addClass("animated fadeInDown");
	NProgress.done();
}).on("page:fetch", function(){
	$("#main").removeClass("animated fadeInDown fadeOutUp").addClass("animated fadeOutUp");
	NProgress.start();
}).on('page:restore', function(){
	NProgress.remove();
});
