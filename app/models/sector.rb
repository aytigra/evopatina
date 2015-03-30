class Sector
  @@all = []

  KEYS = [1,2,3,4,5,6]

  GLYPHONS = {
    1 => 'compressed',
    2 => 'education',
    3 => 'fire',
    4 => 'usd',
    5 => 'comment',
    6 => 'plane'
  }

  def initialize (id)
    @id = id
  end

  def self.all
    return @@all if @@all.size == 6

    KEYS.each do |id|
      @@all << self.new(id)
    end
    @@all
  end

  def self.hash(values = {})
    res = {}
    KEYS.each do |s|
      res[s.id] = values[s.id] || 0
    end
    res
  end

  def id
    @id
  end

  def name
    I18n.translate("sector.id_#{@id}.name")
  end

  def description
    I18n.translate("sector.id_#{@id}.description")
  end

  def icon
    "glyphicon glyphicon-#{GLYPHONS[id]}"
  end
end