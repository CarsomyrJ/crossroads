class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include Gravtastic
  gravtastic

  belongs_to :team, counter_cache: true

  has_many :statuses, dependent: :destroy
  has_many :hashtags, through: :statuses
  has_many :likes, dependent: :destroy
  has_many :liked_statuses, through: :likes, source: :status

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: { scope: :team_id }
  validates :team, presence: true
  validates :timezone, presence: true, inclusion: { in: ActiveSupport::TimeZone.zones_map(&:name).keys }

  scope :sort_by_contributions, -> {
    joins(:hashtags)
      .select("users.*", "count(users.id) as contributions")
      .group("users.id")
      .order("contributions desc")
  }

  before_create { self.timezone ||= Rails.application.config.time_zone }

  def self.active(date)
    includes(:statuses)
      .where(statuses: { created_at: date.in_time_zone.beginning_of_day.all_day })
      .order("statuses.created_at desc")
  end

  def self.inactive(date)
    active_ids = active(date).ids
    if active_ids.empty?
      order(:first_name)
    else
      where.not(id: active_ids).order(:first_name)
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def like!(status)
    liked_statuses << status unless likes?(status)
  end

  def unlike!(status)
    liked_statuses.destroy(status)
  end

  def likes?(status)
    liked_statuses.include?(status)
  end
end
