express = require 'express'
stylus = require 'stylus'
assets = require 'connect-assets'
i18n = require 'i18next'

#
# APP SETUP
#

app = express() # Create Express
app.use assets() # Add Connect Assets
app.use express.static(process.cwd() + '/public') # Set the public folder as static assets
app.set 'view engine', 'jade' # Set View Engine

# Set default lang
lang = 'pl' 

i18n.init 
  resGetPath: 'locales/__lng__.json' # Shorter path for locales
  #lng: "pl-PL" # Uncomment to set defualt language
  fallbackLng: lang
  #load: 'unspecific'

# Jade i18n proccessing
i18n.addPostProcessor "jade", (val, key, opts) ->
   require('jade').compile(val, opts)()

i18n.registerAppHelper app # Register tempalte helper
app.use i18n.handle # Run i18n

# set Asset path for i18n
# You hate to prepare settings.langPath for using locale assets
app.locals
  langPath: () ->
    i18n.t('settings.langPath', {defaultValue: lang })

#
# APP ROUTES
#

# Get root_path return index view
app.get '/*', require('./controllers/home').index

#
# APP START
#

# Define Port
port = process.env.PORT or process.env.VMC_APP_PORT or 3000
# Start Server
app.listen port, -> console.log "Listening on #{port}\nPress CTRL-C to stop server."