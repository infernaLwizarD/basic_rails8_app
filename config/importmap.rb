# Pin npm packages by running ./bin/importmap

pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'bootstrap', to: 'common/plugins/bootstrap.min.js'
pin '@popperjs/core', to: 'common/plugins/popper.min.js'
pin 'adminlte', to: 'common/plugins/adminlte.min.js'
pin 'fontawesome', to: 'common/plugins/fontawesome/fontawesome.min.js'
pin 'fontawesome_solid', to: 'common/plugins/fontawesome/fontawesome_solid.min.js'
