module ApplicationHelper
  def show_blob(blob, resize_to: nil)
    return unless blob.attached?

    if blob.content_type == "image/svg+xml"
      render_svg(blob, resize_to)
    else
      render_non_svg(blob, resize_to)
    end
  end

  private

  def render_svg(blob, resize_to)
    svg_content = blob.download
    return raw(svg_content) unless resize_to

    svg_content.gsub!(/<svg[^>]+>/) do |svg_tag|
      width, height = resize_to.downcase.split("x")
      if svg_tag.include?("width") && svg_tag.include?("height")
        svg_tag
          .gsub(/width="[^"]+"/, "width=\"#{width}\"")
          .gsub(/height="[^"]+"/, "height=\"#{height}\"")
      else
        svg_tag.sub("<svg", "<svg width=\"#{width}\" height=\"#{height}\"")
      end
    end

    raw(svg_content)
  end

  def render_non_svg(blob, resize_to)
    if resize_to && blob.content_type.match(/^image\/(jpeg|jpg|png)$/)
      dimensions = resize_to.downcase.split("x").map(&:to_i)
      image_tag(
        blob.variant(resize_to_fill: dimensions).processed,
        alt: "Avatar",
        width: dimensions[0],
        height: dimensions[1]
      )
    else
      image_tag(url_for(blob), alt: "Avatar")
    end
  end
end
