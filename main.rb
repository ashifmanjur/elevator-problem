# encoding: utf-8

class RequestList
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

  def served_all?
    @down_requests == 0 && @up_requests == 0
  end

  def requests_waiting?(current_level, direction)

  end

  def print_list
    puts "up requests --> #{@up_requests.to_s(2)} :: down requests --> #{@down_requests.to_s(2)}"
  end
end

class Car
  attr_reader :current_level, :direction, :requests

  def initialize(start_level = 1, direction = 'up', request_list)
    @current_level = start_level
    @direction = direction
    @requests = request_list
  end

  def should_stop?

  end

  def travel_single_level

  end

  def pick_passengers

  end

  def waiting_requests?

  end

  def flip_direction

  end
end


requests = RequestList.new
puts requests.served_all?
requests.add_up(2)
requests.add_up(4)
puts requests.served_all?
requests.add_down(1)
requests.add_down(2)
requests.print_list

requests.serve_up(2)
requests.serve_up(4)
puts requests.served_all?
requests.serve_down(1)
requests.serve_down(2)
puts requests.served_all?
requests.print_list