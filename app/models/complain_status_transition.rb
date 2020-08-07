class ComplainStatusTransition < ApplicationRecord

  belongs_to :complain, :inverse_of =>  :complain_status_transitions

  before_create {
    self.change_description = "New Complain Created by #{self.complain.created_by.name}" unless self.change_description.present?
  }
end
