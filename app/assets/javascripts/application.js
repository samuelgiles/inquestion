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

}

var inquestionAdmin = new inquestion_admin();

function inquestion_frontend(){
	
	var self = this;

	self.init = function(){

		if($("#question-help").length > 0){

			self.setupAsk();

		}

		self.notifications.setup();

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