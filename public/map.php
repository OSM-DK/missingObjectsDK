<!DOCTYPE html>
<html>

  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <meta name="DC.title" content="<?= $_GET['title'] ?>">
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

      #spinner {
	display: none;
      }
      #spinner.active {
        text-align: center;
	display: block;
	background: white;
        border: 1px solid grey;
        position:absolute;
        top:40%;
	left:40%;
        padding: 20px;
        z-index: 1000;
      }
      .html-spinner {
          margin: auto;
	  width:40px;
  	  height:40px;
  	  border:4px solid grey;
  	  border-top:4px solid blue;
   	  border-radius:50%;
          -webkit-transition-property: -webkit-transform;
          -webkit-transition-duration: 1.2s;
          -webkit-animation-name: rotate;
          -webkit-animation-iteration-count: infinite;
          -webkit-animation-timing-function: linear;

          -moz-transition-property: -moz-transform;
          -moz-animation-name: rotate;
          -moz-animation-duration: 1.2s;
          -moz-animation-iteration-count: infinite;
          -moz-animation-timing-function: linear;

          transition-property: transform;
          animation-name: rotate;
          animation-duration: 1.2s;
          animation-iteration-count: infinite;
          animation-timing-function: linear;
      }

      @-webkit-keyframes rotate {
         from {-webkit-transform: rotate(0deg);}
         to {-webkit-transform: rotate(360deg);}
      }

      @-moz-keyframes rotate {
        from {-moz-transform: rotate(0deg);}
        to {-moz-transform: rotate(360deg);}
      }

      @keyframes rotate {
        from {transform: rotate(0deg);}
        to {transform: rotate(360deg);}
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

    <div id="spinner"><div class="html-spinner"></div><br/>Henter data...</div>

    <script>

      var attr_osm = 'Map data &copy; <a href="//openstreetmap.org/">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>';

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
	if (props.tags && !props.navn) {
           try {
	     props = JSON.parse(props.tags);
           } catch (e) {
             console.log("Could not parse json", props.tags, e);
           }
        }
        let content = `<h2>${props.navn || props.name}</h2>`;
        for (let p in props) {
          content += `<b>${p}:</b> ${props[p]}<br/>`;
        }
        layer.bindPopup(content);
      };


      var map = L.map('map', {
                                 center: new L.LatLng(56.00,10.83),
                                 zoom: 8,
                                 layers: [base]
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


      $('#spinner').addClass('active');
      $.getJSON("layers/<?= $_GET['layer'] ?>.geojson", function(data) {
	$('#spinner').removeClass('active');
        if (data && data.features) {
          geojsonLayer.addData(data);
        } else {
          alert("Could not load layer <?= $_GET['layer'] ?>");
	}
      });

    </script>
  </body>
</html>
