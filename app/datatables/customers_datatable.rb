class CustomersDatatable < TrkDatatables::ActiveRecord
  def columns
    {
      'customers.id': {},
      'customers.name': {},
      'customers.mobile': {},
      'customers.alt_mobile': {},
      'customers.address': {},
    }
  end

  def all_items
    # you can use @view.params
    Customer.all
  end

  def rows(filtered)
    # you can use @view.link_to and other helpers
    filtered.map do |customer|
      [
        @view.link_to(customer.id, customer),
        @view.link_to(customer.name, customer),
        customer.mobile,
        customer.alt_mobile,
        customer.address,
      ]
    end
  end
end
