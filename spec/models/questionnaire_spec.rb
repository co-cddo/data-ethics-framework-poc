require "rails_helper"

RSpec.describe Questionnaire, type: :model do
  let(:raw) do
    path = Dir.glob(Rails.root.join("data/questionnaires/*.yml")).sample
    YAML.load_file(path, symbolize_names: true)
  end
  let(:name) { raw[:name].to_sym }
  let(:questionnaire) { described_class.find(name) }

  describe ".all" do
    subject(:all) { described_class.all }
    it "is a hash" do
      expect(all).to be_a(Hash)
    end

    it "includes the content files" do
      expect(all.keys).to include(name)
      expect(all[name]).to eq(raw)
    end
  end

  describe ".find" do
    it "returns an instance of content" do
      expect(questionnaire).to be_a(described_class)
    end

    it "returns a content with an id matching name" do
      expect(questionnaire.id).to eq(name)
    end
  end

  describe "#question" do
    let(:question_data) do
      name, hash = questionnaire.questions.first
      hash.merge(name:)
    end
    subject(:question) { questionnaire.question(question_data[:name]) }

    it "returns a matching answer object" do
      expect(question.name).to eq(question_data[:name])
      expect(question.title).to eq(question_data[:title])
    end
  end
end
