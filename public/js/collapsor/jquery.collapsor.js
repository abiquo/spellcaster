/*
* collapsor (1.1) // 2009.02.27 // <http://plugins.jquery.com/project/collapsor>
* 
* REQUIRES jQuery 1.2.3+ <http://jquery.com/>
* 
* Copyright (c) 2008 TrafficBroker <http://www.trafficbroker.co.uk>
* Licensed under GPL and MIT licenses
* 
* collapsor opens and closes sublevel elements, like a collapsable menu
*
* We need to select the clickable elements that trigger the opening action of the sublevels: $('#menu ul li a').collapsor();
* The sublevel element must be in the same level than the triggers
*
* Sample Configuration:
* $('ul a').collapsor();
* 
* Config Options:
* openClass: Class added to the element when is open // Default: 'open'
* sublevelElement: Element that must open or close // Default: 'ul'
* closeOthers: Close other elements when opening // Default: false
* speed: Speed for the opening animation // Default: 500
* easing: Easing for the opening animation. Other than 'swing' or 'linear' must be provided by plugin // Default: 'swing'
* 
* We can override the defaults with:
* $.fn.collapsor.defaults.speed = 1000;
* 
* @param  settings  An object with configuration options
* @author    Jesus Carrera <jesus.carrera@trafficbroker.co.uk>
*/
(function($) {
$.fn.collapsor = function(settings) { 
	// override default settings
	settings = $.extend({}, $.fn.collapsor.defaults, settings);
	var triggers = this;
	// for each element
	return this.each(function() {
		// occult the collapsing elements
		$(this).find('+ ' + settings.sublevelElement).hide();
		//show the opened
		if($(this).hasClass(settings.openClass)){
			$(this).find('+ ' + settings.sublevelElement).show();
		}
		// event handling
	  $(this).click(function() {
			// if the new active have sublevels
			if ($(this).next().is(settings.sublevelElement)){
				// blur and add the open class to the clicked
				$(this).blur().toggleClass(settings.openClass);
				// close others
				if (settings.closeOthers == true) {
				  $(this).parent().parent().children().find('.'+settings.openClass).not(this).removeClass(settings.openClass).next().animate({height:'toggle', opacity:'toggle'}, settings.speed, settings.easing);
				}
				// toggle the clicked
				$(this).next().animate({height:'toggle', opacity:'toggle'}, settings.speed, settings.easing);
				return false;
			}
	   });
	});
};
// default settings
$.fn.collapsor.defaults = {
	openClass:'open',
	sublevelElement: 'ul',
	closeOthers: false,
	speed: 500,
	easing: 'swing'
};
})(jQuery);