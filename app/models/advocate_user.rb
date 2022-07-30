class AdvocateUser < ActiveRecord::Base
  has_many :electoral_alliances, :foreign_key => :primary_advocate_id

  belongs_to :advocate_team, optional: true
  has_one :electoral_coalition, through: :advocate_team

  validates_presence_of :student_number, :email, :firstname, :lastname

  validates_uniqueness_of :email, :student_number
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  scope :without_advocate_team, -> { where(advocate_team_id: nil) }

  after_create :send_welcome_email

  def friendly_name
    "#{firstname} #{lastname}"
  end

  protected

  def send_welcome_email
    RegistrationMailer.welcome_advocate(email).deliver
  end
end
