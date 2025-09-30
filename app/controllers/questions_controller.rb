class QuestionsController < ApplicationController
  def index
    @report = session[:answers].dup
    @score = session[:score].dup
  end

  def show
    question
  end

  def update
    session[:answers] ||= {}
    session[:answers][questionnaire.id.to_s] ||= {}
    session[:answers][questionnaire.id.to_s][question.id.to_s] = selected_answer
    session[:score] ||= 0
    session[:score] += answer[:score] if answer && answer[:score].present?

    redirect_to next_question_path || result_page_path
  end

private

  def questionnaire
    @questionnaire ||= Questionnaire.find(params[:questionnaire_id])
  end

  def question
    @question ||= questionnaire.question(params[:id])
  end

  def answer
    question.answers[selected_answer.to_sym] if question.answers.present?
  end

  def selected_answer
    params[question.id]
  end

  # if next is in form "one/two" next is to questionnaire one, question two
  # if next is in form "three" next is to question three of current questionnaire
  def next_question_path
    next_path = (answer && answer[:next]) || question.next.presence
    return if next_path.blank?

    elements = next_path.split("/")
    elements.unshift(questionnaire.id) if elements.size == 1

    if elements[0] == "content"
      content_path(elements[1])
    else
      questionnaire_question_path(
        questionnaire_id: elements[0],
        id: elements[1],
      )
    end
  end

  def result_page_path
    questionnaire_questions_path(questionnaire_id: questionnaire.id)
  end
end
