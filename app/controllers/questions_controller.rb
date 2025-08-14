class QuestionsController < ApplicationController
  def show
    @question = questionnaire.question(params[:id])
  end

private

  def questionnaire
    @questionnaire ||= Questionnaire.find(params[:questionnaire_id])
  end
end
