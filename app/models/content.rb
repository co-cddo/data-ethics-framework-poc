class Content
  CONTENT_PATH = Rails.root.join("content/*.yml")

  def self.all
    @all ||= begin
      Dir.glob(CONTENT_PATH).each_with_object({}) do |path, hash|
        content = YAML.load_file(path, symbolize_names: true)
        name = content[:name].to_sym
        hash[name] = content
      end
    end
  end

  def self.find(name)
    raw = all[name]
    new(raw)
  end

  delegate :to_html, to: :document
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

  def document
    @document ||= Govspeak::Document.new(body)
  end
end
