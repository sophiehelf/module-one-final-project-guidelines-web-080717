require 'bundler'
require "require_all"
require "launchy"
require "colorize"
Bundler.require
ActiveRecord::Base.logger = false
require_rel '../lib'
require_rel '../app'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: '../db/development.db')
