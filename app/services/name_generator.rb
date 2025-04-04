class NameGenerator
  FUTIRISTIC_ADJECTIVES = %w[Quantum Cyber Neon Stellar Code Pixel Crypto Binary Matrix Astro]
  FUTIRISTIC_NOUNS = %w[Jumper Voyager Glitch Byte Nexus Phantom Circuit Blaze Nomad Cipher]

  NATURE_ADJECTIVES = %w[Mystic Storm Lunar Solar Thunder Glacier Ocean Ember Twilight Crystal]
  NATURE_NOUNS = %w[River Whisper Echo Bloom Leaf Dusk Drift Trail Rain Fern]

  FANTASY_ADJECTIVES = %w[Dragon Shadow Arcane Mystic Celestial Phoenix Frost Starry Crimson Eternal]
  FANTASY_NOUNS = %w[Seeker Blade Archer Wanderer Rune Ember Sorcerer Scribe Knight Quest]

  FUNNY_ADJECTIVES = %w[Witty Jolly Snazzy Zesty Fancy Dandy Peppy Giggly Quirky Chirpy]
  FUNNY_NOUNS = %w[Sprout Muffin Panda Zebra Tumbleweed Waffle Moonbeam Starfish Owl Nugget]

  CODER_ADJECTIVES = %w[Agile Debugging Binary Loopy Syntax Optimized Recursive Pixel Quantum Scalable]
  CODER_NOUNS = %w[Algorithm Wizard Rebel Coder Samurai Warrior Titan Guru Debugger Whisper]

  def self.generate = (random_name[rand(1..5)])

  def self.random_name
    {
      1 => "#{FUTIRISTIC_ADJECTIVES.sample} #{FUTIRISTIC_NOUNS.sample}_#{rand(1000..9999)}",
      2 => "#{NATURE_ADJECTIVES.sample} #{NATURE_NOUNS.sample} #{rand(1000..9999)}",
      3 => "#{FANTASY_ADJECTIVES.sample} #{FANTASY_NOUNS.sample} #{rand(1000..9999)}",
      4 => "#{FUNNY_ADJECTIVES.sample} #{FUTIRISTIC_NOUNS.sample} #{rand(1000..9999)}",
      5 => "#{CODER_ADJECTIVES.sample} #{CODER_NOUNS.sample} #{rand(1000..9999)}"
    }
  end
end
