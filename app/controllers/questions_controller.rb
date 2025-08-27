class QuestionsController < ApplicationController
  def index
    @report = session[:answers].dup
  end

  def show
    question
  end

  def update
    session[:answers] ||= {}
    session[:answers][questionnaire.id.to_s] ||= {}
    session[:answers][questionnaire.id.to_s][question.id.to_s] = answer

    next_question = question.answers.dig(answer.to_sym, :next)
    path = if next_question
             questionnaire_question_path(questionnaire_id: questionnaire.id, id: next_question)
           else
             questionnaire_questions_path(questionnaire_id: questionnaire.id)
           end
    redirect_to path
  end

private

  def questionnaire
    @questionnaire ||= Questionnaire.find(params[:questionnaire_id])
  end

  def question
    @question ||= questionnaire.question(params[:id])
  end

  def answer
    params[question.id]
  end
end
