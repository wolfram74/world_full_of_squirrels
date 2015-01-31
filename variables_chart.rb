require 'googlecharts'
require 'launchy'
require 'colorize'

axis_array  = ["XY", "QB", "DD", "DK", "PJ"]
axis_occurance = [12, 10, 2, 17, 5]


range_max = axis_occurance.max
# range_min = axis_occurance.min LEAVE MIN AT 0


# p range_min
# p range_max


link = Gchart.bar(
            :size => '400x200',
            :data => axis_occurance,
            # :max_value => 10,
            # :encoding => 'extended',
            :bar_width_and_spacing => '40,20',
            :title => 'Squirrel Dominant Genes',
            # :legend => ['squirrels'],
            # :bg => {:color => '76A4FB', :type => 'gradient'},
            :axis_with_labels => ['x', 'y'],
            :axis_labels => [axis_array],
            :axis_range => [nil, [0, range_max, 1]],
            :bar_colors => '0000ff,00ff00')


if ARGV.any?
  if ARGV[0] == "chart"
    Launchy.open(link)
  elsif ARGV[0] == "squirrels"
    puts "ascii goes here"
  else
    puts "command"
  end
end