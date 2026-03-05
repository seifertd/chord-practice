class ProgressController < ApplicationController
  def index
    chord_pair_data = current_player.chord_pair_data
    @progress = {
      type: "line",
      data: {
        datasets: chord_pair_data.keys.sort.map do |chord_pair|
          {
            label: chord_pair,
            data: chord_pair_data[chord_pair],
            borderWidth: 2,
            pointRadius: 2
          }
        end
      },
      options: {
        aspectRatio: 2.5,
        scales: {
          x: {
            type: "time",
            time: {
              minUnit: "day",
              displayFormats: { day: "MMM d", week: "MMM d", month: "MMM yyyy" }
            },
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
