class Status < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  has_and_belongs_to_many :hashtags, touch: true

  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  validates :description, presence: true
  validates :user, presence: true

  scope :latest, -> { order(created_at: :desc).first }
  scope :today, -> { where("created_at >= ?", Time.zone.now.beginning_of_day) }
  scope :yesterday, -> { where(created_at: Time.zone.yesterday.beginning_of_day.all_day) }

  after_save :update_hashtags

  def self.on(date)
    where(created_at: date.in_time_zone.beginning_of_day.all_day)
  end

  def update_hashtags
    self.hashtags = extract_hashtags.map { |name| Hashtag.find_or_create_by(name: name) }
  end

  def extract_hashtags
    names = description.scan(/(?<=#)[[:alpha:]][[[:alnum:]]-]*/).uniq
    names.each { |name| yield name } if block_given?
    names
  end

  def liked_by?(user)
    likers.include?(user)
  end
end
