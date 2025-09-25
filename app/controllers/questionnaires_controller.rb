class QuestionnairesController < ApplicationController
  # GET /questionnaires
  def index
    @questionnaires = Questionnaire.all
  end

  # GET /questionnaires/1
  def show
    questionnaire
  end

  # PATCH/PUT /questionnaires/1
  def update
    render json: params
  end

private

  def questionnaire
    @questionnaire ||= Questionnaire.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def questionnaire_params
    params.expect(questionnaire:)
  end
end
