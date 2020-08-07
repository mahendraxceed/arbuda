class Complain < ApplicationRecord
  MAX_CUSTOMER_TICKETS_PER_DAY = 3

  FIELDS = %i[
    customer_id person_called assigned_to_id subject description priority category
    due_by status_event comment
  ]

  FIELD_OPTIONS = {
      status_event: Constant.TICKET_EVENTS.values,
      priority: Constant.PRIORITY_TYPES.values,
      category: Constant.CATEGORY_TYPES.values,
  }

  belongs_to :customer,                   inverse_of: :complains
  has_many   :complain_status_transitions, inverse_of: :complain
  belongs_to :assigned_to, class_name: "User", foreign_key: :assigned_to_id, optional: true

  belongs_to :created_by, class_name: "User"
  belongs_to :updated_by, class_name: "User"

  validates_presence_of :ticketid, {message: "Ticket Number cannot be blank"}
  validates_presence_of :subject, {message: "Subject cannot be blank"}
  validates_length_of   :subject, maximum: 100, message: "Cannot be more than 100 characters"
  validates_presence_of :description, {message: "Description cannot be blank"}
  validates_presence_of :status, {message: "Status cannot be blank"}
  validates_presence_of :priority , :category

  validate :due_by_is_valid_and_not_in_past, on: :create

  before_validation { self.ticketid = rand.to_s[2..10] }

  attr_accessor :change_description, :comment

  scope :active, -> {
    where status: Constant.TICKET_ACTIVE_STATUSES
  }

  scope :resolve, -> {
    where status: Constant.TICKET_STATUSES[:RESOLVED]
  }

  scope :open, -> {
    where status: Constant.TICKET_STATUSES[:OPEN]
  }

  scope :assign, -> {
    where status: Constant.TICKET_STATUSES[:ASSIGNED]
  }
  scope :keep_pending, -> {
    where status: Constant.TICKET_STATUSES[:PENDING]
  }

  scope :close, -> {
    where status: Constant.TICKET_STATUSES[:CLOSED]
  }

  scope :register_today, -> {
    where(created_at: Date.today.all_day)
  }
  scope :in_process, -> {
    where status: Constant.TICKET_STATUSES[:IN_PROCESS]
  }

  scope :overdue, -> {
    where('complains.due_by < ?', Time.zone.now)
  }

  state_machine :status, initial: Constant.TICKET_STATUSES[:OPEN] do

    audit_trail context: [:change_description, :comment]

    before_transition on: any do |complain, transition|
      case transition.event
      when Constant.TICKET_EVENTS[:ASSIGN]
        complain.change_description = "Ticket Assigned to #{complain.assigned_to.name} by #{complain.updated_by.name}"
      when Constant.TICKET_EVENTS[:REASSIGN]
        complain.change_description = "Ticket Re-assigned to #{complain.assigned_to.name} by #{complain.updated_by.name}"
      when Constant.TICKET_EVENTS[:KEEP_PENDING]
        complain.change_description = "Ticket Kept Pending by #{complain.updated_by.name}"
      when Constant.TICKET_EVENTS[:BACK_TO_IN_PROCESS]
        complain.change_description = "Ticket status changed back to \"In Process\" by #{complain.updated_by.name}"
      when Constant.TICKET_EVENTS[:CANCEL]
        complain.change_description = "Ticket Canceled by #{complain.updated_by.name}"
      when Constant.TICKET_EVENTS[:RESOLVE]
        complain.change_description = "Ticket Resolved by #{complain.updated_by.name}"
      when Constant.TICKET_EVENTS[:REOPEN]
        complain.change_description = "Ticket Re-opened by #{complain.updated_by.name}"
      when Constant.TICKET_EVENTS[:CLOSE]
        complain.change_description = "Ticket Closed by #{complain.updated_by.name}"
      when Constant.TICKET_EVENTS[:EDIT]
        complain.change_description = "Ticket Details Edited by #{complain.updated_by.name}"
      end
    end

    after_transition any => [Constant.TICKET_STATUSES[:IN_PROCESS], Constant.TICKET_STATUSES[:REASSIGNED]] do |complain, transition|
      if [Constant.TICKET_EVENTS[:ASSIGN], Constant.TICKET_EVENTS[:REASSIGN]].include? transition.event

        Rails.logger.info "test #{complain}"
        SendSmsJob.perform_later complain
      end
    end



    before_transition [Constant.TICKET_STATUSES[:ASSIGNED], Constant.TICKET_STATUSES[:REASSIGNED]] => Constant.TICKET_STATUSES[:IN_PROCESS] do |complain, transition|
      complain.assigned_to = User.find(complain.updated_by.id)
    end

    before_transition [Constant.TICKET_STATUSES[:CANCELED], Constant.TICKET_STATUSES[:RESOLVED]] => Constant.TICKET_STATUSES[:REOPENED] do |complain, transition|
      complain.assigned_to = nil
    end

    after_transition any - Constant.TICKET_STATUSES[:RESOLVED] => [Constant.TICKET_STATUSES[:RESOLVED]] do |complain, transition|
      # if complain.subscriber
      #   PreviewSmsTemplate.new(Constant.SMS_TEMPLATES[:complain_RESOLVED], complain.location.sms_templates).perform_for_item_and_send_to_subscriber complain, complain.subscriber
      # end
    end

    event Constant.TICKET_EVENTS[:ASSIGN] do
      transition [Constant.TICKET_STATUSES[:OPEN],
                  Constant.TICKET_STATUSES[:REOPENED]] => Constant.TICKET_STATUSES[:IN_PROCESS]
    end

    event Constant.TICKET_EVENTS[:REASSIGN] do
      transition [Constant.TICKET_STATUSES[:ASSIGNED],
                  Constant.TICKET_STATUSES[:REASSIGNED],
                  Constant.TICKET_STATUSES[:IN_PROCESS],
                  Constant.TICKET_STATUSES[:REJECTED],
                  Constant.TICKET_STATUSES[:PENDING]] => Constant.TICKET_STATUSES[:IN_PROCESS]
    end

    # event Constant.TICKET_EVENTS[:ACCEPT] do
    #   transition [Constant.TICKET_STATUSES[:ASSIGNED],
    #               Constant.TICKET_STATUSES[:REASSIGNED]] => Constant.TICKET_STATUSES[:IN_PROCESS]
    # end

    # event Constant.TICKET_EVENTS[:REJECT] do
    #   transition [Constant.TICKET_STATUSES[:ASSIGNED],
    #               Constant.TICKET_STATUSES[:REASSIGNED]] => Constant.TICKET_STATUSES[:REJECTED]
    # end

    event Constant.TICKET_EVENTS[:KEEP_PENDING] do
      transition [Constant.TICKET_STATUSES[:IN_PROCESS]] => Constant.TICKET_STATUSES[:PENDING]
    end

    event Constant.TICKET_EVENTS[:BACK_TO_IN_PROCESS] do
      transition [Constant.TICKET_STATUSES[:PENDING]] => Constant.TICKET_STATUSES[:IN_PROCESS]
    end
    event Constant.TICKET_EVENTS[:RESOLVE] do
      transition [Constant.TICKET_STATUSES[:PENDING],
                  Constant.TICKET_STATUSES[:ASSIGNED],
                  Constant.TICKET_STATUSES[:IN_PROCESS]] => Constant.TICKET_STATUSES[:RESOLVED]
    end
    event Constant.TICKET_EVENTS[:CANCEL] do
      transition [Constant.TICKET_STATUSES[:OPEN],
                  Constant.TICKET_STATUSES[:REOPENED],
                  Constant.TICKET_STATUSES[:ASSIGNED],
                  Constant.TICKET_STATUSES[:REASSIGNED],
                  Constant.TICKET_STATUSES[:REJECTED],
                  Constant.TICKET_STATUSES[:PENDING],
                  Constant.TICKET_STATUSES[:IN_PROCESS]] => Constant.TICKET_STATUSES[:CANCELED]
    end



    event Constant.TICKET_EVENTS[:REOPEN] do
      transition [Constant.TICKET_STATUSES[:RESOLVED],
                  Constant.TICKET_STATUSES[:CANCELED]] => Constant.TICKET_STATUSES[:REOPENED]
    end

    event Constant.TICKET_EVENTS[:CLOSE] do
      transition [Constant.TICKET_STATUSES[:RESOLVED],
                  Constant.TICKET_STATUSES[:CANCELED]] => Constant.TICKET_STATUSES[:CLOSED]
    end

    event Constant.TICKET_EVENTS[:EDIT] do
      transition all - Constant.TICKET_STATUSES[:CLOSED] => same
    end

    state Constant.TICKET_STATUSES[:ASSIGNED] do
      validates_presence_of :assigned_to, message: "Please select user to assign the ticket to"
    end

    state Constant.TICKET_STATUSES[:REASSIGNED] do
      validates_presence_of :assigned_to, message: "Please select user to reassign the ticket to"
    end
  end

  def due_by_is_valid_and_not_in_past
    if !self.due_by.present?
      errors.add(:due_by, "Please enter the due by date time")
    elsif self.due_by < Time.zone.now
      errors.add(:due_by, "Can't be in the past")
    end
  end

end
