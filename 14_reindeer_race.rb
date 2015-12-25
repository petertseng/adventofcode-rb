class Deer
  attr_reader :distance, :points

  def initialize(name, speed, run_time, rest_time)
    @name = name
    @speed = speed
    @run_time = run_time
    @rest_time = rest_time
    @distance = 0
    @points = 0
    @state = :running
    @time_in_state = 0
  end

  def run
    @time_in_state += 1
    case @state
    when :running
      @distance += @speed
      self.state = :resting if @time_in_state == @run_time
    when :resting
      self.state = :running if @time_in_state == @rest_time
    else raise "Unknown state #@state"
    end
    @distance
  end

  def award_lead_points(max_distance)
    @points += 1 if @distance == max_distance
  end

  def to_s
    "#@name at #@distance km with #@points points"
  end

  private

  def state=(new_state)
    @state = new_state
    @time_in_state = 0
  end
end

DEER = /^(.+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds\.$/
TIME = 2503

verbose = ARGV.delete('-v')

deer = ARGF.each_line.map { |line|
  captures = DEER.match(line).captures
  name = captures.shift
  Deer.new(name, *captures.map(&method(:Integer)))
}

max_distance = 0
TIME.times {
  max_distance = deer.map(&:run).max
  deer.each { |d| d.award_lead_points(max_distance) }
}

%i(distance points).each { |metric|
  puts deer.max_by(&metric).public_send(verbose ? :itself : metric)
}
