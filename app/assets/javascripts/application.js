// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require fullcalendar
//= require bootstrap-datepicker
//= require jvectormap
//= require jvectormap/maps/us_merc_en
//= require jvectormap/maps/world_mill_en
//= require_tree .


$(document).on('ready page:load', function() {

  $(".region-panel-link").on("click", function(){

    panel_title = $(this).parents('.panel-title').find('.glyphicon');

    if( panel_title.hasClass('glyphicon-menu-right') )
    {
      panel_title.removeClass('glyphicon-menu-right');
      panel_title.addClass('glyphicon-menu-down');
    }
    else
    {
      panel_title.removeClass('glyphicon-menu-down');
      panel_title.addClass('glyphicon-menu-right');
    }

  });

  if( $('#world-map').length > 0 )
  {
    $.getJSON('/interests/edit.json', function(data){

      all_markers = data["all_markers"];
      selected_markers = data["selected_markers"];
      
      console.log(selected_markers);

      var map =  new jvm.WorldMap({

        onRegionClick: function(e, code) {
          console.log("You clicked "+code);
        },

        container: $('#world-map'),

        backgroundColor: "transparent",

        markersSelectable: true,

        markerStyle: {
          initial: {
            fill: '#F8E23B',
            stroke: '#383f47'
          }
        },

        series: {
          regions: [{
            attribute: 'fill'
          }]
        },

        markers: all_markers,

        selectedMarkers: selected_markers,

        onMarkerClick: function(e, code) {
          $.post( "/interests/toggle", { id: all_markers[code].id } );
          console.log("You clicked "+all_markers[code].name+", id: "+all_markers[code].id);
        }

      });      
    });

    $('#destination_edit_map').addClass('active');
    $('#destination_edit_list').removeClass('active');
  }

  if ( $('#world-list').length > 0 )
  {
    $('#destination_edit_map').removeClass('active');
    $('#destination_edit_list').addClass('active');
  }

  $('#calendar').fullCalendar({

    events: '/busy_intervals.json',

    dayClick: function(date, jsEvent, view) {
      $.post( "/busy_intervals", { date: date.format() } );
    },

    eventClick: function(calEvent, jsEvent, view) {
      $.ajax({ url: "/busy_intervals/"+calEvent.id, type: 'DELETE' } );
    }

  });

  $('#my_datepicker .input-daterange').datepicker({
    autoclose: true,
    todayHighlight: true,
    format: "yyyy-m-d"
  });

  $('.datepicker').datepicker({
    autoclose: true,
    todayHighlight: true,
    format: "yyyy-m-d",
    orientation: "top"
  });

  if( $('#free_calendar').length > 0 )
  {
    $('#free_calendar').fullCalendar({
      // TODO don't need this super secret div, can just get current url and add .json
      events: $('#free_calendar_url').attr('value')
    });

    start_date = $('#free_calendar_start').attr('value');
    
    $('#free_calendar').fullCalendar( 'gotoDate', start_date )
  }

  if( $('#user_calendar').length > 0 )
  {
    $('#user_calendar').fullCalendar({
      events: $('#user_calendar_url').attr('value')
    }); 
  }

  $("#edit_destinations").on("click", '.destination-toggle', function(){
    $(this).parents('form').submit();
  });
  
});