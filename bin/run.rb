require_relative "../config/environment.rb"
require "pry"

30.times do
  puts " "
end
puts "Welcome to Restaurant Suggester!".colorize(:green)
puts "-----".colorize(:light_magenta) * 10

current_user = find_or_create_user

run_logic(current_user)
