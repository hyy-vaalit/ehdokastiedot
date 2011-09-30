class ResultJob

  def perform
    result = Result.create! # TODO: vain tarvittaessa (päivitä voting_arean status)
    decorator = ResultDecorator.find(result)

    puts decorator.render_text
    # tallenna S3:een
  end
end