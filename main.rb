# encoding: utf-8
require 'thread'

class RequestList
  DIRECTIONS = { up: 'up', down: 'down' }

  def initialize
    @up_requests = 0b0000101000
    @down_requests = 0b1101000100
    @mutex = Mutex.new # To make sure only one thread at a time can mutate the request list
  end

  def add_up(level)
    @mutex.synchronize {
      @up_requests |= (1 << (level - 1)) if level > 0 # set corresponding bit starting from right most position
    }
  end

  def add_down(level)
    @mutex.synchronize {
      @down_requests |= (1 << (level - 1)) if level > 0 # set corresponding bit starting from right most position
    }
  end

  def serve_up(level)
    @mutex.synchronize {
      puts "Serving request: #{level} ↑\n"
      @up_requests &= ~(1 << (level - 1)) if level > 0 # unset corresponding bit starting from right most position
    }

    print_list
  end

  def serve_down(level)
    @mutex.synchronize {
      puts "Serving request: #{level} ↓\n"
      @down_requests &= ~(1 << (level - 1)) if level > 0 # unset corresponding bit starting from right most position
    }

    print_list
  end

  def empty?
    @mutex.synchronize {
      @down_requests == 0 && @up_requests == 0
    }
  end

  def has_request?(level, direction)
    @mutex.synchronize {
      case direction
      when RequestList::DIRECTIONS[:up]
        return true if @up_requests[level - 1] == 1
      when RequestList::DIRECTIONS[:down]
        return true if @down_requests[level - 1] == 1
      end

      false
    }
  end

  def print_list
    @mutex.synchronize {
      puts "UP requests --> #{@up_requests.to_s(2)} :: DOWN requests --> #{@down_requests.to_s(2)}\n"
    }
  end
end

class Car
  DIRECTIONS = { up: 'up', down: 'down' }
  MAX_FLOOR = 10

  attr_reader :current_level, :direction, :requests

  def initialize(start_level = 1, direction, request_list)
    @current_level = start_level
    @direction = direction
    @requests = request_list
    pick if stop_now?
  end

  def pending_request?
    !@requests.empty?
  end

  def stop_now?
    @requests.has_request?(current_level, direction)
  end

  def travel
    pick if stop_now?

    case direction
    when Car::DIRECTIONS[:up]
      if @current_level == Car::MAX_FLOOR
        flip
        sleep 0.3
        return
      end

      @current_level += 1
      sleep(0.3)

    when Car::DIRECTIONS[:down]
      if @current_level == 1
        flip
        sleep 0.3
        return
      end

      @current_level -= 1
      sleep(0.3)
    end
  end

  def pick
    @requests.send("serve_#{direction}".to_sym, @current_level)
  end

  def flip
    @direction = (@direction == Car::DIRECTIONS[:up] ? Car::DIRECTIONS[:down] : Car::DIRECTIONS[:up])
    pick
  end

  def list_display
    @requests.print_list
  end
end


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
    sleep(2)
    requests.print_list
  end
end

[car_one_thread, car_two_thread, car_three_thread, level_status_thread, dynamic_request_thread].each { |t| t.join }