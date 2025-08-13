class Content
  CONTENT_PATH = Rails.root.join("content/*.yml")

  def self.all
    @all ||= Dir.glob(CONTENT_PATH).each_with_object({}) do |path, hash|
      content = YAML.load_file(path, symbolize_names: true)
      name = content[:name].to_sym
      hash[name] = content
    end
  end

  def self.find(name)
    raw = all[name.to_sym]
    new(raw)
  end

  attr_reader :raw

  def initialize(raw)
    @raw = raw
  end

  def name
    @name ||= raw[:name].to_sym
  end

  def title
    @title ||= raw[:title]
  end

  def body
    @body ||= raw[:body]
  end

  delegate :to_html, to: :document
  def document
    @document ||= Govspeak::Document.new(body)
  end
end
