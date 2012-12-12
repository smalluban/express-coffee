express = require 'express'
assets = require 'connect-assets'
i18n = require 'i18next'
fs = require 'fs'

#
# APP SETUP
#

app = express() # Create Express
app.use assets() # Add Connect Assets
app.use express.static(process.cwd() + '/public') # Set the public folder as static assets
app.set 'view engine', 'jade' # Set View Engine

# Set default lang
lang = 'en' 

i18n.init 
  resGetPath: 'locales/__lng__.json' # Shorter path for locales
  #lng: "pl-PL" # Uncomment to set defualt language
  fallbackLng: lang
  #load: 'unspecific'

# Jade i18n proccessing
i18n.addPostProcessor "jade", (val, key, opts) ->
   require('jade').compile(val, opts)()

i18n.registerAppHelper app # Register tempalte helper
app.use i18n.handle # Run i18n as handle

app.get '/assets/:file', (req, res) -> # Set static path for multilanguage assets
  file = req.params.file
  lng = i18n.lng()

  #check if file exists
  if not fs.existsSync(process.cwd() + '/public/_' + lng + '/' + file)
    lng = lng.replace(/\-.*/,'')
    if not fs.existsSync(process.cwd() + '/public/_' + lng + '/' + file) then lng = lang
      
  res.sendfile './public/_' + lng + '/' + file, maxAge: 60 * 60 * 24

#
# APP ROUTES
#

# Get root_path return index view
app.get '/*', (req, resp) -> 
  resp.render 'index'
  
#
# APP START
#

# Define Port
port = process.env.PORT or process.env.VMC_APP_PORT or 3000
# Start Server
app.listen port, -> console.log "Listening on #{port}\nPress CTRL-C to stop server."