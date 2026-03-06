'use strict';

function addIcon(service, account) {
    if (service === 'homepage') {
        return `<a id="img-link" href="${account}" target="_blank" rel="noreferrer noopener"><i class="fa fa-globe" aria-hidden="true"></i></a> `;
    }
    return `<a id="img-link" href="${account}" target="_blank" rel="noreferrer noopener"><i class="fa fa-${service} fa-lg" aria-hidden="true"></i></a> `;
}

function popupText(group) {
    let s = `<b>${group.name}</b></br>`;

    if (group.homepage != null) {
        s += addIcon('homepage', group.homepage);
    }
    if (group.github != null) {
        s += addIcon('github', group.github);
    }
    if (group.gitlab != null) {
        s += addIcon('gitlab', group.gitlab);
    }
    if (group.twitter != null) {
        s += addIcon('twitter', group.twitter);
    }
    if (group.linkedin != null) {
        s += addIcon('linkedin', group.linkedin);
    }

    return s;
}

function addMarker(markers, group) {
    const marker = L.circleMarker([group.lat, group.lon], {
        color: 'red',
        fillColor: '#f03',
        fillOpacity: 0.5,
        radius: 10
    });
    marker.bindPopup(popupText(group));
    markers.addLayer(marker);
}

if (document.getElementById('map')) {
    const map = L.map('map').setView([20, 15], 2);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
        noWrap: true
    }).addTo(map);

    const markers = L.markerClusterGroup({
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
        addMarker(markers, group);
    }

    map.addLayer(markers);
}
