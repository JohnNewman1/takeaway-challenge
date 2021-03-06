require 'csv'
require_relative 'dish.rb'

class Menu

  attr_reader :dishes, :menu_csv, :dish, :current_order, :temp_dishes

  def initialize(dish_class = Dish)
    @menu_csv = CSV.read('lib/menu.csv', :encoding => 'windows-1251:utf-8')
    @dishes = []
    @dish_class = dish_class
    @current_order = []
    @temp_dishes = []
  end

  def dish_check(dish_name, quantity)
    @temp_dishes.each do |dish|
      if dish.name == dish_name
        add_to_order(quantity, dish)
        break
      elsif dish == @temp_dishes[-1]
        raise "There is no dish with that name"
      end
    end
  end

  def view_menu
    print_menu
  end

  def menu_load
    @menu_csv.each do |row|
      @dishes << @dish_class.new(row[0], row[1], row[2])
    end
    create_temp_dishes
  end

  def add_to_order(input, dish)
    raise "Sorry there is not enough in stock" if input.to_i > dish.quantity
    dish.quantity -= input.to_i
    @current_order << dish.dup
    @current_order[-1].quantity = input.to_i
  end

  private

  def create_temp_dishes
    @dishes.each do |instance|
      @temp_dishes << instance.dup
    end
  end

  def print_menu
    puts ".--------------------------------------------."
    puts "|  .___  ___.  _______ .__   __.  __    __   |"
    puts "|  |   \\/   | |   ____||  \\ |  | |  |  |  |  |"
    puts "|  |  \\  /  | |  |__   |   \\|  | |  |  |  |  |"
    puts "|  |  |\\/|  | |   __|  |  . `  | |  |  |  |  |"
    puts "|  |  |  |  | |  |____ |  |\\   | |  `--'  |  |"
    puts "|  |__|  |__| |_______||__| \\__|  \\______/   |"
    puts ":--------------------------------------------:"
    puts "| ITEM                             | PRICE   |"
    @menu_csv.each do |row|
      puts ":----------------------------------+---------:"
      price = '%.2f' % row[1]
      string = "| " + row[0].ljust(33) + "| " + price.to_s.ljust(8) + "|"
      puts string
    end
    puts "'----------------------------------'---------'"
  end
end
