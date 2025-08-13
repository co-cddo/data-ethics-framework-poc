require "rails_helper"

RSpec.describe Content, type: :model do
  let(:raw_content) { YAML.load_file(Rails.root.join('content/how_to_use.yml'), symbolize_names: true) }
  let(:name) { raw_content[:name].to_sym }
  let(:content) { described_class.find(name) }

  describe ".all" do
    subject(:all) { described_class.all }
    it "is a hash" do
      expect(all).to be_a(Hash)
    end

    it "includes the content files" do
      expect(all.keys).to include(name)
      expect(all[name]).to eq(raw_content)
    end
  end

  describe ".find" do
    it "returns an instance of content" do
      expect(content).to be_a(described_class)
    end

    it "returns a content with matching name" do
      expect(content.name).to eq(name)
    end
  end

  describe "#to_html" do
    let(:html) { Govspeak::Document.new(raw_content[:body]).to_html }

    it "returns the content body as html" do
      expect(content.to_html).to eq(html)
    end
  end
end

