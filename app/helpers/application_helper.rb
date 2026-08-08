module ApplicationHelper
  # Maps a series of numeric values onto an SVG polyline "x,y x,y ..." string.
  def sparkline_points(values, width:, height:, padding: 10)
    return "" if values.blank?

    max = [values.max, 1].max.to_f
    min = [values.min, 0].min.to_f
    range = (max - min).zero? ? 1 : (max - min)
    step = values.size > 1 ? (width - 2 * padding) / (values.size - 1).to_f : 0

    values.each_with_index.map do |v, i|
      x = padding + (i * step)
      y = height - padding - (((v - min) / range) * (height - 2 * padding))
      "#{x.round(1)},#{y.round(1)}"
    end.join(" ")
  end

  def progress_percent(actual, target)
    return 0 if target.blank? || target.to_f.zero?

    [(actual.to_f / target.to_f * 100).round, 999].min
  end
end
