$(function() {
    $( ".draggable" ).draggable({ grid: [ 60, 60 ] });
    $( ".droppable" ).droppable({
    	drop: function( event, ui ) {
    		$.ajax({
    			type: 'PUT',
    			url: ui.draggable.data('update-url'),
    			dataType: 'json',
    			data: { piece: { x_position: event.target.id[0] , y_position: event.target.id[1] } }
    		});
    	}
    });
  });
