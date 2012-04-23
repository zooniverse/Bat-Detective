$ = require 'jQuery'
require 'lib/leaflet'

styleTags = '''
  <link rel="stylesheet" href="styles/lib/leaflet/leaflet.css" />
  <!--[if lte IE 8]>
      <link rel="stylesheet" href="styles/lib/leaflet/leaflet.ie.css" />
  <![endif]-->
'''

head = $('head')
head.append styleTags unless !!~head.html().indexOf 'leaflet.css'

exports = L
