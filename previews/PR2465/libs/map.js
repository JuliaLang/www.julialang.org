'use strict'

function add_icon(service, account) {
    if (service === 'homepage') {
        return `<a id="img-link" href="${account}" target="_blank" rel="noreferrer noopener"><i class="fa fa-globe" aria-hidden="true"></i></a> `;
    } else {
        return `<a id="img-link" href="${account}" target="_blank" rel="noreferrer noopener"><i class="fa fa-${service} fa-lg" aria-hidden="true"></i></a> `;
    }
}


function popup_text(group) {
    var s = `<b>${group.name}</b></br>`

    if (group.homepage != undefined) {
        s += add_icon('homepage', group.homepage);
    }

    if (group.github != undefined) {
        s += add_icon('github', group.github);
    }

    if (group.gitlab != undefined) {
        s += add_icon('gitlab', group.gitlab);
    }

    if (group.twitter != undefined) {
        s += add_icon('twitter', group.twitter);
    }

    if (group.linkedin != undefined) {
        s += add_icon('linkedin', group.linkedin);
    }

    return s;
}

function add_marker(markers, group) {
    var marker = L.circleMarker([group.lat, group.lon], {
        color: 'red',
        fillColor: '#f03',
        fillOpacity: 0.5,
        radius: 10
    });
    marker.bindPopup(popup_text(group));

    markers.addLayer(marker);
}

var map = L.map('map').setView([20, 15], 2);

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    noWrap: true
}).addTo(map);

var markers = L.markerClusterGroup({
    iconCreateFunction: function(cluster) {
        return new L.DivIcon({
            html: '<div><span>' + cluster.getChildCount() + '</span></div>',
            className: 'cluster',
            iconSize: new L.Point(40, 40)
        });
    },
    maxClusterRadius: 10
});

for (const group of groups) {
    add_marker(markers, group);
}

map.addLayer(markers)