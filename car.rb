# encoding: utf-8
require_relative 'request_list'

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