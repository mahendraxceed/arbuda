class Constant

  def self.hash_or_error_if_key_does_not_exists(h)
    # https://stackoverflow.com/questions/30528699/why-isnt-an-exception-thrown-when-the-hash-value-doesnt-exist
    # raise if key does not exists h[:non_exists] or h.values_at[:non_exists]
    h.default_proc = -> (_h, k) { raise KeyError, "#{k} not found!" }
    # raise when value not exists h.key 'non_exists'
    def h.key(value)
      k = super
      raise KeyError, "#{value} not found!" unless k
      k
    end
    h
  end

  def self.TICKET_EVENTS
    hash_or_error_if_key_does_not_exists(
        :OPEN                    => 'open',
        :EDIT                    => 'edit',
        :ASSIGN                  => 'assign',
        :REASSIGN                => 'reassign',
        :ACCEPT                  => 'accept',
        :REJECT                  => 'reject',
        :KEEP_PENDING            => 'keep_pending',
        :BACK_TO_IN_PROCESS      => 'back_to_in_process',
        :CANCEL                  => 'cancel',
        :RESOLVE                 => 'resolve',
        :REOPEN                  => 'reopen',
        :CLOSE                   => 'close',
        )
  end

  def self.TICKET_EVENT_LABELS
    hash_or_error_if_key_does_not_exists(
        :OPEN                    => 'Create New Ticket',
        :EDIT                    => 'Update Ticket Details',
        :ASSIGN                  => 'Assign Ticket',
        :REASSIGN                => 'Re-assign Ticket',
        :ACCEPT                  => 'Accept Ticket',
        :REJECT                  => 'Reject Ticket',
        :KEEP_PENDING            => 'Keep Ticket Pending',
        :BACK_TO_IN_PROCESS      => 'Change Back To In Process',
        :CANCEL                  => 'Cancel Ticket',
        :RESOLVE                 => 'Resolve Ticket',
        :REOPEN                  => 'Reopen Ticket',
        :CLOSE                   => 'Close Ticket'
    )
  end

  def self.TICKET_STATUSES
    hash_or_error_if_key_does_not_exists(
        :OPEN                   => 'open',
        #:EDITED                 => 'edited',
        :ASSIGNED               => 'assigned',
        :REASSIGNED             => 'reassigned',
        :REJECTED               => 'rejected',
        :PENDING                => 'pending',
        :IN_PROCESS             => 'in_process',
        :CANCELED               => 'canceled',
        :RESOLVED               => 'resolved',
        :REOPENED               => 'reopened',
        :CLOSED                 => 'closed',
        )
  end

  def self.TICKET_ACTIVE_STATUSES
    Constant.TICKET_STATUSES.values - [Constant.TICKET_STATUSES[:CLOSED], Constant.TICKET_STATUSES[:RESOLVED]]
  end

  def self.TICKET_DUE_BY_SEARCH_OPTIONS
    hash_or_error_if_key_does_not_exists(
        :OVERDUE                => 'Overdue',
        :DUE_BY_TODAY           => 'Due By Today',
        :DUE_BY_TOMORROW        => 'Due By Tomorrow',
        :DUE_IN_NEXT_4_HOURS    => 'Due In Next 4 Hours',
        :DUE_IN_NEXT_8_HOURS    => 'Due In Next 8 Hours'
    )
  end

  def self.TICKET_STATUS_SEARCH_OPTIONS
    hash_or_error_if_key_does_not_exists(
        :OPEN                   => 'Open / Reopened',
        :ASSIGNED               => 'Assigned / Reassigned',
        :REJECTED               => 'Rejected',
        :PENDING                => 'Pending',
        :IN_PROCESS             => 'In Process',
        :CANCELED               => 'Canceled',
        :RESOLVED               => 'Resolved',
        :CLOSED                 => 'Closed'
    )
  end
  def self.PRIORITY_TYPES
    hash_or_error_if_key_does_not_exists(
        :LOW                      => 'a_low',
        :MEDIUM                   => 'b_medium',
        :HIGH                     => 'c_high',
        :URGENT                   => 'd_urgent',
        )
  end

  def self.CATEGORY_TYPES
    hash_or_error_if_key_does_not_exists(
        :INTERNET                 => 'a_internet',
        :CCTV                     => 'b_cctv',
        :PRINTER                  => 'c_printer',
        :COMPUTER                 => 'd_computer',
        :WEIGHT_SCALE             => 'e_weight scale',
        :FAT_MACHINE              => 'f_fat_machine',
        )
  end

end