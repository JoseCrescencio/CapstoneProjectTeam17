function drawRoom(jsonString) {
    var roomData = JSON.parse(jsonString);
    
    var lineFunction = d3.line()
    .x(function(d) { return d.x; })
    .y(function(d) { return d.y; });
    
    var svgContainer = d3.select('body').append('svg')
    .attr('width', 310)
    .attr('height', 310);
    
    for (var room in roomData) {
        
        var lineGraph = svgContainer.append('path')
        .attr('d', lineFunction(roomData[room]))
        .attr('stroke', 'blue')
        .attr('stroke-width', 2)
        .attr('fill', 'none');
    }
    
}
