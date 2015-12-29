require 'benchmark'

require_relative '../06_light_grid'
require_relative '06_light_grid/bst'
require_relative '06_light_grid/sorted_array_plus_max'
require_relative '06_light_grid/sorted_bucket_array'
require_relative '06_light_grid/sorted_on_demand_array'

bench_candidates = [
  [SortedArray, MaxArray],
  # candidates for SortedArray
  [SortedBucketArray, MaxArray],
  [SortedOnDemandArray, MaxArray],
  [Bst, MaxArray],
  # candidates for MaxArray
  [SortedArray, SortedArrayPlusMax],
  [SortedArray, Bst],
]

results = {}

Benchmark.bmbm { |bm|
  bench_candidates.each { |cs|
    bm.report(cs) { results[cs] = lights(@events_x, *cs) }
  }
}

# Obviously the benchmark would be useless if they got different answers.
if results.values.uniq.size != 1
  results.each { |k, v| puts "#{k} #{v}" }
  raise 'differing answers'
end
