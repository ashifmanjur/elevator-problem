# encoding: utf-8

class RequestList
  DIRECTIONS = { up: 'up', down: 'down' }

  def initialize
    @up_requests = 0b0000000000
    @down_requests = 0b0000000000
  end

  def add_up(level)
    @up_requests |= (1 << (level - 1)) if level > 0 # set corresponding bit starting from right most position
  end

  def add_down(level)
    @down_requests |= (1 << (level - 1)) if level > 0 # set corresponding bit starting from right most position
  end

  def serve_up(level)
    @up_requests &= ~(1 << (level - 1)) if level > 0 # unset corresponding bit starting from right most position
  end

  def serve_down(level)
    @down_requests &= ~(1 << (level - 1)) if level > 0 # unset corresponding bit starting from right most position
  end

  def empty?
    @down_requests == 0 && @up_requests == 0
  end

  def requests_waiting?(current_level, direction)
    case direction
    when RequestList::DIRECTIONS[:up]
      (current_level..10).each do |level|
        return true if @down_requests[level - 1] == 1
      end
    when RequestList::DIRECTIONS[:down]
      (1..current_level).each do |level|
        return true if @up_requests[level - 1] == 1
      end
    end

    false
  end

  def has_request?(level, direction)
    case direction
    when RequestList::DIRECTIONS[:up]
      return true if @up_requests[level - 1] == 1
    when RequestList::DIRECTIONS[:down]
      return true if @down_requests[level - 1] == 1
    end

    false
  end

  def print_list
    puts "up requests --> #{@up_requests.to_s(2)} :: down requests --> #{@down_requests.to_s(2)}"
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
    pick if @requests.has_request?(@current_level, @direction)
  end

  def stop_now?
    @requests.has_request?(current_level, direction)
  end

  def travel
    case direction
    when Car::DIRECTIONS[:up]
      if @current_level == Car::MAX_FLOOR
        flip
        return
      end

      pick if @requests.has_request?(@current_level, @direction)
      @current_level += 1
    when Car::DIRECTIONS[:down]
      if @current_level == 1
        flip
        return
      end

      pick if @requests.has_request?(@current_level, @direction)
      @current_level -= 1
    end
  end

  def pick
    @requests.send("serve_#{direction}".to_sym, @current_level)
  end

  def requests_waiting?

  end

  def flip
    @direction = (@direction == Car::DIRECTIONS[:up] ? Car::DIRECTIONS[:down] : Car::DIRECTIONS[:up])
    pick
  end

  def display
    puts "#{current_level} #{direction == Car::DIRECTIONS[:up] ? '↑' : '↓'}"
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

requests.add_up(1)
requests.add_up(4)
requests.add_down(2)

requests.print_list

# puts requests.has_request?(3, RequestList::DIRECTIONS[:down])

car_one = Car.new(1, Car::DIRECTIONS[:up], requests)

car_one.travel
car_one.display

car_one.travel
car_one.display

car_one.travel
car_one.display

car_one.travel
car_one.display

requests.print_list