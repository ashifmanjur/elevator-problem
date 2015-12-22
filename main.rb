# encoding: utf-8

class RequestList
  def initialize
    @up_requests = 0b0000000000
    @down_requests = 0b0000000000
  end
end

class Car
  attr_reader :current_level, :direction, :requests

  def initialize(start_level = 1, direction = 'up', request_list)
    @current_level = start_level
    @direction = direction
    @requests = request_list
  end
end