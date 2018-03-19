class ProgressController < ApplicationController
  def index
    chord_pair_data = current_player.chord_pair_data
    @progress = {
      type: "line",
      data: {
        datasets: chord_pair_data.keys.map do |chord_pair|
          {
            label: chord_pair,
            data: chord_pair_data[chord_pair],
            borderColor: 'black',
            borderWidth: 2,
            pointRadius: 2,
          }
        end
      },
      options: {
        showLines: true,
        scales: {
          yAxes: [{
            scaleLabel: {
              display: true,
              labelString: "Number of Switches"
            }
          }],
          xAxes: [{
            type: 'time',
            distribution: 'linear',
            scaleLabel: {
              display: true,
              labelString: 'Date'
            }
          }]
        },
        elements: {
          line: {
            tension: 0
          }
        }
      }
    }
  end
end
