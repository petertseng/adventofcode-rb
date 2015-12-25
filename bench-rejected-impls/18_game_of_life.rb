require 'benchmark'

require_relative '../18_game_of_life'
require_relative '18_game_of_life/activity_list'
require_relative '18_game_of_life/cache_neighbour_counts'
require_relative '18_game_of_life/one_coord'
require_relative '18_game_of_life/set_per_row'
require_relative '18_game_of_life/single_set'

bench_candidates = [
  Grid,
  ActivityList,
  CacheNeighbourCounts,
  OneCoord,
  SetPerRow,
  SingleSet,
]

[false, true].each { |diag_stuck|
  puts "diagonals#{' not' unless diag_stuck} stuck"
  results = {}

  Benchmark.bmbm { |bm|
    bench_candidates.each { |c|
      bm.report(c) {
        g = c.new(*@args, diagonals_stuck: diag_stuck)
        100.times { g.step }
        results[c] = g.live_size
      }
    }
  }

  # Obviously the benchmark would be useless if they got different answers.
  if results.values.uniq.size != 1
    results.each { |k, v| puts "#{k} #{v}" }
    raise 'differing answers'
  end
}
