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
    @stats = compute_stats(chord_pair_data) if chord_pair_data.any?
  end

  private

  def compute_stats(chord_pair_data)
    # Most practiced: pair that appeared in the most complete sessions
    most_practiced_entry = chord_pair_data.max_by { |_, data| data.length }
    most_practiced = most_practiced_entry ? { label: most_practiced_entry[0], count: most_practiced_entry[1].length } : nil

    # Improvement stats require at least 2 data points per pair
    improvements = chord_pair_data
      .select { |_, data| data.length >= 2 }
      .filter_map do |label, data|
        first_val = data.first[:y].to_f
        last_val  = data.last[:y].to_f
        next if first_val <= 0
        pct = ((last_val - first_val) / first_val * 100).round(1)
        { label: label, pct: pct, first: first_val.round(1), last: last_val.round(1), count: data.length }
      end

    most_improved  = improvements.max_by { |p| p[:pct] }
    least_improved = improvements.min_by { |p| p[:pct] }
    # Suppress least_improved when there is only one eligible pair
    least_improved = nil if improvements.length <= 1

    # Overall: average of per-pair percentage improvements
    overall_pct = improvements.any? ? (improvements.sum { |p| p[:pct] } / improvements.length).round(1) : nil

    {
      most_practiced: most_practiced,
      most_improved: most_improved,
      least_improved: least_improved,
      overall_pct: overall_pct
    }
  end
end
