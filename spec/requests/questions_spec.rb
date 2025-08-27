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

  describe "PATCH /questionnaires/:questionnaire_id/questions/:id" do
    subject(:patch_question) do
      patch questionnaire_question_path(questionnaire_id: questionnaire.id, id: question.id), params: { question.name => answer }
    end
    let(:answer) { question.answers.keys.first }
    it "stores the answer in session" do
      patch_question
      expect(session[:answers].dig(questionnaire.id.to_s, question.id.to_s)).to eq(answer.to_s)
    end

    context "answers have next" do
      let(:questionnaire) { Questionnaire.find(:practical_actions) }
      let(:question) { questionnaire.question(:what_is_your_role) }

      it "redirects to next question" do
        patch_question
        answer_hash = question.answers[answer]
        expect(response).to redirect_to(questionnaire_question_path(questionnaire_id: questionnaire.id, id: answer_hash[:next]))
      end
    end

    context "answers have no next" do
      let(:questionnaire) { Questionnaire.find(:practical_actions) }
      let(:question) { questionnaire.question(:technician_practical_actions) }

      it "redirects to next question" do
        patch_question
        expect(response).to redirect_to(questionnaire_questions_path(questionnaire_id: questionnaire.id))
      end
    end
  end
end
