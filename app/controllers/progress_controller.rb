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
            borderWidth: 2,
            pointRadius: 2
          }
        end
      },
      options: {
        scales: {
          x: {
            type: "time",
            title: {
              display: true,
              text: "Date"
            }
          },
          y: {
            title: {
              display: true,
              text: "Switches / min"
            },
            beginAtZero: true
          }
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
