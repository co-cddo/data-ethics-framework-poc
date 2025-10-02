require "rails_helper"

RSpec.describe Content, type: :model do
  let(:raw_content) do
    path = Dir.glob(Rails.root.join("data/content/*.yml")).sample
    YAML.load_file(path, symbolize_names: true)
  end
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

    it "returns a content with an id matching name" do
      expect(content.id).to eq(name)
    end
  end

  describe "#to_html" do
    let(:html) { GovukMarkdown.render(raw_content[:body]) }

    it "returns the content body as html" do
      expect(content.to_html).to eq(html)
    end
  end

  context "with stubbed data" do
    let(:data) do
      {
        a: { name: "a", title: "a", body: "A", position: 2 },
        b: { name: "b", title: "b", body: "B", position: 3 },
        c: { name: "c", title: "c", body: "C", position: 1 },
        d: { name: "d", title: "d", body: "D", position: nil }
      }
    end

    before do
      allow(described_class).to receive(:all).and_return(data)
    end

    after do
      described_class.reset_all_by_position
    end

    let(:a) { described_class.find(:a) }
    let(:b) { described_class.find(:b) }
    let(:c) { described_class.find(:c) }
    let(:d) { described_class.find(:d) }

    describe ".all_by_position" do
      subject(:all_by_position) { described_class.all_by_position }

      it "returns an array" do
        expect(all_by_position).to be_a(Array)
      end

      it "returns the data values ordered by position" do
        expect(all_by_position.first).to eq(data[:c])
        expect(all_by_position.last).to eq(data[:b])
      end

      it "ignores content without position" do
        expect(all_by_position).not_to include(data[:d])
      end
    end

    describe "#next" do
      it "returns the next content if there is one" do
        expect(c.next).to eq(a)
        expect(a.next).to eq(b)
        expect(b.next).to be_nil
      end

      it "is nil if content is not positioned" do
        expect(d.next).to be_nil
      end
    end

    describe "#previous" do
      it "return the previous content if there is one" do
        expect(c.previous).to be_nil
        expect(a.previous).to eq(c)
        expect(b.previous).to eq(a)
      end

      it "is nil if content is not positioned" do
        expect(d.previous).to be_nil
      end
    end
  end
end
