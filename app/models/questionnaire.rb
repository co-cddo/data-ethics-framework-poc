class Questionnaire
  include ActiveModel::Model
  include Comparable

  QUESTIONNAIRES_PATH = Rails.root.join("data/questionnaires/*.yml")

  class << self
    def all
      @all ||= Dir.glob(QUESTIONNAIRES_PATH).each_with_object({}) do |path, hash|
        content = YAML.load_file(path, symbolize_names: true)
        name = content[:name].to_sym
        hash[name] = content
      end
    end

    def find(name)
      raw = all[name.to_sym]
      new(raw)
    end
  end

  attr_accessor :name, :start, :heading, :questions

  def id
    name.to_sym
  end

  def question(name)
    data = questions[name.to_sym]
    raise "Question '#{name}'' not found in questionnaire '#{id}'" if data.blank?

    Question.new(data.merge(name:))
  end

  # Raw questions is a hash with names as keys
  def question_objects
    questions.map { |name, data| Question.new(data.merge(name:)) }
  end

  def <=>(other)
    name <=> other.name
  end

  class Question
    include ActiveModel::Model

    COLOURS = {
      privacy: "red",
      accountability: "orange",
      safety: "purple",
      fairness: "yellow",
      societal_impact: "turquoise",
      transparency: "blue",
      sustainability: "green",
    }.freeze

    attr_accessor :name, :type, :title, :answers, :hint, :next, :tags

    def id
      name.to_sym
    end

    def tags_with_colours
      return [] if tags.blank?

      tags.split(/\s?,\s?/).collect do |tag|
        {
          text: tag,
          colour: COLOURS.fetch(tag.parameterize(separator: "_").to_sym, "grey"),
        }
      end
    end
  end
end
