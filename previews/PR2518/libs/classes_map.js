'use strict'

if (document.getElementById('classes-map')) {
    var classesMap = L.map('classes-map').setView([20, 15], 2);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
        noWrap: true
    }).addTo(classesMap);

    var classesMarkers = L.markerClusterGroup({
        iconCreateFunction: function(cluster) {
            return new L.DivIcon({
                html: '<div><span>' + cluster.getChildCount() + '</span></div>',
                className: 'cluster',
                iconSize: new L.Point(40, 40)
            });
        },
        maxClusterRadius: 10
    });

    for (const uni of classes_locations) {
        var color = uni.section === 'active' ? '#9558B2' : '#888';
        var marker = L.circleMarker([uni.lat, uni.lon], {
            color: color,
            fillColor: color,
            fillOpacity: 0.5,
            radius: 7
        });
        marker.bindPopup('<b>' + uni.name + '</b><br><em>' + (uni.section === 'active' ? 'Active' : 'Historical') + '</em>');
        classesMarkers.addLayer(marker);
    }

    classesMap.addLayer(classesMarkers);
}
