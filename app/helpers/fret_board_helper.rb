module FretBoardHelper
  CONFIGS = {
    large:   { width: 200, height: 280, top: 40, left: 6, num_strings: 6, note_radius: 9, mute_y_offset: 38 },
    default: { width: 150, height: 210, top: 30, left: 5, num_strings: 6, note_radius: 7, mute_y_offset: 31 },
    small:   { width: 75,  height: 105, top: 15, left: 5, num_strings: 6, note_radius: 4, mute_y_offset: 14 },
    tiny:    { width: 50,  height: 70,  top: 12, left: 5, num_strings: 6, note_radius: 3, mute_y_offset: 9  }
  }.freeze

  def fret_board_svg(chord, size: :default)
    c = CONFIGS[size]
    width       = c[:width]
    height      = c[:height]
    top         = c[:top]
    left        = c[:left]
    num_strings = c[:num_strings]
    r           = c[:note_radius]

    string_gap    = width.to_f  / (num_strings - 1)
    fret_gap      = height.to_f / (num_strings - 1)
    canvas_width  = width  + left * 3
    canvas_height = height + top  * 3

    els = []

    # Fretboard background
    els << %(<rect x="#{left}" y="#{top}" width="#{width}" height="#{height}" fill="white" stroke="black" stroke-width="2"/>)

    # Internal string (vertical) and fret (horizontal) lines
    1.upto(num_strings - 2) do |i|
      sx = r2(left + string_gap * i)
      els << %(<line x1="#{sx}" y1="#{top}" x2="#{sx}" y2="#{top + height}" stroke="black" stroke-width="1"/>)
      fy = r2(top + fret_gap * i)
      els << %(<line x1="#{left}" y1="#{fy}" x2="#{left + width}" y2="#{fy}" stroke="black" stroke-width="1"/>)
    end

    notes = chord.notes

    # Bar chord — e.g. "B-1-21" or "B-1-61"
    if notes.length > num_strings
      bar = notes[num_strings]
      if bar.is_a?(String) && bar.start_with?("B-")
        _, bar_fret, bar_strings = bar.split("-")
        bar_fret = bar_fret.to_f
        bar_y    = r2(top - r * 3.4 + fret_gap * bar_fret)
        s_start  = num_strings - bar_strings[0].to_i
        s_end    = num_strings - bar_strings[1].to_i
        bx       = r2(left + string_gap * s_start - r)
        bw       = r2((left + string_gap * s_end + r) - (left + string_gap * s_start - r))
        els << %(<rect x="#{bx}" y="#{bar_y}" width="#{bw}" height="#{r * 2}" rx="10" ry="10" fill="black" stroke="black" stroke-width="2"/>)
      end
    end

    # Individual notes
    num_strings.downto(1) do |string|
      string_idx = num_strings - string
      fret = notes[string_idx]
      next if fret.is_a?(String)

      cx = r2(left + string_gap * string_idx)
      if fret >= 0
        fill = fret == 0 ? "white" : "black"
        cy   = r2(top - r * 3.4 + fret_gap * fret + r)
        els << %(<circle cx="#{cx}" cy="#{cy}" r="#{r}" fill="#{fill}" stroke="black" stroke-width="1"/>)
      else
        tx = r2(left * 1.2 + string_gap * string_idx - r)
        ty = r2(top + 2 + fret_gap * fret - 1 + c.fetch(:mute_y_offset, 0))
        els << %(<text class="fret-mute" x="#{tx}" y="#{ty}" font-size="#{r * 4}" font-family="sans-serif" fill="white" stroke="black" stroke-width="2" paint-order="stroke fill">x</text>)
      end
    end

    # Chord name label centered below the board
    label_x = r2(left + width / 2.0)
    label_y = top + height + (top * 1.5).round
    els << %(<text class="fret-label" x="#{label_x}" y="#{label_y}" font-size="#{r * 3}" font-family="sans-serif" font-weight="bold" text-anchor="middle" fill="white" stroke="black" stroke-width="2" paint-order="stroke fill">#{chord.name}</text>)

    svg = <<~SVG
      <svg width="#{canvas_width}" height="#{canvas_height}" overflow="visible" xmlns="http://www.w3.org/2000/svg">
        #{els.join("\n  ")}
      </svg>
    SVG
    svg.html_safe
  end

  private

  def r2(val)
    val.round(2)
  end
end
