      // Set page title
      var pageTitle = params.title || document.title || 'Manglende objekter';
      document.title = pageTitle;
      $('#pageheader').text( pageTitle );


      var defaultPointColor = '#33f';
      var defaultLineColor  = '#f00';

      // Set up layers from arguments
      var layers = [];
      if (params.layer) {
         layers.push( { name: params.layer, title: pageTitle, show: true, pointColor: defaultPointColor, lineColor: defaultLineColor } );
      } else if (params.layers) {
        var layerNames  = params.layers.split(';');
        var layerTitles = params.titles      ? params.titles.split(';')                                                         : [];
        var pointColors = params.pointColors ? params.pointColors.split(';')                                                    : [];
        var lineColors  = params.lineColors  ? params.lineColors.split(';')                                                     : [];
        var hideLayers  = params.hideLayers  ? params.hideLayers.split(';').map( function(v) { return v.match(/^[1yYtT]$/); } ) : [];

        for (var i = 0; i < layerNames.length; i++) {
           layers.push( { name: layerNames[i],
                          title: layerTitles[i] || `${pageTitle} ${i > 0 ? i + 1 : ''}`,
                          show: !hideLayers[i],
                          pointColor: pointColors[i] || defaultPointColor,
                          lineColor: lineColors[i] || defaultLineColor
                        }
                      );
        }
      }

      var feature2tags = {};
      var features = [];

      const props2name = function (props){
         return props.navn || props.name || props.strandnr || props.ref || (props['addr:street'] + ' ' + props['addr:housenumber']);
      };


      // Set up base map
      var currentZoom = 8;

      var attr_osm = 'Map data &copy; <a href="//openstreetmap.org/">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>';

      var OpenSeaMapAttribution = 'Map data &copy;  OpenSeaMap contributors';
      var seamarksUrl = 'http://tiles.openseamap.org/seamark/{z}/{x}/{y}.png';
      var seamarks = new L.TileLayer(seamarksUrl, {maxZoom: 18, isBaseLayer: false,attribution: OpenSeaMapAttribution});


      var base = L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                             {
                               attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
                               maxZoom: 18,
                               id: 'mapbox/streets-v11',
                               accessToken: 'pk.eyJ1IjoiZWxoYWFyZCIsImEiOiJja244MDM5MnAwZDF3Mm9tcXgxcWYyOXZpIn0.VKOD84uZNW0M6-D0-AnVyA',
                               opacity: 0.7,
                             });

      var sat = L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                            {
                              attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery &copy; <a href="http://mapbox.com">Mapbox</a>',
                              maxZoom: 18,
                              id: 'mapbox/satellite',
                              accessToken: 'pk.eyJ1IjoiZWxoYWFyZCIsImEiOiJja244MDM5MnAwZDF3Mm9tcXgxcWYyOXZpIn0.VKOD84uZNW0M6-D0-AnVyA',
                              opacity: 0.6,
                            });

      var map = L.map('map', {
                                 center: new L.LatLng(56.00,10.83),
                                 zoom: currentZoom,
                                 layers: [base],

                             });

      var bbox2zoom = function(bbox) {
          return map.getBoundsZoom([ [bbox.top, bbox.left],
				     [bbox.bottom, bbox.right]
				   ]);
      };



      var openEditorBBox = function(editor, idx) {

	var openUrl = editor.buildBBoxUrl(bbox);
        var w = window.open(openUrl);
        if (editor.timeout) {
            setTimeout(function() {w.close();}, editor.timeout);
        }
      };



      // Setup editors
      var editors = {
            Id: { url: 'https://www.openstreetmap.org/edit?editor=id#map=',
                  displayName: "iD",
                  buildUrl: function (map) {
                     return editors.Id.url + [
                        map.getZoom(),
                        map.getCenter().wrap().lat,
                        map.getCenter().wrap().lng
                      ].join('/');
                  },
                  openFunc: function(idx) {
		      let feature = features[idx];
		      var bbox = geometry2bbox(feature.geometry, 0.0015);
		      var openUrl = editors.Id.url + [
                                                       bbox2zoom(bbox),
                                                       (bbox.top + bbox.bottom) / 2,
                                                       (bbox.left + bbox.right) / 2
                                                     ].join('/');
		      window.open(openUrl);
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
                   },
		   openFunc: function(idx) {
                       const feature = features[idx];
		       const bbox = geometry2bbox(feature.geometry, 0.0015);
		       const openUrl = editors.Josm.url + L.Util.getParamString(bbox);
		       return $.getJSON(openUrl);
		       
		   },
                   addFunc: function(idx) {
		       const feature = features[idx];
		       const props = feature.properties;
		       const name = props2name(props);
		       let tagList = [...(feature2tags[props.featuretype] || [])];
		       tagList.push(`name=${name}`);

		       const coords = normalizeCoordinates(feature.geometry.coordinates);
		       let url = 'http://127.0.0.1:8111/';
		       if (coords.length == 1) {
			   url += `add_node?lon=${coords[0][1]}&lat=${coords[0][0]}`;
                       } else {
			   url += 'add_way?way='
			       + coords.map((c) => `${c[1]},${c[0]}`).join(';');
		       }
		       
		       url += '&addtags=' + encodeURIComponent(tagList.join("|"));
		       $.getJSON(url).then(() => editors.Josm.openFunc(idx));
		   },
            }
      };

      var openEditor = function(editor) {
	var openUrl = editor.buildUrl(map);
        var w = window.open(openUrl);
        if (editor.timeout) {
            setTimeout(function() {w.close();}, editor.timeout);
        }
      };

      // Helper function that flattens coordinates and lists of coordinates to a list of coordinates in one level
      var normalizeCoordinates = function(coordinates, existing) {
        var arr = existing || [];

          if (! Array.isArray(coordinates[0]) ) {
            arr.push(coordinates);
          } else {
            for (var i=0; i < coordinates.length; i++) {
              normalizeCoordinates( coordinates[i], arr );
            }
          }

        return arr;
      }


      // Helper function to find the bounding box for a geometry
      var geometry2bbox = function(geom, padding) {
	if (!geom || !geom.coordinates || !Array.isArray(geom.coordinates)) {
          return null;
        }

        var coords = normalizeCoordinates(geom.coordinates);

	// Set bbox to the first coordinate
        var res = { 'top'   : coords[0][1],
                    'bottom': coords[0][1],
                    'left'  : coords[0][0],
                    'right' : coords[0][0]
                  };

	// Loop through all coordinates and adjust the bbox to fit all
        for (var i = 1; i < coords.length; i++) {
          var x = coords[i][0];
          var y = coords[i][1];
          if (x < res.left) {
            res.left = x;
          }
          if (x > res.right) {
            res.right = x;
          }
          if (y < res.bottom) {
            res.bottom = y;
          }
          if (y > res.top) {
            res.top = y;
          }
        }

	// Add padding
        if (padding && padding > 0) {
          res.left -= padding;
          res.right += padding;
          res.top += padding;
          res.bottom -= padding;
        }
        return res;
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


      if (params.show_seamarks) {
        seamarks.addTo(map);
      }
      var overlays   = { 'Sømærker': seamarks };

      // Function to add popups to all features
      const addPopUp = (feature, layer) => {
        const idx = features.length;
        features.push(feature);

        let props = feature.properties;
	if (props.tags && !props.navn) {
           props = props.tags;
        }
        let content = `<h2>${props2name(props)}</h2>`;
        for (let p in props) {
          content += `<b>${p}:</b> ${props[p]}<br/>`;
        }
        for (edName in editors) {
	   var ed = editors[edName];
           content += `<br/><button onclick="editors['${edName}'].openFunc(${idx});">${ed.displayName}</button>`;
           if (ed.addFunc && props.featuretype && feature2tags[props.featuretype]) {
             content += `<button onclick="editors['${edName}'].addFunc(${idx})">+</button>`;
           }
	}
        layer.bindPopup(content);
      };



      var pointMaker = function(idx) {
        return function(feature, latlng) {
          return new L.Marker(latlng, { icon: layers[idx].icon });
        }
      };

      // Add layers to the map
      for (var i = 0; i < layers.length; i++) {
        layers[i].icon = new L.divIcon({ className: 'point-marker',
                                         iconAnchor: [0, 12],
                                         labelAnchor: [-6, 0],
                                         popUpAnchor: [0, -36],
                                         html: `<span style="background-color: ${layers[i].pointColor}" />`});

        layers[i].geoJsonLayer = new L.GeoJSON(null, { onEachFeature: addPopUp,
                                                style: { "color": layers[i].lineColor,
                                                         "weight": 5,
                                                       },
                                                pointToLayer: pointMaker(i)
                                              });

        if (params.heatlevel) {
          layers[i].heatLayer = new L.heatLayer([], {radius: 15,
                                                     gradient: {
                                                        0.3: 'lime',
                                                        0.6: 'yellow',
                                                        0.9: 'red',
                                                        1: 'black',
                                                     },
                                                     maxZoom: params.heatlevel,
                                                     max: 0.5,
                                                     radius: 10,
                                                    });

          layers[i].layer = new L.layerGroup.conditional()
                                 .addConditionalLayer( function(zoom){ return zoom > params.heatlevel  }, layers[i].geoJsonLayer)
                                 .addConditionalLayer( function(zoom){ return zoom <= params.heatlevel }, layers[i].heatLayer);


        } else {
          layers[i].layer = layers[i].geoJsonLayer;
        }

        if (layers[i].show) {
          layers[i].layer.addTo(map);
        }
        overlays[ layers[i].title ] = layers[i].layer;
      }

      // Set up layer control
      var baseLayers = { "Luftfoto": sat,
                         "Kort": base,
                       };


      L.control.layers( baseLayers, overlays).addTo(map);

      const zoomToFeature = function(f) {
         const feature = features.filter(f)[0];
         if (feature) {
           const bbox = geometry2bbox(feature.geometry);
           map.fitBounds([[bbox.top, bbox.left], [bbox.bottom, bbox.right]]);
         }
      }

      let initializing = true;

      // Change handler
      var handleChanges = function() {
        let zoom = map.getZoom();
        if (params.heatlevel) {
          for (let j = 0; j < layers.length; j++) {
            layers[j].layer.updateConditionalLayers(zoom);
          }
        }

        let loaded = true;
        let rendered = true;
        for (let j = 0; j < layers.length; j++) {
          if (layers[j].show && !layers[j].hasError) {
            if (params.heatlevel && zoom<=params.heatlevel) {
              if (!layers[j].heatLoaded) {
                loaded = false;
                rendered = false;
                break;
              }
              if (!layers[j].heatRendered) {
                rendered = false;
              }
            } else {
              if (!layers[j].geoJsonLoaded) {
                loaded = false;
                rendered = false;
                break;
              }
              if (!layers[j].geoJsonRendered) {
                rendered = false;
              }
            }
          }
        }

        if (!loaded) {
           $('#spinnertext').text('Henter data...');
           $('#spinner').addClass('active');
        } else if (!rendered) {
           $('#spinnertext').text('Tegner kortet...');
           $('#spinner').addClass('active');
        } else {
           $('#spinner').removeClass('active');
           if (initializing) {
             initializing = false;
             if (params.featureid) {
               zoomToFeature(f => f.properties.featureid == params.featureid);
             }
           }
        }
      }

      var getFeaturePromise = $.getJSON('feature2tags.json')
         .then((data) => {
	   feature2tags = data;
         })
         .catch((err) => alert(`Kunne ikke hente feature-liste:\n${err}`));

      var gotGJLayer = function(idx, data) {
        if (data && data.features) {
          layers[idx].geoJsonLoaded = true;
          handleChanges();
          getFeaturePromise.then(() =>
            setTimeout( function() {
              layers[idx].geoJsonLayer.addData(data);
              layers[idx].geoJsonRendered = true;
              handleChanges();
            }, 10)
          );
        } else {
          layers[idx].hasError = true;
          handleChanges();
          alert(`Lag ${layers[idx].name} har defekt data`);
        }
      };

      var gotHeatLayer = function(idx, data) {
        if (data && Array.isArray(data)) {
          layers[idx].heatLoaded = true;
          handleChanges();
          setTimeout( function() {
            layers[idx].heatLayer.setLatLngs(data);
            layers[idx].heatRendered = true;
            handleChanges();
          }, 10);
        } else {
          layers[idx].hasError = true;
          handleChanges();
          alert(`Lag ${layers[idx].name} har defekt heatmap-data`);
        }
      }

      var getGJLayer = function(idx) {
        $.getJSON(`layers/${layers[idx].name}.geojson`, function(data) {
          gotGJLayer(idx, data);
        })
        .fail(function() {
          layers[idx].hasError = true;
          handleChanges();
          alert(`Kunne ikke hente data for ${layers[idx].name}`);
        });
      };

      var getHeatLayer = function(idx) {
        $.getJSON(`layers/${layers[idx].name}_heat.json`, function(data) {
          gotHeatLayer(idx, data);
        })
        .fail(function() {
          layers[idx].hasError = true;
          handleChanges();
          alert(`Kunne ikke hente heatmap-data for ${layers[idx].name}`);
        });
      };

      handleChanges();

      // Get data
      if (params.heatlevel) {
        for (var i = 0; i < layers.length; i++) {
          getHeatLayer(i);
        }
      }

      for (var i = 0; i < layers.length; i++) {
        getGJLayer(i);
      }

      // Bind handler to events
      map.on('zoomend', handleChanges);
      for (var i = 0; i < layers.length; i++) {
        layers[i].layer.on('add', handleChanges);
        layers[i].layer.on('remove', handleChanges);
      }

