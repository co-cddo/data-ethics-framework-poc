require "rails_helper"

RSpec.describe "Quesionnaire questons", type: :request do
  let(:raw) do
    path = Dir.glob(Rails.root.join("data/questionnaires/*.yml")).sample
    YAML.load_file(path, symbolize_names: true)
  end
  let(:name) { raw[:questions].keys.sample }
  let(:questionnaire) { Questionnaire.find(raw[:name]) }
  let(:question) { questionnaire.question(name) }

  describe "GET /questionnaires/:questionnaire_id/questions/:id" do
    it "returns http success" do
      get questionnaire_question_path(questionnaire_id: questionnaire.id, id: question.id)
      expect(response).to have_http_status(:success)
    end

    it "includes the content" do
      get questionnaire_question_path(questionnaire_id: questionnaire.id, id: question.id)
      expect(response.body).to include(question.title)
    end
  end
end
