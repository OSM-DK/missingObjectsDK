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
        border: 1px solid #ddd;
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
  	  border:4px solid #ccc;
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


      .editor-container {
         background: none repeat scroll 0 0 #F8F8F9;
         border: 1px solid #888888;
         border-radius: 5px 5px 5px 5px;
         box-shadow: 0 0 8px rgba(0, 0, 0, 0.4);
      }

      .editor-container a.osm-editor {
         display: inline-block;
         height: 36px;
         min-width: 36px;
         text-align: center;
         line-height: 36px;
         color: #333;
         padding: 0 5px;
         text-decoration: none;
         font-family: sans-serif;
      }

      a.osm-editor:hover {
         box-shadow: 0 0 2px 0 black inset;
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

    <div id="spinner"><div class="html-spinner"></div><br/><span id="spinnertext">Henter data...</span></div>

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
           props = props.tags;
        }
        let content = `<h2>${props.navn || props.name || (props['addr:street'] + ' ' + props['addr:housenumber'])}</h2>`;
        for (let p in props) {
          content += `<b>${p}:</b> ${props[p]}<br/>`;
        }
        layer.bindPopup(content);
      };


      var map = L.map('map', {
                                 center: new L.LatLng(56.00,10.83),
                                 zoom: 8,
                                 layers: [base],

                             });

      var editors = {
            Id: { url: 'https://www.openstreetmap.org/edit?editor=id#map=',
                  displayName: "iD",
                  buildUrl: function (map) {
                     return editors.Id.url + [
                        map.getZoom(),
                        map.getCenter().wrap().lat,
                        map.getCenter().wrap().lng
                      ].join('/');
                  }
            },
            Josm: {
                   url: 'http://127.0.0.1:8111/load_and_zoom',
                   timeout: 1000,
                   displayName: "JOSM",
                   buildUrl: function (map) {
                     var bounds = map.getBounds();
                     return editors.Josm.url + L.Util.getParamString({
                            left: bounds.getNorthWest().wrap().lng,
                            right: bounds.getSouthEast().wrap().lng,
                            top: bounds.getNorthWest().wrap().lat,
                            bottom: bounds.getSouthEast().wrap().lat
                        });
                    }
            }
      };

      var openEditor = function(editor) {
	var openUrl = editor.buildUrl(map);
        var w = window.open(openUrl);
        if (editor.timeout) {
            setTimeout(function() {w.close();}, editor.timeout);
        }
      };


      var editorControl = L.Control.extend ({
        options: { position: 'topright'},

        initialize: function( options ) {
          L.setOptions(this, options);
        },

        onAdd: function(mapArg) {
          var editorContainer = L.DomUtil.create('div', 'editor-container');
          editorContainer.title = '';
          for (edName in editors) {
	    var ed = editors[edName];
            var widget = L.DomUtil.create('a', 'osm-editor', editorContainer);
            widget.href = '#';
            widget.innerText = ed.displayName;
            (function(editor) {
              L.DomEvent.on(widget, "click", function(e) {
                 openEditor(editor);
                 L.DomEvent.stop(e);
              });
            })(ed);
          }
          return editorContainer;
        },

        onRemove: function() {
        }

      });
      (new editorControl()).addTo(map);

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
        if (data && data.features) {
          $('#spinnertext').text('Tegner kortet...');
          setTimeout( function() {
            geojsonLayer.addData(data);
	    $('#spinner').removeClass('active');
            $('#spinnertext').text('Henter data...');
          }, 10);
        } else {
          $('#spinner').removeClass('active');
          alert("Could not load layer <?= $_GET['layer'] ?>");
	}
      });

    </script>
  </body>
</html>
