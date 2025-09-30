module ApplicationHelper
  def question_partial(question)
    case question.type
    when "text"
      "questions/text_input"
    else
      "questions/radio_input"
    end
  end
end
