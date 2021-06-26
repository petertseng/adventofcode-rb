require 'set'

class SetPerRow
  def initialize(size, on, diagonals_stuck: false)
    # I tend to like a sparse representation of live cells.
    # This makes it easier to increment live neighbour counts.
    @size = size
    @cells = Hash.new { |h, k| h[k] = Set.new }
    on.each { |x, y| add(x, y) }
    @diagonals_stuck = diagonals_stuck
    add_corners if diagonals_stuck
  end

  def live_size
    @cells.values.sum(&:size)
  end

  def step
    counts = Array.new(@size) { Array.new(@size, 0) }
    cells = @cells.flat_map { |x, ys| ys.map { |y| [x, y] }}
    cells.each { |x, y|
      # Increment neighbours.
      (-1..1).each { |dy|
        new_y = y + dy
        next if new_y < 0 || new_y >= @size
        counts_y = counts[new_y]
        (-1..1).each { |dx|
          # You aren't a neighbour of yourself.
          next if dx == 0 && dy == 0
          new_x = x + dx
          next if new_x < 0 || new_x >= @size
          counts_y[new_x] += 1
        }
      }
    }
    counts.each_with_index { |row, y| row.each_with_index { |count, x|
      add(x, y) if count == 3
    }}
    cells.each { |x, y|
      count = counts[y][x]
      delete(x, y) if count != 2 && count != 3
    }

    add_corners if @diagonals_stuck
  end

  private

  def add_corners
    add(0, 0)
    add(0, @size - 1)
    add(@size - 1, 0)
    add(@size - 1, @size - 1)
  end

  def add(x, y)
    @cells[x].add(y)
  end

  def delete(x, y)
    @cells[x].delete(y)
  end
end
