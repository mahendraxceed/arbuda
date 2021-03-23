class ComplainsDatatable < TrkDatatables::ActiveRecord
  def columns
    {

      'customers.name': {title: 'Customer'},
      'complains.ticketid': {},
      'complains.person_called': {title: 'person'},
      'users.name': {title: 'Assigned To', select_options: User.all},
      'complains.subject': {},
      'complains.created_at': { },

      'complains.priority': {},

      'complains.category': {},
      'complains.status': {  },


    }
  end

  def global_search_columns
    # in addition to columns those fields will be used to match global search
    %w[users.name customers.name]
  end

  def all_items
    # you can use @view.params
    if @view.current_user.admin?
      all_tickets = Complain.includes(:assigned_to, :customer).references(:users, :customers)
      if @view.params[:customer_id].present?
        all_tickets = all_tickets.where(customer_id: @view.params[:customer_id])
      end
      case @view.params[:non_table_filter]
      when "registered_today"
        all_tickets = all_tickets.register_today
      when "overdue"
        all_tickets = all_tickets.overdue
      end
      return all_tickets
    else
      all_tickets = Complain.includes(:assigned_to, :customer).references(:users, :customers)
      all_tickets = all_tickets.where(assigned_to: @view.current_user.id)
      if @view.params[:customer_id].present?
        all_tickets = all_tickets.where(customer_id: @view.params[:customer_id])
      end
      case @view.params[:non_table_filter]
      when "registered_today"
        all_tickets = all_tickets.register_today
      when "overdue"
        all_tickets = all_tickets.overdue
      end
      return all_tickets
    end

  end

  def rows(filtered)
    # you can use @view.link_to and other helpers
    filtered.map do |complain|
      assigned = if complain.assigned_to.present?
                   @view.link_to complain.assigned_to.name, @view.user_path(complain.assigned_to)
                 else
                   complain.assigned_to.to_s
                 end
      priority = complain.priority[2..-1].capitalize
      category = complain.category[2..-1].capitalize
      status_label = "<span class='badge badge-#{ @view.convert_status_to_class(complain.status) }'>#{ complain.status.titleize }</span>".html_safe
      [

        @view.link_to(complain.customer.name, complain.customer),
        @view.link_to(complain.ticketid, complain),
        complain.person_called,
        assigned,
        complain.subject,
        complain.created_at.to_date.to_s,
        priority,

        category,
        status_label,

      ]
    end
  end
end
