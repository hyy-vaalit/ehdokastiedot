class CreateFreezedResultJob

  def perform
    puts "Creating the Freezed Result (it will not be stored as a text)"
    Result.create_freezed!
  end

end