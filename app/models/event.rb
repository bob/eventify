class Event < ActiveRecord::Base

  PRIORITIES = [["high", 1], ["medium", 2], ["low", 3]]
  
  validates_presence_of :title
  validates_inclusion_of :priority, :in => [1, 2, 3]
  
  attr_accessible :title, :priority, :due

  def mark_as_done
    self.update_attribute(:done, true)
  end
     
  def unmark_as_done
    self.update_attribute(:done, false)
  end  
  
  private
  def self.fetch_for_period(left, right)
    self.find(:all, :conditions => ["due >= ? AND due < ?", left, right], :order => "priority, due")
  end
end
