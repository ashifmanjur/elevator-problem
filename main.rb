# encoding: utf-8
require 'thread'
require_relative 'car'

# requests = RequestList.new
# puts requests.empty?
# requests.add_up(2)
# requests.add_up(4)
# puts requests.empty?
# requests.add_down(1)
# requests.add_down(2)
# requests.print_list
#
# requests.serve_up(2)
# requests.serve_up(4)
# puts requests.empty?
# requests.serve_down(1)
# requests.serve_down(2)
# puts requests.empty?
# requests.print_list

requests = RequestList.new

# requests.add_up(1)
# requests.add_up(4)
# requests.add_down(2)

requests.print_list

# puts requests.has_request?(3, RequestList::DIRECTIONS[:down])

car_one = Car.new(1, Car::DIRECTIONS[:up], requests)
car_two = Car.new(2, Car::DIRECTIONS[:up], requests)
car_three = Car.new(3, Car::DIRECTIONS[:up], requests)

Thread.abort_on_exception = true

# car_one.display
#
# while(!car_one.requests.empty?)
#   car_one.travel
#   requests.print_list
#
#   car_one.display
# end

car_one_thread = Thread.new do
  loop do
    if car_one.pending_request?
      car_one.travel
    else
      next
    end
  end
end

car_two_thread = Thread.new do
  loop do
    if car_two.pending_request?
      car_two.travel
    else
      next
    end
  end
end

car_three_thread = Thread.new do
  loop do
    if car_three.pending_request?
      car_three.travel
    else
      next
    end
  end
end

level_status_thread = Thread.new do
  loop do
    puts "1 --> #{car_one.current_level} #{car_one.direction == Car::DIRECTIONS[:up] ? '↑' : '↓'} ::: 2 --> #{car_two.current_level} #{car_two.direction == Car::DIRECTIONS[:up] ? '↑' : '↓'} ::: 3 --> #{car_three.current_level} #{car_three.direction == Car::DIRECTIONS[:up] ? '↑' : '↓'}\n"
    sleep(1)
  end
end

dynamic_request_thread = Thread.new do
  15.times do
    requests.add_up(rand(10))
    requests.add_down(rand(10))
    sleep(1)
    requests.print_list
  end
end

[car_one_thread, car_two_thread, car_three_thread, level_status_thread, dynamic_request_thread].each { |t| t.join }