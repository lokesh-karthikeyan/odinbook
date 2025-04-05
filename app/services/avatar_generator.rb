class AvatarGenerator
  def self.create_initials_avatar(initials)
    svg = <<~SVG
      <svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="100%" height="auto" viewBox="0 0 50 50" preserveAspectRatio="xMidYMid meet">
        <title id="title">Avatar</title>
        <desc id="desc">An avatar with the initials #{initials} displayed on a colored background</desc>
        <style>
          @font-face {
          font-family: "OpenSans";
          font-weight: 500;
          }
        </style>
        <rect width="100%" height="100%" fill="#{random_color}"/>
        <text fill="#fff" font-family="OpenSans,Arial,sans-serif" font-size="26" font-weight="500" x="50%" y="55%" dominant-baseline="middle" text-anchor="middle">
          #{initials}
        </text>
      </svg>
    SVG
    svg.strip
  end

  def self.random_color = ([ "#A9294F", "#ED6663", "#389393", "#D82148", "#8C5425", "#6F38C5" ].sample)
end
