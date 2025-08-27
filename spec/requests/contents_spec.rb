require "rails_helper"

RSpec.describe "Contents", type: :request do
  let(:name) { Content.all.keys.first }
  let(:content) { Content.find(name) }

  describe "GET /index" do
    it "returns http success" do
      get contents_path
      expect(response).to have_http_status(:success)
    end

    it "includes a list of contents" do
      get contents_path
      expect(response.body).to include(content.title)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get content_path(name)
      expect(response).to have_http_status(:success)
    end

    it "includes the content" do
      get content_path(name)
      expect(response.body).to include(content.to_html)
    end
  end
end
