class User < ActiveRecord::Base
  has_many :likes
  has_many :restaurants, through: :likes

  def push_to_database(restaurant_atts)
      restaurant = Restaurant.find_or_create_by(restaurant_atts)
      self.restaurants << restaurant
  end

  def swipe(restaurant_line)
    current_restaurant = get_restaurant_atts(get_restaurant_card(restaurant_line))

    display_restaurant(current_restaurant)
    puts "-----".colorize(:light_magenta) * 10
    puts "Type".colorize(:light_cyan) + " 'Y'".colorize(:yellow) + " to add to your liked restaurants or".colorize(:light_cyan) + " 'N'".colorize(:yellow) + " to pass.".colorize(:light_cyan)
    puts "Type".colorize(:light_cyan) + " 'website'".colorize(:yellow) + " to access the zomato website entry for the restaurant".colorize(:light_cyan)
    puts "Or, type".colorize(:light_cyan) + " 'X'".colorize(:yellow) + " to exit.".colorize(:light_cyan)
    choice = get_user_input
    valid_command(choice,current_restaurant, restaurant_line)
  end

  def valid_command(choice,current_restaurant,restaurant_line)
    if choice == "y"
      self.push_to_database(current_restaurant)
      10.times {puts " "}
      puts "Here's another restaurant!".colorize(:green)
      look_loop(self, restaurant_line)
    elsif choice == "n"
      10.times {puts " "}
      puts "Maybe try this one!".colorize(:green)
      look_loop(self, restaurant_line)
    elsif choice == "x"
      run_logic(self)
    elsif choice =="website"
      puts "-----".colorize(:light_magenta) * 10
      open_webpage(current_restaurant[:url])
      puts "Type".colorize(:light_cyan) + " 'Y'".colorize(:yellow) + " to add to your liked restaurants or".colorize(:light_cyan) + " 'N'".colorize(:yellow) + " to pass.".colorize(:light_cyan)
      puts "Type".colorize(:light_cyan) + " 'website'".colorize(:yellow) + " to access the zomato website entry for the restaurant".colorize(:light_cyan)
      puts "Or, type".colorize(:light_cyan) + " 'X'".colorize(:yellow) + " to exit.".colorize(:light_cyan)
      valid_command(choice = get_user_input,current_restaurant,restaurant_line)
    else
      puts "Please enter a valid command".colorize(:red)
      choice = get_user_input
      valid_command(choice, current_restaurant, restaurant_line)
    end
  end


end
