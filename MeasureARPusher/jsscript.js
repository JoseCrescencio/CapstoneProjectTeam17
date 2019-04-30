function DrawPath() {
    var xscale = d3.scale.linear().domain([0,50.0]).range([0,720]);
    var yscale = d3.scale.linear().domain([0,33.79]).range([0,487]);
    var map = d3.floorplan().xScale(xscale).yScale(yscale);
    var overlays = d3.floorplan.overlays().editMode(true);
    
    map.addLayer(overlays);
    
    d3.json("data.json", function(data) {
            mapdata[overlays.id()] = data.overlays;
            
            d3.select("#demo").append("svg")
            .attr("height", 487).attr("width",720)
            .call(map);
            });
    
}
