require "pry"
require_relative "apicontroller.rb"

def get_user_input
  gets.chomp.downcase
  # STDIN.gets.chomp.downcase
end

def find_or_create_user
  puts "Please enter a username. If you don't have one, we'll create it for you!".colorize(:light_cyan)
  input = get_user_input
  puts "Welcome #{input.capitalize}!".colorize(:green)
  User.find_or_create_by(username: input)

end

def selection_ids
  {
    "american" => 1,
    "chinese" => 25,
    "barbecue" => 193,
    "breakfast" => 182,
    "cafe" => 30,
    "cajun" => 491,
    "deli" => 192,
    "desserts" => 100,
    "fast food" => 40,
    "french" => 45,
    "greek" => 156,
    "indian" => 148,
    "italian" => 55,
    "japanese" => 60,
    "korean" => 67,
    "mexican" =>73,
    "pizza" => 82,
    "puerto rican" => 361,
    "sushi" => 177,
    "steak" => 141,
    "thai" => 95,
    "vietnamese" =>99
  }
end

def print_cuisines
  selection_ids.each do |key, value|
    puts "--------------".colorize(:light_magenta)
    puts "#{key.capitalize}".colorize(:green)
    puts "--------------".colorize(:light_magenta)
  end
end

def choose_a_cuisine
  print_cuisines
  puts "Please enter a type of cuisine you would like to search for. The search may take a moment.".colorize(:light_cyan)
  cuisine = get_user_input
  if selection_ids.keys.include?(cuisine)
    ApiController.get_api_data(selection_ids[cuisine])
  else
    puts "Sorry, that cuisine is not in our databse.".colorize(:red)
    choose_a_cuisine
  end
end

def main_menu(current_user)
  5.times{puts " "}
  puts "What would you like to do?".colorize(:green)
  puts "-----".colorize(:light_magenta) * 10
  puts "- Look for new restaurants - type".colorize(:light_cyan) +  " 'L'".colorize(:yellow)
  puts "- View your liked restaurants - type".colorize(:light_cyan) + " 'V'".colorize(:yellow)
  puts "- To logout and exit - type".colorize(:light_cyan) + " 'E'".colorize(:yellow)
   answer = get_user_input
  if answer != "v" && answer != "l" && answer != "e"
  	puts "Please enter a valid answer.".colorize(:red)
    puts "-----".colorize(:light_magenta) * 10
  	run_logic(current_user)
  end
  answer
end

def get_restaurant_card(restaurant_array)
  restaurant_array.shift
end

def display_restaurant(restaurant_atts)
  5.times{puts " "}
  puts "Name of Restaurant:".colorize(:green) + " #{restaurant_atts[:name]}".colorize(:light_cyan)
  puts "-----".colorize(:light_magenta) * 10
  puts "Restaurant Menu + Website:".colorize(:green) + " #{restaurant_atts[:url]}".colorize(:light_cyan)
  puts "-----".colorize(:light_magenta) * 10
  puts "Restaurant Address:".colorize(:green) + " #{restaurant_atts[:address]}, #{restaurant_atts[:locality]}".colorize(:light_cyan)
  puts "-----".colorize(:light_magenta) * 10
  puts "Price Range out of 5:".colorize(:green) + " #{restaurant_atts[:price_range]}".colorize(:light_cyan)
  puts "-----".colorize(:light_magenta) * 10
  puts "Customer Rating out of 5:".colorize(:green) + " #{restaurant_atts[:rating]}".colorize(:light_cyan)
end

def get_restaurant_atts(restaurant_card){
  name: restaurant_card["restaurant"]["name"],
  url: restaurant_card["restaurant"]["url"],
  address: restaurant_card["restaurant"]["location"]["address"],
  locality: restaurant_card["restaurant"]["location"]["locality"],
  price_range: restaurant_card["restaurant"]["price_range"],
  rating: restaurant_card["restaurant"]["user_rating"]["aggregate_rating"]
}
end

def open_webpage(url)
  Launchy.open(url)
end

def look_loop(current_user, restaurant_line)
  current_user.swipe(restaurant_line)
end

def view_restaurant(restaurant_obj)
  10.times{puts " "}
  puts "Name of Restaurant:".colorize(:green) + " #{restaurant_obj.name}".colorize(:light_cyan)
  puts "-----".colorize(:light_magenta) * 10
  puts "Restaurant Menu + Website:".colorize(:green) + " #{restaurant_obj.url}".colorize(:light_cyan)
  puts "-----".colorize(:light_magenta) * 10
  puts "Restaurant Address:".colorize(:green) + " #{restaurant_obj.address}, #{restaurant_obj.locality}".colorize(:light_cyan)
  puts "-----".colorize(:light_magenta) * 10
  puts "Price Range out of 5:".colorize(:green) + " #{restaurant_obj.price_range}".colorize(:light_cyan)
  puts "-----".colorize(:light_magenta) * 10
  puts "Customer Rating out of 5:".colorize(:green) + " #{restaurant_obj.rating}".colorize(:light_cyan)
end

def run_logic(current_user)

  answer = main_menu(current_user)
  30.times do
    puts " "
  end

  if answer == "l"
  restaurant_line = choose_a_cuisine
  look_loop(current_user, restaurant_line)
  elsif answer == "v"
    if current_user.restaurants.empty?
      puts "You do not have any liked restaurants! Get to swiping!".colorize(:red)
    else
      puts "Here are your liked restaurants!".colorize(:green)
      puts "-----".colorize(:light_magenta) * 10
    current_user.restaurants.each do |restaurant|
      puts "#{restaurant.name}".colorize(:yellow)
      end
      5.times{puts " "}
      puts "- View restaurant info - type".colorize(:light_cyan) + " 'restaurant name'".colorize(:yellow)
      restaurant_name = gets.chomp
      restaurant_obj = current_user.restaurants.find_by(name: restaurant_name)
      if restaurant_obj != nil
      view_restaurant(restaurant_obj)
      puts "- To go back press enter or enter any string, to view the website, type".colorize(:light_cyan) + " 'website'".colorize(:yellow)
        input = get_user_input
        if input == "website"
          open_webpage(restaurant_obj.url)
          view_restaurant(restaurant_obj)
        end
      elsif input == "e"
        exit
      else
        10.times{puts " "}
        puts "Please enter the restaurant name as they appear!".colorize(:red)
        run_logic(current_user)
      end

    end
    run_logic(current_user)
  end
end
