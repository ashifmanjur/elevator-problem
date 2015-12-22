# encoding: utf-8

class RequestList
  def initialize
    @up_requests = 0b0000000000
    @down_requests = 0b0000000000
  end

  def add_up(level)

  end

  def add_down(level)

  end

  def serve_up(level)

  end

  def serve_down(level)

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