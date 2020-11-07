json.extract! payment_outstanding, :id, :customer_id, :amount, :due_date, :status, :created_at, :updated_at
json.url payment_outstanding_url(payment_outstanding, format: :json)
