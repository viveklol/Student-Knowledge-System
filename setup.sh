sudo apt install imagemagick
bundle install
bundle exec rake assets:precompile

rake db:migrate 
rake db:seed 
rake spec 
rake cucumber