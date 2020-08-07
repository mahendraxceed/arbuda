module ApplicationHelper

  def enabled_disabled_label(value, enabled_text: 'Yes', disabled_text: 'No')
    if value
      "<span class='badge badge-primary m-y-1 display-inline-block'>#{enabled_text}</span>".html_safe
    else
      "<span class='badge badge-warning m-y-1 display-inline-block'>#{disabled_text}</span>".html_safe
    end
  end

  def flash_class(level)
    case level.to_sym
    when :notice then "alert alert-success"
    when :success then "alert alert-success"
    when :error then "alert alert-danger"
    when :alert then "alert alert-danger"
    when :warning then "alert alert-warning"
    end
  end

  def flash_prefix(level)
    case level.to_sym
    when :notice then "Success!"
    when :success then "Success!"
    when :error then "Error!"
    when :alert then "Alert!"
    when :warning then "Warning!"
    end
  end

  def convert_status_to_class(status)
    # https://almsaeedstudio.com/themes/AdminLTE/documentation/index.html#component-box
    # used with box class, for example: box-success, here is a list of colors:
    # default primary info warning sucess danger caution
    case status
    when 'approved', 'created_new', 'open', 'in_process', 'reopened', 'amount_refilled', 'feasibility_confirmed', 'cabling_completed', 'account_created', 'account_activation_completed', 'published', 'success', 'sold', 'paid', 'invoiced'
      'success' # green
    when 'assigned', 'reassigned', 'enabled', 'pending', 'feasibility_pending', 'cabling_pending', 'account_activation_pending', 'package_assigned', 'pending', 'accepted'
      'info' # light blue
    when 'package_renewed', 'package_changed', 'resolved', 'payment_received', 'in_stock', 'sent'
      'primary' # dark blue
    when 'terminated', 'closed', 'rent'
      'warning' # yellow
    when 'canceled', 'expired', 'rejected', 'feasibility_failed', 'cabling_failed', 'account_activation_failed', 'disabled', 'failed', 'returned', 'overdue'
      'danger' # red
    when 'data_topped_up'
      'caution' # purple #cc317c
    else
      'default' # silver
    end
  end


end
