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


  if( $('#world-map').length > 0 )
  {
    $.getJSON('/interests/edit.json', function(data){
      
      var map =  new jvm.WorldMap({

        onRegionClick: function(e, code) {
          alert("You clicked "+code);
        },

        container: $('#world-map'),

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

        markers: data

      });
    });
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
      events: $('#free_calendar_url').attr('value')
    }); 
  }

  if( $('#user_calendar').length > 0 )
  {
    $('#user_calendar').fullCalendar({
      events: $('#user_calendar_url').attr('value')
    }); 
  }
  
});