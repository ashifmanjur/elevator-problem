# encoding: utf-8

class RequestList
  DIRECTIONS = { up: 'up', down: 'down' }

  def initialize
    @up_requests = 0b0000000000
    @down_requests = 0b0000000000
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