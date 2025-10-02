class Content
  include ActiveModel::Model
  include Comparable

  CONTENT_PATH = Rails.root.join("data/content/*.yml")

  class << self
    def all
      @all ||= Dir.glob(CONTENT_PATH).each_with_object({}) do |path, hash|
        content = YAML.load_file(path, symbolize_names: true)
        name = content[:name].to_sym
        hash[name] = content
      end
    end

    def find(name)
      raw = all[name.to_sym]
      new(raw)
    end

    def all_by_position
      @all_by_position ||= all.values.select { |v| v[:position].present? }.sort_by { |v| v[:position] }
    end

    def reset_all_by_position
      @all_by_position = nil
    end
  end

  attr_accessor :title, :body, :name, :position

  def id
    name.to_sym
  end

  def to_html
    GovukMarkdown.render(body)
  end

  def next
    return if index.nil? || (index + 1) == self.class.all_by_position.length # it's the last one

    next_datum = self.class.all_by_position[index + 1]
    self.class.find(next_datum[:name])
  end

  def previous
    return if index.nil? || index.zero? # it's the first one

    previous_datum = self.class.all_by_position[index - 1]
    self.class.find(previous_datum[:name])
  end

  def index
    @index ||= self.class.all_by_position.index { |c| c[:name] == name.to_s }
  end

  def <=>(other)
    name <=> other.name
  end
end
