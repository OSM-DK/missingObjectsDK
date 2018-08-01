<!DOCTYPE html>
<html>

  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <meta name="DC.title" content="Manglende danske øer">
    <title><?= $_GET['title'] ?></title>

   <link rel="stylesheet"
         href="https://unpkg.com/leaflet@1.3.1/dist/leaflet.css"
         integrity="sha512-Rksm5RenBEKSKFjgI3a41vrjkw4EVPlJ3+OiI65vTjIdo9brlAacEuKOiQ5OFh7cOI1bkDwLqdLw3Zg0cRJAAQ=="
         crossorigin=""/>
    <style>
      body {
      padding: 0;
      margin: 0;
      }
      html, body, #map {
      height: 99%;
      }
    </style>

  </head>

  <body bgcolor="#ffffff" text="#000000" link="#000099" vlink="#660000">
    <?= $_GET['title'] ?>
    <div id="map"></div>
    <script
			  src="https://code.jquery.com/jquery-3.3.1.min.js"
			  integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
			  crossorigin="anonymous">
    </script>
    <script src="https://unpkg.com/leaflet@1.3.1/dist/leaflet.js"
            integrity="sha512-/Nsx9X4HebavoBvEBuyp3I7od5tA0UzAxs+j83KgC8PU0kgB4XiK4Lfe4y4cgBtaRJQEIFCW+oC506aPT2L1zw=="
            crossorigin="">
    </script>



    <script>

      var attr_osm = 'Map data &copy; <a href="//openstreetmap.org/">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>';
      // var osm = new L.TileLayer('//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {attribution: attr_osm});

      var OpenSeaMapAttribution = 'Map data &copy;  OpenSeaMap contributors';
      var seamarksUrl = 'http://tiles.openseamap.org/seamark/{z}/{x}/{y}.png';
      var seamarks = new L.TileLayer(seamarksUrl, {maxZoom: 18, isBaseLayer: false,attribution: OpenSeaMapAttribution});


      var base = L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}',
                             {
                               attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
                               maxZoom: 18,
                               id: 'mapbox.streets',
                               accessToken: 'pk.eyJ1IjoiZWxoYWFyZCIsImEiOiJjaW9jdWtuMWswMGQ5dnJseWNvYnFwanEzIn0.GLctKgS9FncDi5bPhDzVGg',
                               opacity: 0.7,
                             });

      var sat = L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}',
                            {
                            	attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery &copy; <a href="http://mapbox.com">Mapbox</a>',
                            	maxZoom: 18,
                              id: 'mapbox.satellite',
	                            accessToken: 'pk.eyJ1IjoiZWxoYWFyZCIsImEiOiJjaW9jdWtuMWswMGQ5dnJseWNvYnFwanEzIn0.GLctKgS9FncDi5bPhDzVGg',
                              opacity: 0.6,
                            });

      const addPopUp = (feature, layer) => {
        let props = feature.properties;
        let content = `<h2>${props.navn}</h2>`;
        for (let p in props) {
          content += `<b>${p}:</b> ${props[p]}<br/>`;
        }
        layer.bindPopup(content);
      };


      var map = L.map('map', {
                                 center: new L.LatLng(55.54,11.83),
                                 zoom: 9,
                                 layers: [base,seamarks]
                               });

      var geojsonLayer = new L.GeoJSON(null, { onEachFeature: addPopUp,
                                               style: { "color": "#ff0000",
                                                        "weight": 5,
                                                      },
                                             });
      geojsonLayer.addTo(map);


      var baseLayers = { "Luftfoto": sat,
                         "Kort": base,
                       }

      var overlays   = { 'Sømærker': seamarks,
                         "<?= $_GET['title'] ?>": geojsonLayer
                       };

      L.control.layers( baseLayers, overlays).addTo(map);


      $.getJSON("layers/<?= $_GET['layer'] ?>.geojson", function(data) {
        if (data && data.features) {
          geojsonLayer.addData(data);
        }
      });

    </script>
  </body>
</html>
